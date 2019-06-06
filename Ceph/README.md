# Scripts to install ceph on 1 node(physical or VM) and client(s)
## Required
* **CentOS 7 or RHEL 7**
* **Server must have 2 H(V)DDs - one for the operating system and one for ceph storage.**
* **Before running the script make sure second block device is cleared - no existing partitions or LVM sigantures. If script complains hdd is not empty use wipefs to clear it and run it again.**
* **Passwordless sudo for the account running the script**

## General information
* Do not use if there are old (half)working ceph installation attempts, wipe clean and reinstall OS first.
* Install time can be greatly reduced if you run yum update in advance. 
* **Ceph Dashboard**
  - **Luminous version runs on port 7000, http, no authentication is requred**
  - **Mimic/later version runs on port 8443, https, authentication is required. Script configures username and password as ceph**

* Scripts default to the current latest relase - Nautilus, to install Mimic/Luminous specify the release as paramter:
   ```Install1NodeCeph.sh luminous```
   ```InstallClient.sh luminous.```
Older releases might work but this is not tested.

* **Copy and paste code blocks below to run with default release**


## CentOS 7.
```sudo yum -y install git deltarpm ; git clone https://github.com/CCI-MOC/admin-tools;./admin-tools/Ceph/Install1NodeCeph.sh```

## RHEL 7
* *Support for RHEL7 using MOC internal repos only. For other locations use subscription manager to enable repos needed. For machines running on MOC networks only:* 
```sudo curl -o /etc/yum.repos.d/epel7local.repo http://mochat.massopen.cloud/repos/epel7local.repo ; sudo curl -o /etc/yum.repos.d/rhel7local.repo http://mochat.massopen.cloud/repos/rhel7local.repo;sudo yum -y install git deltarpm ; git clone https://github.com/CCI-MOC/admin-tools;./admin-tools/Ceph/Install1NodeCeph.sh```

## Prometheus/Grafana
* After successful install (ceph -s reports HEALTH_OK) Prometheus/Grafana (listens on port 3000 admin,admin) can be added by running
```./admin-tools/Ceph/InstallPrometheusGrafana.sh```
