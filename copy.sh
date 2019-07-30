set -x
set -e
[ -e /dev/mmcblk0 ]
mount |awk '/mmcblk/ {print $1}' |xargs -r umount
pv output/images/sdcard.img |dd oflag=sync bs=4M of=/dev/mmcblk0
partprobe
sed 's/ .*//' <<EOF |fdisk /dev/mmcblk0
d Delete, defaults to partition 1
n New partition
p  Primary
1  Number one
   Default start
   Default end
x Expert menu
b  Move Beginning
1  To sector 1
r  Return
w Write
EOF
resize2fs -p /dev/mmcblk0p1
