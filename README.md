# nosh

Network Operator Shell

a restricted shell with very few commands available: mainly ping and ssh

This is a work based on yeti's contribution on stack overflow, check it here https://stackoverflow.com/a/43793768

## demo

```
 $ ssh user@exo-ttn

Welcome, user.
nosh 1.0 - Network Operator Shell, a shell with very few commands available
Source code: https://github.com/guifi-exo/nosh/blob/master/nosh
Type 'help' for information.

Commands are logged, you accessed in 2018-02-1517505916 18:25:16

nosh> help
Type exit or q to quit.
Commands you can use:
  help
  ping
  ssh
  uptime
nosh> ping
BusyBox v1.25.1 () multi-call binary.

Usage: ping [OPTIONS] HOST

Send ICMP ECHO_REQUEST packets to network hosts

    -4,-6       Force IP or IPv6 name resolution
    -c CNT      Send only CNT pings
    -s SIZE     Send SIZE data bytes in packets (default:56)
    -t TTL      Set TTL
    -I IFACE/IP Use interface or IP address as source
    -W SEC      Seconds to wait for the first response (default:10)
            (after all -c CNT packets are sent)
    -w SEC      Seconds until ping exits (default:infinite)
            (can exit earlier with -c CNT)
    -q      Quiet, only display output at start
            and when finished
    -p      Pattern to use for payload
nosh> rm
command disabled
nosh> ls
command disabled
nosh> ping wikipedia.org
PING wikipedia.org (91.198.174.192): 56 data bytes
64 bytes from 91.198.174.192: seq=0 ttl=54 time=33.043 ms
64 bytes from 91.198.174.192: seq=1 ttl=54 time=32.887 ms
^C
--- wikipedia.org ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
round-trip min/avg/max = 32.887/32.965/33.043 ms
nosh> ssh git@github.com

Host 'github.com' is not in the trusted hosts file.
(ssh-rsa fingerprint md5 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48)
Do you want to continue connecting? (y/n) y

ssh: Connection to git@github.com:22 exited: No auth methods could be used.

nosh> exit
```

## installation guide (openwrt / lede)

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
