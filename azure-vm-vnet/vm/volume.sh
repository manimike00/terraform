#!/bin/bash
echo "LABEL=cloudimg-rootfs   /      xfs   defaults,discard     0 0" > /etc/fstab
while true; do
  if [ $(lsblk -o KNAME,SIZE | grep 50G | wc -l) -eq 1 ]; then
     break;
  fi
done

disk_name=$(lsblk -o KNAME,SIZE | grep 50G | awk '{ print "/dev/"$1 }')
echo $disk_name
mkfs -t ext4 $disk_name
mkdir /perfios
mount $disk_name /perfios
UUID1=$(lsblk -n -o UUID "$(df -P $disk_name | tail -n1 | cut -d' ' -f1)")
echo "$(echo `echo UUID=$UUID1`)   /perfios   ext4  defaults,nofail  0 0" >> /etc/fstab
mount -a
fallocate -l 4G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab