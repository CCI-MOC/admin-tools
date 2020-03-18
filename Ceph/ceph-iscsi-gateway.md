# Ceph iSCSI Gateways

This document describes how to get around the problems that I encountered when setting up ceph iscsi gateways on centos7.

I followed the [upstream documentation](https://docs.ceph.com/docs/master/rbd/iscsi-target-cli/), and will describe the issues and how to solve them. This is only good for test environments.


1. Deploy a ceph cluster

You can use the `Install1NodeCeph.sh` script to setup a test cluster.

In my test setup, I had 3 hosts `ceph1`, `ceph2`, `ceph3`. I ran the install script on `ceph1`, and then used `ceph-deploy` from that host to install ceph packages on `ceph2` and `ceph3`.
After that, you can use `ceph-deploy` to use OSDs on `ceph2` and `ceph3`.

2. Update kernel

The official docs require a kernel > 4.16. I installed 4.4 LTS kernel but that didn't work. It failed to allocate LUNs for my RBD disks (step 5 under "Configuring" section of the official docs). 

`systemctl status rbd-target-api` reported this

```
Could not set LIO device attribute cmd_time_out/qfull_time_out for device: rbd/somedisk_1. Kernel not supported. - error(Cannot find attribute: cmd_time_out)
Mar 16 16:55:01 ceph2 rbd-target-api[3505]: LUN alloc problem - Could not set LIO device attribute cmd_time_out/qfull_time_out for device: rbd/somedisk_1. Kernel not supported. - error(Can...cmd_time_out)
``` 

I ended up using the mainline kernel 5.5 to get around it.

https://www.howtoforge.com/tutorial/how-to-upgrade-kernel-in-centos-7-server/

3. Install packages

`tagetcli` and `python-rtslib` are easy to find, so just yum install those.

Install tcmu-runner like this:

```
yum install https://3.chacra.ceph.com/r/tcmu-runner/master/eef511565078fb4e2ed52caaff16e6c7e75ed6c3/centos/7/flavors/default/x86_64/tcmu-runner-1.4.0-0.1.51.geef5115.el7.x86_64.rpm
```

Install ceph-iscsi like this:
```
cd /etc/yum.repos.d/
wget https://download.ceph.com/ceph-iscsi/3/rpm/el7/ceph-iscsi.repo
yum install ceph-iscsi -y
```

4. Follow the rest of official documentation
 
One exception: When you try to create ceph gateways (Step 3 under "Configuring" section) use the local hostname for the first gateway. 

See: https://tracker.ceph.com/issues/24425