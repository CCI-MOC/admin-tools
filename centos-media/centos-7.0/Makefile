# Builds a custom CentOS 7.0 ISO. see ../README.md and the comments in
# ../Makefile.common for more info.

ISO_IN := CentOS-7.0-1406-x86_64-Minimal.iso
ISO_OUT := centos-7.0-1406-custom.iso
# The value of the iso's label is important for CentOS 7; the system will use it
# to try to find the root filesystem. As such, the value must be the same as for
# the original media:
ISO_LABEL := 'CentOS 7 x86_64'
MIRROR := http://mirror.us.leaseweb.net/centos/7.0.1406/isos/x86_64

include ../Makefile.common
