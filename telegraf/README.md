# telegraf
#Install Telegraf on Ubuntu:

wget -qO- https://repos.influxdata.com/influxdata-archive.key | sudo gpg --dearmor -o /usr/share/keyrings/influxdata-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/influxdata-archive-keyring.gpg] https://repos.influxdata.com/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/influxdata.list

sudo apt update
sudo apt install telegraf

#Telegraf Configuration
Create or modify /etc/telegraf/telegraf.conf to enable the exec input and prometheus_client output:
# Custom SIP Stats Script (sipp_stats_combined.sh)
This script parses SIPp .csv and .log files to extract real-time SIP call stats:

Save it to /usr/local/bin/sipp_stats_combined.sh and make it executable:
####

Example metrics it exposes:

sipp_successful_calls

sipp_failed_calls

sipp_retransmissions

sipp_call_duration_seconds

sipp_msg_invite

sipp_msg_ack

sipp_msg_bye, etc.


4. Start and Verify Telegraf

Verify metrics are exposed at:
http://<TELEGRAF_SERVER_IP>:9273/metrics


# HELP sipp_successful_calls Total successful calls
# TYPE sipp_successful_calls gauge
sipp_successful_calls 98
...


