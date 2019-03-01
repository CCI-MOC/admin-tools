#! /bin/bash

set -ex

abort()
    {
    echo "$1"
    exit 1
    }
if [ "$1" == "--help" ] || [ "$1" == "-h" ] || [ "$#" -ne 2 ]; then
    abort "Run this as ./insert-key.sh PROJECT_NAME IMAGE_NAME"
fi

if [ -z "$KEY" ]; then
    abort "KEY is not set"
fi

PROJECT=$1
IMAGE=$2

# Test if the image exists
rbd info $IMAGE &> /dev/null || abort "RBD cannot find that image"

# Import the image into bmi, and then get the ceph name that BMI generated.

output=$(bmi import $PROJECT $IMAGE)
if [[ $output == *"not found"* ]]; then
    abort "Project does not exist. Please create the project first"
fi

CEPH_IMAGE=$(bmi db ls --project $PROJECT |grep -m 1 $IMAGE |egrep -o "kzn-bmi-img[0-9]+")
echo "Ceph image name is: " + $CEPH_IMAGE

# Delete the BMI created snapshot because it wouldn't have the keys we are
# about to insert.
rbd snap unprotect --snap snapshot --image $CEPH_IMAGE
rbd snap rm --snap snapshot --image $CEPH_IMAGE

# Map the rbd image, mount it, and insert the keys.

MOUNTPOINT=/mnt/key-inserter
mkdir -p $MOUNTPOINT

LOCATION=$(rbd map $CEPH_IMAGE)
mount $LOCATION"p1" $MOUNTPOINT

mkdir -p "$MOUNTPOINT/root/.ssh"

echo $KEY >> $MOUNTPOINT/root/.ssh/authorized_keys
chmod 700 $MOUNTPOINT/root/.ssh
chmod 600 $MOUNTPOINT/root/.ssh/authorized_keys

# Unmount and unmap
umount $MOUNTPOINT
rbd unmap $LOCATION

# Recreate the snapshot to be used by BMI
rbd snap create --snap snapshot --image $CEPH_IMAGE
rbd snap protect --snap snapshot --image $CEPH_IMAGE

exit 0

