#!/bin/bash

DIR="/usr/src/sipp/docs"

# Update symlink to latest CSV file
latest_csv=$(ls -1t "$DIR"/uac_*.csv | head -n 1)
ln -sf "$latest_csv" "$DIR/sipp_stats.csv"
echo "# Updated symlink: sipp_stats.csv -> $latest_csv"

# Read header and latest data line from CSV (semicolon separated)
header=$(head -n 1 "$DIR/sipp_stats.csv")
data=$(tail -n 1 "$DIR/sipp_stats.csv")

# Split header and data on ';' delimiter
IFS=';' read -r -a headers <<< "$header"
IFS=';' read -r -a fields <<< "$data"

# Helper function to get index of a column by name
get_index() {
    local col="$1"
    for i in "${!headers[@]}"; do
        if [[ "${headers[$i]}" == "$col" ]]; then
            echo "$i"
            return
        fi
    done
    echo "-1"
}

# Extract main call metrics from CSV
successful_calls_idx=$(get_index "SuccessfulCall(C)")
failed_calls_idx=$(get_index "FailedCall(C)")
retransmissions_idx=$(get_index "Retransmissions(C)")
call_length_idx=$(get_index "CallLength(C)")

successful_calls=0
failed_calls=0
retransmissions=0
call_length_sec=0

if [[ $successful_calls_idx -ge 0 ]]; then
    successful_calls=$(echo "${fields[$successful_calls_idx]}" | xargs)
fi
if [[ $failed_calls_idx -ge 0 ]]; then
    failed_calls=$(echo "${fields[$failed_calls_idx]}" | xargs)
fi
if [[ $retransmissions_idx -ge 0 ]]; then
    retransmissions=$(echo "${fields[$retransmissions_idx]}" | xargs)
fi
if [[ $call_length_idx -ge 0 ]]; then
    # CallLength format is HH:MM:SS:mmmm (like 00:00:06:052000)
    call_length_raw=$(echo "${fields[$call_length_idx]}" | xargs)
    # Convert to seconds with microseconds as fraction
    IFS=':' read -r hh mm ss_us <<< "$call_length_raw"
    # ss_us is seconds + microseconds, e.g. 06:052000 (should be split)
    # Let's split seconds and microseconds
    sec_part=${ss_us:0:2}
    micro_part=${ss_us:3}  # after the colon
    # But in your data, looks like call length is 00:00:06:052000, so parts are 4 fields
    # So better split into 4 parts:
    IFS=':' read -r hh mm ss micro <<< "$call_length_raw"
    # Calculate total seconds = hh*3600 + mm*60 + ss + micro/1_000_000
    call_length_sec=$(awk -v h=$hh -v m=$mm -v s=$ss -v micro=$micro 'BEGIN {print h*3600 + m*60 + s + micro/1000000}')
fi

# Find latest messages log file (for SIP message counts)
latest_log=$(ls -1t "$DIR"/uac_new_*_messages.log | head -n 1)

# Count SIP messages in the latest message log file (case-insensitive whole word match)
invite_count=$(grep -oiE '\bINVITE\b' "$latest_log" | wc -l)
ack_count=$(grep -oiE '\bACK\b' "$latest_log" | wc -l)
register_count=$(grep -oiE '\bREGISTER\b' "$latest_log" | wc -l)
ok200_count=$(grep -oiE 'SIP/2\.0 200 OK' "$latest_log" | wc -l)
bye_count=$(grep -oiE '\bBYE\b' "$latest_log" | wc -l)
cancel_count=$(grep -oiE '\bCANCEL\b' "$latest_log" | wc -l)

# Output Prometheus metrics with help and type comments
cat <<EOF
# HELP sipp_successful_calls Total successful calls
# TYPE sipp_successful_calls gauge
sipp_successful_calls $successful_calls

# HELP sipp_failed_calls Total failed calls
# TYPE sipp_failed_calls gauge
sipp_failed_calls $failed_calls

# HELP sipp_retransmissions Total retransmissions
# TYPE sipp_retransmissions gauge
sipp_retransmissions $retransmissions

# HELP sipp_call_duration_seconds Average call duration in seconds
# TYPE sipp_call_duration_seconds gauge
sipp_call_duration_seconds $call_length_sec

# HELP sipp_msg_invite SIP INVITE messages
# TYPE sipp_msg_invite counter
sipp_msg_invite $invite_count

# HELP sipp_msg_ack SIP ACK messages
# TYPE sipp_msg_ack counter
sipp_msg_ack $ack_count

# HELP sipp_msg_register SIP REGISTER messages
# TYPE sipp_msg_register counter
sipp_msg_register $register_count

# HELP sipp_msg_200ok SIP 200 OK responses
# TYPE sipp_msg_200ok counter
sipp_msg_200ok $ok200_count

# HELP sipp_msg_bye SIP BYE messages
# TYPE sipp_msg_bye counter
sipp_msg_bye $bye_count

# HELP sipp_msg_cancel SIP CANCEL messages
# TYPE sipp_msg_cancel counter
sipp_msg_cancel $cancel_count
EOF
