# grafana


Grafana Setup for SIP Observability
This folder contains installation steps and dashboard configuration to visualize SIP metrics (calls, SIP messages, response codes, duration, failures) using Grafana, fed by Telegraf via Prometheus.

🧰 1. Install Grafana on Ubuntu
bash
Copy
Edit
sudo apt-get install -y apt-transport-https software-properties-common wget

wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -

echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee /etc/apt/sources.list.d/grafana.list

sudo apt-get update
sudo apt-get install grafana

sudo systemctl enable grafana-server
sudo systemctl start grafana-server
🛠️ 2. Access Grafana UI
Open in browser:

cpp
Copy
Edit
http://<GRAFANA_SERVER_IP>:3000
Default login:

Username: admin

Password: admin (prompted to change)

🔗 3. Connect Prometheus as Data Source
Go to ⚙️ Settings → Data Sources → Add data source → Prometheus

Set URL:

cpp
Copy
Edit
http://<PROMETHEUS_SERVER_IP>:9090
Click Save & Test

📊 4. Import SIP Observability Dashboard
Go to + → Import

Upload or paste JSON from grafana/sip_dashboard.json

Select Prometheus as the data source

Click Import

Dashboard Panels Include:

📈 Total Calls Attempted, Successful, Failed

📊 SIP Messages (INVITE, ACK, BYE, 200 OK, etc.)

⏱ Call Duration Histogram

⚠ Failure Breakdown by Response Code

🔄 Retransmissions and PSS Failures

🧾 5. Folder Contents
pgsql
Copy
Edit
grafana/
├── README.md
└── sip_dashboard.json       # Grafana dashboard JSON

