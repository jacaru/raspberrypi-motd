#!/bin/bash

[ -f "/etc/motd" ] && mv /etc/motd /etc/motd.bak
[ -f "/etc/update-motd.d/10-uname" ] && mv /etc/update-motd.d /etc/update-motd.d.bak

[ -f "/etc/ssh/sshd_config" ] && sed -i 's/#\?PrintLastLog yes/PrintLastLog no/g' /etc/ssh/sshd_config

for file in 10-welcome 15-system 20-update; do
	install -D update-motd.d/${file} /etc/update-motd.d/${file}
done
install -D update-motd-static.d/20-update /etc/update-motd-static.d/20-update

install -m 644 systemd/update-motd.{service,timer} /etc/systemd/system/
systemctl daemon-reload && systemctl enable update-motd.timer && systemctl start update-motd.timer
systemctl start update-motd

install apt.conf.d/99-update-motd /etc/apt/apt.conf.d/20-update-motd
