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


Stuff to copy paste: 

Genral:
```
grep dhclient /etc/rc.local || echo "dhclient ibft0" >> /etc/rc.local
rm -rf /etc/hostname
yum -y install deltarpm device-mapper-multipath
echo "defaults {
        user_friendly_names yes
        find_multipaths yes
        failback immediate
}
blacklist {
}
" > /etc/multipath.conf
yum update -y
yum -y remove NetworkManager
grep HISTCONTROL /root/.bash_profile || echo "export HISTCONTROL=ignoreboth" >> /root/.bash_profile
```

Monitoring customization:

```
yum -y install net-snmp wget
rm -rf /etc/snmp/snmpd.conf
 wget http://config:mocconfig@mochat.massopen.cloud/config/kzn/snmpd.conf -O /etc/snmp/snmpd.conf
chkconfig snmpd on
service snmpd restart
yum -y remove firewalld NetworkManager
```

Convert image to multipath:
```
echo '
grep golden /sys/firmware/ibft/target0/target-name && exit
yum -y install device-mapper-multipath
mpathconf --enable --with_multipathd y
echo "defaults {
        user_friendly_names yes
        find_multipaths yes
        failback immediate
}
blacklist {
}
" > /etc/multipath.conf
multipath -a /dev/`lsblk |grep /|cut -d "─" -f 2| cut -d " " -f 1|sed "s/[0-9]*//g"`
dracut --force -H --add multipath
sed --in-place "/mpath.sh/d" /etc/rc.d/rc.local
rm -rf /etc/mpath.sh && reboot
'> /etc/mpath.sh
chmod +x /etc/mpath.sh
echo /etc/mpath.sh >> /etc/rc.local
chmod +x /etc/rc.local
```

After booting a golden image for edits:
```
rm -rf /etc/ssh/*key*
> /root/.bash_history
unset HISTFILE
poweroff
```

