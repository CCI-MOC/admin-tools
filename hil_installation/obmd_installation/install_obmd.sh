# Installing OBMd
set -ex

sudo yum install -y wget

# Download OBMd v0.1, make it executable and place it in `/bin`
wget https://github.com/CCI-MOC/obmd/releases/download/v0.1/obmd
chmod +x obmd
sudo mv obmd /bin

# create a database for obmd
sudo -u hil createdb obmd

# Copy the configuration file 
sudo mkdir -p /etc/obmd/ &> /dev/null
sudo cp config.json /etc/obmd/
sudo chown hil:hil /etc/obmd/config.json

# copy the obmd service file
sudo cp obmd.service /usr/lib/systemd/system

sudo systemctl daemon-reload
sudo systemctl enable obmd.service
sudo systemctl restart obmd.service

echo "OBMd installation complete"
