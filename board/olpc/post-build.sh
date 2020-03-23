#!/bin/sh

BOARD_DIR="$(dirname $0)"

for i in tty1 tty2 tty3 tty4
do
	mkdir -p $TARGET_DIR/etc/systemd/system/getty.target.wants
	ln -sf ../../../../usr/lib/systemd/system/getty@.service \
		$TARGET_DIR/etc/systemd/system/getty.target.wants/getty@$i.service
done

ln -sf /var/run/NetworkManager/resolv.conf $TARGET_DIR/etc/resolv.conf

rm -f $TARGET_DIR/etc/systemd/system/multi-user.target.wants/systemd-networkd.service
rm -f $TARGET_DIR/etc/systemd/system/network-online.target.wants/systemd-networkd-wait-online.service
rm -f $TARGET_DIR/etc/systemd/system/sockets.target.wants/systemd-networkd.socket
rm -rf $TARGET_DIR/var/log/journal

install -m 0644 -D $BOARD_DIR/olpc.fth $TARGET_DIR/boot/olpc.fth
install -m 0644 -D $BOARD_DIR/zImage.xo $TARGET_DIR/boot/zImage.xo
install -m 0644 -D $BOARD_DIR/xo1.rom $TARGET_DIR/
install -m 0644 -D $BOARD_DIR/xo175.rom $TARGET_DIR/
install -m 0644 -D $BOARD_DIR/xo4.rom $TARGET_DIR/
install -m 0644 -D $BOARD_DIR/ariel.rom $TARGET_DIR/
