# nosh

Network Operator Shell

a shell with very few commands available: mainly ping and ssh

This is a work based on yeti's contribution on stack overflow in https://stackoverflow.com/a/43793768

## installation guide

  opkg update
requirement for nosh
  opkg install bash
src https://wiki.openwrt.org/doc/howto/secure.access#create_a_non-privileged_user_in_openwrt
  opkg install shadow-useradd
  useradd user
  mkdir -p /home/user
  chown user /home/user

`vi /etc/passwd` => `user:x:1000:1000:user:/home/user:/bin/ash`

download nosh script

`vi /etc/shells` => `/bin/nosh`

ssh public key access

  mkdir /home/user/.ssh

put
`vi /home/user/.ssh/authorized_keys` => `ssh-rsa (...)`

if you don't do this, ping cannot be ran (?)
  chmod +s /bin/busybox
