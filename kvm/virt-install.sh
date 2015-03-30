#!/bin/bash

# install using Kickstart:
# For this to work your KVM host and your workstation should be able to resolve 
# and connect to https://raw.githubusercontent.com

lvcreate -L 11G -n zimbra-dev-disk1 vg_dev

virt-install \
  --connect qemu:///system \
  --hvm \
  --virt-type kvm \
  --network=default,model=virtio,mac=52:54:00:d4:22:bf \
  --noautoconsole \
  --name zimbra-dev \
  --disk path=/dev/vg_dev/zimbra-dev-disk1,bus=virtio,cache=none \
  --ram 2048 \
  --vcpus=4\
  --vnc \
  --os-type linux \
  --os-variant rhel6 \
  --location http://ftp.tudelft.nl/centos.org/7/os/x86_64/ \
  -x "ks=https://raw.githubusercontent.com/barrydegraaff/pgp-zimlet/master/kvm/centos7.cfg"
