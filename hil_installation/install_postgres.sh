# This installs and configures postgres for HIL
echo "Installing and configuring postgres now"
set -ex
sudo yum install postgresql-server postgresql-contrib -y
sudo postgresql-setup initdb ||true

sudo sed -i 's|ident|md5|g' /var/lib/pgsql/data/pg_hba.conf

sudo systemctl restart postgresql
sudo systemctl enable postgresql

sudo -u postgres createuser -r -d -P hil ||true

sudo -u hil dropdb hil ||true
sudo -u hil createdb hil
echo "Done installing postgres"
