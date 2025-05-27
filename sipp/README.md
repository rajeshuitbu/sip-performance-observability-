# sipp
SIPp Installation (Ubuntu/Debian)

# Install dependencies
sudo apt update
sudo apt install -y gcc make libpcap-dev libssl-dev libncurses5-dev git

# Clone and build SIPp
cd /usr/src/
sudo git clone https://github.com/SIPp/sipp.git
cd sipp
sudo make pcapplay
sudo make install

### Run the SIPP 

sipp -sf uac_new.xml 172.31.17.9:5060 -s 1000 -p 5090 -m 1000 -trace_msg -trace_logs -trace_err

