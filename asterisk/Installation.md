# asterisk


#Install Asterisk on Ubuntu/Debian

sudo apt update
sudo apt install -y build-essential wget libjansson-dev libxml2-dev uuid-dev libssl-dev libsqlite3-dev

# Download latest stable Asterisk source (replace version as needed)
cd /usr/src
sudo wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-20-current.tar.gz

sudo tar zxvf asterisk-20-current.tar.gz
cd asterisk-20*/

# Install required dependencies and build Asterisk
sudo contrib/scripts/install_prereq install
sudo ./configure
sudo make menuselect # (optional) select modules, codecs, etc.
sudo make
sudo make install
sudo make samples
sudo make config

# Enable Asterisk to start at boot
sudo systemctl enable asterisk
sudo systemctl start asterisk


