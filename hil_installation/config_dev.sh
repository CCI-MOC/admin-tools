# This configures it for development
echo "Configuring the environment for development"
set -ex
sudo cp hil/examples/hil.cfg.dev-no-hardware /etc/hil.cfg --force

# add postgresql uri information
sudo sed -i "s|sqlite:///hil.db|postgresql://hil:hello@localhost:5432/hil|g" /etc/hil.cfg

# enable vlan_pool network allocator
sudo sed -i "s|hil.ext.network_allocators.null|hil.ext.network_allocators.vlan_pool|g" /etc/hil.cfg
sudo sh -c 'echo "[hil.ext.network_allocators.vlan_pool]" >> /etc/hil.cfg'
sudo sh -c 'echo "vlans = 1510-1520" >> /etc/hil.cfg'

# enable database authentication
sudo sed -i "s|hil.ext.auth.null|hil.ext.auth.database|g" /etc/hil.cfg

sudo -i -u hil hil-admin db create
sudo -i -u hil hil-admin create-admin-user admin potatoes

export HIL_USERNAME=admin
export HIL_PASSWORD=potatoes
export HIL_ENDPOINT='http://127.0.0.1:80'

sudo service httpd restart
sudo service hil_network.service start
echo "done with everything"
