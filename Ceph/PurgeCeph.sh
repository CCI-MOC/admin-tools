sudo ceph-deploy purge localhost
sudo ceph-deploy purgedata localhost
sudo ceph-deploy forgetkeys
rm -rf ceph.*
sudo yum -y remove "ceph-*"
