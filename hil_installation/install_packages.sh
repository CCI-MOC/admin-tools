# Install the packages that HIL needs
set -ex
sudo yum install epel-release -y

sudo yum install git bridge-utils gcc httpd ipmitool libvirt libxml2-devel libxslt-devel mod_wsgi net-tools python-pip python-psycopg2 python-virtualenv qemu-kvm vconfig virt-install -y
sudo pip install --upgrade pip
sudo -H pip install -U pip setuptools

echo "Finished installing packages"
