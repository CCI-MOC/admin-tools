ISO := CentOS-6.5-x86_64-minimal.iso
MIRROR := http://mirror.us.leaseweb.net/centos/6.5/isos/x86_64

all: check

fetch: $(ISO)
$(ISO):
	wget $(MIRROR)/$(ISO)
check: $(ISO) sha256sum.txt
	sha256sum -c sha256sum.txt
