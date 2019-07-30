#!/bin/sh

set -e

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

mkdir -p $TARGET_DIR/etc/modprobe.d
cat >$TARGET_DIR/etc/modprobe.d/libertas.conf <<EOF
# Prefer the "Thin Firmware" soft MAC driver
blacklist usb8xxx
#blacklist libertas_tf_usb
EOF

(
umask 0077
cat >>$TARGET_DIR/usr/lib/NetworkManager/system-connections/mesh1.nmconnection <<EOF
[connection]
id=mesh1
uuid=7dea1207-aed0-4f0f-8f08-22927e82f64f
type=wifi

[wifi]
band=bg
channel=1
mode=mesh
ssid=Mesh

[ipv4]
method=link-local

[ipv6]
addr-gen-mode=stable-privacy
method=link-local
EOF
)

install -m 0644 -D $BOARD_DIR/olpc.fth $TARGET_DIR/boot/olpc.fth
