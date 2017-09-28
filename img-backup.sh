#!/bin/bash

# live disk backup with active blockcommit
# ref:  http://wiki.libvirt.org/page/Live-disk-backup-with-active-blockcommit

DOMAIN=$1
# backup image of $DOMAIN

TARGET=`virsh domblklist $DOMAIN | sed -n '3p' | awk '{print $1}'`
BASE_PATH=`virsh domblklist $DOMAIN | sed -n '3p' | awk '{print $2}'`
DATE=`date "+%Y-%m-%d"`
IMG_DIR=`echo $BASE_PATH | awk -F. '{print $1}'`
SNAP_PATH="$IMG_DIR-snap-$DATE.qcow2"
BACKUP_DIR="/web-img/"
BACKUP_PATH="$BACKUP_DIR$DOMAIN-$DATE.qcow2"
BACKUP_MAX=3

# create snapshot $SNAP_PATH
virsh snapshot-create-as \
	--domain $DOMAIN \
	--diskspec $TARGET,file=$SNAP_PATH \
	--disk-only --atomic > /dev/null

# backup base image
rsync -avh --progress $BASE_PATH $BACKUP_PATH

# merge snapshot to base image
virsh blockcommit $DOMAIN $TARGET --active --verbose --pivot
rm $SNAP_PATH

# remove old backup images
BACKUP_LIST=`ls -r $BACKUP_DIR$DOMAIN*`
i=1
for f in $BACKUP_LIST; do
	if [ $i -gt "$BACKUP_MAX" ]; then
		# remove $f
		rm $f
	fi
	i=$((i+1))
done
