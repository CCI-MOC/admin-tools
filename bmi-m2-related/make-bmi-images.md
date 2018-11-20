# Make BMI Images

## Dracuty things you need to do.

1. Install dracut-core and/or dracut-networking,
2. Put this in dracut.conf and rebuild initrd by running  dracut -f


put this in dracut.conf
```
add_drivers+=" ixgbe "
add_drivers+=" sfc "
add_drivers+=" bnx2x "
add_drivers+=" virtio "
add_drivers+=" virtio_net "
add_drivers+=" virtio_pci "
add_drivers+=" virtio_blk "
add_drivers+=" virtio_scsi "
add_drivers+=" virtio_balloon "
add_drivers+=" virtio_ring "
hostonly="no"
```

This loads the drivers for these nics
(x520, solarflare, broadcom, and virtio, intel xl710)

## Gruby things.

Make sure that there's no hardcoded stuff in your grub.conc

Apoorve says this is required, but I didnt do this in the ubuntu18 image:

(e)  Update grub.cfg :
      - create backup of the current grub.cfg
      - put this in cmd linux command to /etc/default/grub "rd.iscsi.initiator=initiator rd.iscsi.firmware=1 rd.iscsi.ibft=1"

grub2-mkconfig -o /etc/grub/grub2.cfg

## iscsi things

1. install open-iscsi initramfs-tools iscsi-initiator-utils
2. echo "iscsi" >> /etc/initramfs-tools/modules
  echo 'add_dracutmodules+="iscsi"' > /etc/dracut.conf.d/iscsi.conf
3. echo "ISCSI_AUTO=true" > /etc/iscsi/iscsi.initramfs
4. update-initramfs -u (same thing as dracut -f)

## Customize your image

1. Remove the ssh host key. `rm /etc/ssh/*key*`
2. `echo "dhclient ibft0" >> rc.local` to make sure it gets the hostname
3. `rm -f /etc/hostname`
4. clear your bash history
5. delete useless network interface files
7. update everything
8. `yum -y install deltarpm` and then do a `yum update`
9. uninstall network manager `yum -y remove NetworkManager`
10. `echo "export HISTCONTROL=ignoreboth" >> /root/.bash_profile`

Rados customization:

```
yum -y install net-snmp wget
rm -rf /etc/snmp/snmpd.conf
 wget http://config:mocconfig@mochat.massopen.cloud/config/kzn/snmpd.conf -O /etc/snmp/snmpd.conf
chkconfig snmpd on
service snmpd restart
yum -y remove firewalld NetworkManager
```
