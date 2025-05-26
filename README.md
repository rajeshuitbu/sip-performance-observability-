# Sip-Performance-observability-
# SIP Call Monitoring with SIPp, Asterisk, Prometheus, Grafana, and Telegraf

This project sets up a complete SIP call monitoring solution using:

* **SIPp** to simulate SIP traffic.
* **Asterisk** as the SIP server.
* **Telegraf** with custom scripts to export SIP stats.
* **Prometheus** for scraping metrics.
* **Grafana** for visualizing SIP call KPIs.

---

## 📦 Components & Installation

### 1. Asterisk Installation

```bash
sudo apt update
sudo apt install -y asterisk
```

Configure basic Asterisk SIP accounts in `/etc/asterisk/pjsip.conf` and dialplans in `/etc/asterisk/extensions.conf`.

### 2. SIPp Installation

```bash
sudo apt install -y sipp
```

Alternatively, build from source if more control is needed.

### 3. Prometheus

```bash
wget https://github.com/prometheus/prometheus/releases/latest/download/prometheus-*.linux-amd64.tar.gz
# Extract and move to /opt/prometheus, configure prometheus.yml
```

### 4. Grafana

```bash
sudo apt install -y software-properties-common
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
sudo apt update
sudo apt install grafana
```

### 5. Telegraf

```bash
sudo apt install -y telegraf
```

Enable the exec plugin in `/etc/telegraf/telegraf.conf`:

```toml
[[inputs.exec]]
  commands = ["/usr/src/sipp/docs/sipp_stats_combined.sh"]
  timeout = "5s"
  data_format = "prometheus"
```

---
## 📁 File Structure

```
/usr/src/sipp/docs/
├── sipp_stats_combined.sh   # Exports SIP stats in Prometheus format
├── uac_new.xml              # SIPp scenario file
├── uac_new_*.csv            # Auto-generated stats CSV
├── uac_new_*.log            # SIPp logs
```

---

## 📜 SIPp Command

Run SIPp with:
sipp -sf uac_new.xml 172.31.17.9:5060 -s 1000 -p 5090 -m 1000 -trace_msg -trace_logs -trace_err

```
Above file will generate the latest CSV file and below script fetch the data from CSV 

---

## 🧠 `sipp_stats_combined.sh`

Parses latest `uac_*.csv` and logs to export metrics:

* `sipp_successful_calls`
* `sipp_failed_calls`
* `sipp_retransmissions`
* `sipp_call_duration_seconds`
* `sipp_msg_invite`, `sipp_msg_ack`, etc.

Place in `/usr/src/sipp/docs/sipp_stats_combined.sh` and make it executable:

```bash
chmod +x /usr/src/sipp/docs/sipp_stats_combined.sh
```

---

## 📊 Grafana Dashboard

* Add Prometheus as a data source.
* Create panels using metrics exposed:

  * Call Success/Failure
  * Call Duration
  * SIP Message Counts
  * Retransmission Rate

---

## ✅ Features

* Total and failed call count
* SIP response breakdown
* Retransmission tracking
* Message type distribution
* Histogram for call duration


---

## 🤝 Contributions

Pull requests welcome! Please open an issue first to discuss your ideas.
