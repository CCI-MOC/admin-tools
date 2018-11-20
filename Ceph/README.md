# Scripts to install ceph on 1 node(physical or VM) and client(s)

## General
* Do not use if there are old (half)working ceph installation attempts, wipe clean and reinstall OS first.
* Server must have 2 H(V)DDs - one for the operating system and one for ceph storage.
* Before running the script make sure second block device is cleared - no existing partitions or LVM sigantures. If script complains hdd is not empty use wipefs to clear it and run it again.
* **Ceph Dashboard**
  - **Luminous version runs on port 7000, http, no authentication is requred**
  - **Mimic version runs on port 8080, https, authentication is required. Script configures username and password as ceph**

## RHEL7
* 2018-11-20 Adding support for RHEL7 using MOC internal repos. For other locations use subscription manager to enable repos needed. For machines running on MOC networks run ```sudo curl -o /etc/yum.repos.d/epel7local.repo http://mochat.massopen.cloud/repos/epel7local.repo ; sudo curl -o /etc/yum.repos.d/rhel7local.repo http://mochat.massopen.cloud/repos/rhel7local.repo;sudo yum -y install git deltarpm ; git clone https://github.com/CCI-MOC/admin-tools;./admin-tools/Ceph/Install1NodeCeph.sh```

Scripts default to the current latest relase - Mimic, to install Luminous specify the release as paramter:
```Install1NodeCeph.sh luminous```
```InstallClient.sh luminous.```
Older releases might work but this is not tested.

## CentOS 7. Install time can be greatly reduced if you run yum update in advance. 
```sudo yum -y install git deltarpm ; git clone https://github.com/CCI-MOC/admin-tools;./admin-tools/Ceph/Install1NodeCeph.sh```
