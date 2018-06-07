# Install the packages that HIL needs
set -ex
sudo yum install epel-release -y ||exit 1

sudo yum install git bridge-utils gcc httpd ipmitool libvirt libxml2-devel libxslt-devel mod_wsgi net-tools python-pip python-psycopg2 python-virtualenv qemu-kvm vconfig virt-install -y ||exit 1
sudo pip install --upgrade pip ||exit 1
sudo -H pip install -U pip setuptools ||exit 1

echo "Finished installing packages"
