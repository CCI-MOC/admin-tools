release=mimic
tput bold
if [ -z ${1+x} ]; then echo Will use default release - $release; else release=$1;echo Will use custom release - $release;fi
tput sgr0
grep timeout /etc/yum.conf &> /dev/null || sudo sh -c 'echo "timeout=5" >> /etc/yum.conf'
grep options /etc/resolv.conf &> /dev/null || sudo sh -c 'echo "options single-request" >> /etc/resolv.conf'
sudo yum -y install epel-release deltarpm
sudo yum -y update
sudo yum -y install http://download.ceph.com/rpm-$release/el7/noarch/ceph-release-1-1.el7.noarch.rpm
sudo yum -y install ceph-common
clear
tput bold
echo Now copy ceph.conf and key from /etc/ceph/ from a ceph server to cleint /etc/ceph
tput sgr0
