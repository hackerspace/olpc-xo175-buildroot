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

# Append a FDT to a zImage and adjust the length header field so that OFW
# loads the full file into memory

FIRST_DT=$(sed -n \
	's/^BR2_LINUX_KERNEL_INTREE_DTS_NAME="\([a-z0-9\-]*\).*"$/\1/p' \
	${BR2_CONFIG})

if [ -n "$FIRST_DT" ]; then
	NEW_SIZE=$(printf "%08x" $(wc -c <$TARGET_DIR/boot/zImage.$FIRST_DT) |
		sed 's/\(..\)\(..\)\(..\)\(..\)/\4\3 \2\1/')
	xxd <$TARGET_DIR/boot/zImage.$FIRST_DT |
		sed "s/^\(00000020: .... .... .... .... .... ....\) .... ..../\1 $NEW_SIZE/" |
		xxd -r >$TARGET_DIR/boot/zImage
	rm -f $TARGET_DIR/boot/zImage.$FIRST_DT
fi
