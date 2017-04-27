#!/bin/bash

# $1: NAME, $2: image path

KS_PATH="/home/jakhcz/script/centos-7-kickstart-web.cfg"
NAME=$1
IMAGE_PATH=$2

virt-install \
	--name=$NAME \
	--connect qemu:///system \
	--disk path=$IMAGE_PATH \
	--vcpus=4 --ram=2048 \
	--location=http://centos.cs.nctu.edu.tw/7/os/x86_64/ \
	--network bridge=br1\
	--nographics \
	--os-type=linux \
	--os-variant=centos7.0 \
    --initrd-inject=$KS_PATH \
	--extra-args "ks=file:/centos-7-kickstart-web.cfg text console=tty0 console=ttyS0,115200n8 serial"

