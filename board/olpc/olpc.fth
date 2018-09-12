\ OLPC XO boot script

visible unfreeze

" /aliases" find-device " last" get-property
abort" No last alias"
" /pci/sd@c" 2over substring?  if  " root=/dev/mmcblk0p1 " to boot-file  then
" /pci/usb@" 2over substring?  if  " root=/dev/sda1 "      to boot-file  then
2drop

" /" find-device " compatible" get-property if  0 0  then  ( -- compatible$ )
" olpc,xo-1.75" 2over sindex -1 =  if
   \ Not a XO-1.75. Assume XO-1
   2drop                                                   ( -- )
  " last:\boot\bzImage" to boot-device
  boot-file " console=ttyS0,115200 reboot=pci " $cat2 to boot-file
else
   \ XO-1.75
   " mrvl,mmp2" 2swap substring? not  if
     cr
     ." Firmware Q4E00 or newer is needed to boot a Devicetree enabled kernel." cr
     cr
     ." One way to update is to copy http://dev.laptop.org/~quozl/q4e00ja.rom" cr
     ." to a FAT partition on a USB flash stick and run ""flash u:\q4e00ja.rom""" cr
     cr
     ." Aborting boot." cr
     show-sad
     abort
   then
   " last:\boot\zImage" to boot-device
  boot-file " console=ttyS2,115200 " $cat2 to boot-file
then

boot-file " console=tty0 rootwait fbcon=font:SUN12x22" $cat2 to boot-file
boot
