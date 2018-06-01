sudo chkconfig firewalld off &> /dev/null
sudo service firewlld stop &> /dev/null
grep timeout /etc/yum.conf &> /dev/null || sudo sh -c 'echo "timeout=5" >> /etc/yum.conf'
grep options /etc/resolv.conf &> /dev/null || sudo sh -c 'echo "options single-request" >> /etc/resolv.conf'
sudo yum -y install epel-release lvm2 virt-what deltarpm&> /dev/null||exit
dev=sdb
[ "`sudo virt-what`" == "kvm" ] && dev=vdb
sudo virt-what | grep xen &> /dev/null && dev=xvdb
sudo ls -l /dev/$dev &> /dev/null || echo No device $dev, fix and then try again
sudo ls -l /dev/$dev &> /dev/null || exit
sudo fdisk -l /dev/$dev|grep -iv disk|grep /dev/$dev &> /dev/null && echo Device $dev not empty, fix and try again
sudo fdisk -l /dev/$dev|grep -iv disk|grep /dev/$dev &> /dev/null && exit
sudo pvdisplay | grep /dev/$dev &> /dev/null && echo Device $dev not empty, fix and try again
sudo pvdisplay | grep /dev/$dev &> /dev/null && exit
sudo yum -y update
sudo yum -y install https://download.ceph.com/rpm-luminous/el7/noarch/ceph-release-1-1.el7.noarch.rpm
sudo yum -y install ceph-deploy ceph-mon ceph-osd ceph-mgr ceph-mds htop mc||exit
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
[mon]
mon_compact_on_start = true
mon_allow_pool_delete = true
mgr_initial_modules = dashboard
osd_pool_default_size = 1
" >ceph.conf

sudo ceph-deploy --overwrite-conf mon create-initial
sudo /bin/cp ceph.client.admin.keyring /etc/ceph/
sudo ceph-deploy --overwrite-conf mgr create `hostname -s`
sudo ceph-deploy --overwrite-conf mds create `hostname -s`
sudo ceph-deploy --overwrite-conf osd create --data /dev/$dev `hostname -s`
sudo ceph osd pool create bmi 32
sudo ceph osd pool create cephfs 16
sudo ceph osd pool create cephfsmeta 8
until sudo ceph -s|grep 'pgs:     56 active+clean' &> /dev/null; do sleep 1;done
sleep 5
sudo ceph fs new cephfs cephfsmeta cephfs
clear
sudo ceph -s
sudo ceph df
sudo ceph fs ls
