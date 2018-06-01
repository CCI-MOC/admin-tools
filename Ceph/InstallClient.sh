sudo -i
grep timeout /etc/yum.conf &> /dev/null || sudo sh -c 'echo "timeout=5" >> /etc/yum.conf'
grep options /etc/resolv.conf &> /dev/null || sudo sh -c 'echo "options single-request" >> /etc/resolv.conf'
yum -y install epel-release deltarpm
yum -y update
yum -y install http://download.ceph.com/rpm-luminous/el7/noarch/ceph-release-1-1.el7.noarch.rpm
yum -y install ceph-common
clear
echo Now copy ceph.conf and key from /etc/ceph/ on a ceph server to cleint /etc/ceph
