\ Hello World

: (visible)  " unfreeze visible" evaluate  ;
' (visible) catch  drop  forget (visible)

" /aliases" find-device " last" get-property
abort" No last alias"
" /pci/sd@c"          2over substring?  if  " root=/dev/mmcblk0p1 "                  to boot-file  then
" /sd/sdhci@d4280000" 2over substring?  if  " root=/dev/mmcblk1p1 "                  to boot-file  then
" /pci/usb@"          2over substring?  if  " root=/dev/sda1 "                       to boot-file  then
" /usb@"              2over substring?  if  " root=/dev/sda1 "                       to boot-file  then
" /pci/nandflash@c"   2over substring?  if  " root=/dev/mtdblock0 rootfstype=jffs2 " to boot-file  then
2drop

root-device " compatible" get-property dend  if  0 0  then
" mmp" 2swap sindex -1 > if
   " last:\boot\zImage" to boot-device
   boot-file " console=ttyS2,115200 " $cat2 to boot-file
else
   " last:\boot\bzImage" to boot-device
   boot-file " console=ttyS0,115200 reboot=pci " $cat2 to boot-file
then

\ Pick a terminal that looks better on the XO screen
root-device " architecture" get-property dend  if  0 0  else  1-  then
" OLPC" $=  if  boot-file " fbcon=font:TER16x32 vt.color=0xf0 " $cat2 to boot-file  then

boot-file " console=tty0 rootwait" $cat2 to boot-file

: boot.xo
   " 1 to olpc-compat?" evaluate
   " last:\boot\zImage.xo" to boot-device
   boot-file "  init=/bin/bash" $cat2 to boot-file
   boot
;

." Flash an image built from lr/mmp3 branch:"                cr
                                                             cr
."   flash last:\ariel.rom"                                  cr
."   flash last:\xo175.rom"                                  cr
."   flash last:\xo1.rom"                                    cr
."   flash last:\xo4.rom"                                    cr
                                                             cr
." 'boot' will proceed booting"                              cr
."   boot-device: " boot-device type                         cr
."   boot-file:   " boot-file type                           cr
                                                             cr
." 'boot.xo' to check compatibility with the OLPC OS kernel" cr
                                                             cr
\ boot
