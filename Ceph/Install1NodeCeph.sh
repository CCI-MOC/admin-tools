release=nautilus
osver=`grep -i version_id /etc/os-release | cut -d \" -f 2`
tput bold
if [ -z ${1+x} ]; then echo Will use default release - $release; else release=$1;echo Will use custom release - $release;fi
tput sgr0
grep timeout /etc/yum.conf &> /dev/null || sudo sh -c 'echo "timeout=5" >> /etc/yum.conf'
#grep options /etc/resolv.conf &> /dev/null || sudo sh -c 'echo "options single-request" >> /etc/resolv.conf'
sudo yum -y install lvm2 virt-what pciutils &> /dev/null||exit
grep 'Red Hat' /etc/redhat-release &> /dev/null || sudo yum -y install epel-release &> /dev/null || exit
dev=sdb
[ "`sudo virt-what`" == "kvm" ] && dev=vdb
sudo virt-what | grep xen &> /dev/null && dev=xvdb
sudo lspci | grep 'Elastic Network Adapter' &> /dev/null && dev=nvme1n1
sudo lspci | grep 'Virtio SCSI' &> /dev/null && dev=sdb
sudo ls -l /dev/$dev &> /dev/null || echo No device $dev, fix and then try again
sudo ls -l /dev/$dev &> /dev/null || exit
sudo fdisk -l /dev/$dev|grep -iv disk|grep /dev/$dev &> /dev/null && echo Device $dev not empty, fix and try again
sudo fdisk -l /dev/$dev|grep -iv disk|grep /dev/$dev &> /dev/null && exit
sudo pvdisplay | grep /dev/$dev &> /dev/null && echo Device $dev not empty, fix and try again
sudo pvdisplay | grep /dev/$dev &> /dev/null && exit
sudo yum -y install https://download.ceph.com/rpm-$release/el$osver/noarch/ceph-release-1-1.el$osver.noarch.rpm
sudo yum -y remove firewalld
sudo yum -y update
yum -y install ceph-deploy || yum -y install http://download.ceph.com/rpm-octopus/el7/noarch/ceph-deploy-2.0.1-0.noarch.rpm || exit
sudo yum -y install ceph-mgr-dashboard ceph-mon ceph-osd ceph-mgr ceph-mds ceph-radosgw htop mc||exit
ipaddr=`sudo ip route get $(sudo ip route show 0.0.0.0/0 | grep -oP "via \K\S+") | grep -oP "src \K\S+"`
uuid=`uuidgen`
sudo grep $ipaddr /etc/hosts &> /dev/null || sudo sh -c "echo $ipaddr `hostname -s` >> /etc/hosts"

[ -f ceph.conf ] || echo "[global]
fsid = $uuid
mon_initial_members = `hostname -s`
mon_host = $ipaddr
auth_cluster_required = cephx
auth_service_required = cephx
auth_client_required = cephx
max_open_files = 131072
rbd_default_features = 5
osd_pool_default_size = 1

[mon]
mon_compact_on_start = true
mon_allow_pool_delete = true
mgr_initial_modules = dashboard status
osd_pool_default_size = 1
" >ceph.conf

sudo ceph-deploy --overwrite-conf mon create-initial
sudo /bin/cp ceph.client.admin.keyring /etc/ceph/
sudo ceph-deploy --overwrite-conf mgr create `hostname -s`
sudo ceph-deploy --overwrite-conf mds create `hostname -s`
sudo ceph-deploy --overwrite-conf rgw create `hostname -s`
sudo ceph-deploy --overwrite-conf osd create --data /dev/$dev `hostname -s`
sudo ceph mgr module enable dashboard
sudo ceph dashboard set-login-credentials ceph ceph &> /dev/null
sudo ceph dashboard create-self-signed-cert  &> /dev/null
sudo ceph mgr module disable dashboard
sudo ceph mgr module enable dashboard
sudo radosgw-admin user create --uid=sysadmin --display-name=sysadmin --system
acckey=$(sudo radosgw-admin user info --uid=sysadmin | grep access_key|cut -d '"' -f 4)
seckey=$(sudo radosgw-admin user info --uid=sysadmin | grep secret_key|cut -d '"' -f 4)
sudo ceph dashboard set-rgw-api-access-key $acckey &>/dev/null
sudo ceph dashboard set-rgw-api-secret-key $seckey &>/dev/null
sudo ceph osd pool create bmi 32
sudo ceph osd pool create cephfs 16
sudo ceph osd pool create cephfsmeta 8
until sudo ceph -s|grep 'pgs:     184 active+clean' &> /dev/null; do sleep 1;done
sudo ceph osd pool application enable bmi rbd
sudo ceph osd pool application enable cephfs cephfs
sudo ceph osd pool application enable cephfsmeta cephfs
sudo ceph fs new cephfs cephfsmeta cephfs
sleep 5
clear
sudo ceph -s
sudo ceph df
sudo ceph fs status
