ISO := CentOS-6.5-x86_64-minimal.iso
MIRROR := http://mirror.us.leaseweb.net/centos/6.5/isos/x86_64

all: build

fetch: $(ISO)
$(ISO):
	wget $(MIRROR)/$(ISO)
check: $(ISO) sha256sum.txt
	sha256sum -c sha256sum.txt
build: check
	[ ! -d tmp/mnt/isolinux ] || umount tmp/mnt
	rm -rf tmp
	mkdir -p tmp/build tmp/mnt
	mount -o loop $(ISO) tmp/mnt
	cp -a tmp/mnt/* tmp/build/
	cp ks.cfg tmp/build/
	mkisofs \
		-b isolinux/isolinux.bin \
		-c isolinux/boot.cat \
		-no-emul-boot \
		-boot-load-size 4 \
		-boot-info-table \
		-R -J -T \
		-o centos-6.5-custom.iso tmp/build
