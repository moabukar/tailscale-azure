#!/bin/sh
/usr/bin/ssh-keygen -A
mkdir -p /var/run/sshd
/usr/sbin/sshd

/app/tailscaled --tun=userspace-networking --socks5-server=localhost:1055 &
/app/tailscale up --authkey=${TAILSCALE_AUTHKEY} --hostname=azureapp
#tailscale up --authkey=${TAILSCALE_AUTHKEY} --hostname=azureapp
#echo Tailscale started
ALL_PROXY=socks5://localhost:1055/
/hello_go_http
