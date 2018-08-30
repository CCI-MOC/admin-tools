# Install HIL
set -ex
# Disable SELinux
sudo setenforce 0
sudo sed -i "s|SELINUX=enforcing|SELINUX=permissive|g" /etc/selinux/config

# Add a hil system user named hil
sudo useradd --system hil -d /var/lib/hil -m -r || true

# git clone and install hil
git clone https://github.com/cci-moc/hil ||exit 1
cd hil
sudo pip install .

# copy hil config file and create a symbolic link
sudo cp examples/hil.cfg /etc/hil.cfg
sudo chown hil:hil /etc/hil.cfg
sudo ln -s -f /etc/hil.cfg /var/lib/hil/.

# copy the hil wsgi file
sudo mkdir -p /var/www/hil &> /dev/null
sudo cp hil.wsgi /var/www/hil/

# copy the hil_network service and the create_bridges service
sudo cp scripts/hil_network.service /usr/lib/systemd/system
sudo cp scripts/create_bridges.service /usr/lib/systemd/system
sudo cp ../wsgi.conf /etc/httpd/conf.d/ --force

# enable the services, but don't start them yet.
sudo systemctl daemon-reload
sudo systemctl enable hil_network.service
sudo systemctl enable create_bridges.service
sudo systemctl enable httpd

# start httpd though
sudo systemctl restart httpd

echo "Hil installation complete"
