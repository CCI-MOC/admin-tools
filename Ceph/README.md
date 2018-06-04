# Scripts to install ceph on 1 node(physical or VM) and client(s)
Scripts default to the current latest relase - Mimic, to install Luminous specify the release as paramter:
```Install1NodeCeph.sh luminous```
```InstallClient.sh luminous.```
Older releases might work but this is not tested.

## Use CentOS 7. Install time can be greatly reduced if you run yum update in advance. 
* Do not use if there are old (half)working ceph installation attempts, wipe clean and reinstall OS first.
* Server must have 2 H(V)DDs - one for the operating system and one for ceph storage.
* Before running the script make sure second block device is cleared - no existing partitions or LVM sigantures. If script complains hdd is not empty use wipefs to clear it and run it again.
* **Ceph Dashboard**
  - **Luminous version runs on port 7000, http, no authentication is requred**
  - **Mimic version runs on port 8080, https, authentication is required. Script configures username and password as ceph**
