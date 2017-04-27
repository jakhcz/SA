#!/bin/bash

# The image will save at /data/img/[name].qcow2

mkdir -p /data/img 
NAME="/data/img/$1.qcow2"
SIZE=$2

qemu-img create -f qcow2 $NAME $SIZE

