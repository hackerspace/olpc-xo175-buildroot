#!/bin/sh

BOARD_DIR="$(dirname $0)"

for i in tty1 tty2 tty3 tty4
do
	ln -sf ../../../../usr/lib/systemd/system/getty@.service \
		$TARGET_DIR/etc/systemd/system/getty.target.wants/getty@$i.service
done

ln -sf /var/run/NetworkManager/resolv.conf $TARGET_DIR/etc/resolv.conf

rm -f $TARGET_DIR/etc/systemd/system/multi-user.target.wants/systemd-networkd.service
rm -f $TARGET_DIR/etc/systemd/system/network-online.target.wants/systemd-networkd-wait-online.service
rm -f $TARGET_DIR/etc/systemd/system/sockets.target.wants/systemd-networkd.socket

install -m 0644 -D $BOARD_DIR/olpc.fth $TARGET_DIR/boot/olpc.fth
