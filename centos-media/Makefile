ISO := CentOS-7.0-1406-x86_64-Minimal.iso
MIRROR := http://mirror.us.leaseweb.net/centos/7.0.1406/isos/x86_64

KS ?= ks.cfg
COPY_FILES ?= copy-files

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
	cp -r copy-files tmp/build/copy-files
	cp $(KS) tmp/build/ks.cfg
	cp isolinux.cfg tmp/build/isolinux/
	mkisofs \
		-b isolinux/isolinux.bin \
		-c isolinux/boot.cat \
		-no-emul-boot \
		-boot-load-size 4 \
		-boot-info-table \
		-R -J -T \
		-o centos-7.0-1406-custom.iso tmp/build
