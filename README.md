# nosh

Network Operator Shell

a restricted shell with very few commands available, right now:

- `ping`
- `ssh`
- `mtr`
- `traceroute`
- `nc`
- `uptime`

This is a work based on yeti's contribution on stack overflow, check it here https://stackoverflow.com/a/43793768

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [demo](#demo)
- [installation guide (openwrt / lede)](#installation-guide-openwrt--lede)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## demo

### send commands through ssh

execute commands remotely:

```
ssh root@192.0.2.1 ping wikipedia.org
PING wikipedia.org (91.198.174.192): 56 data bytes
64 bytes from 91.198.174.192: seq=0 ttl=54 time=33.452 ms
64 bytes from 91.198.174.192: seq=1 ttl=54 time=32.981 ms
```

Or perform a ssh proxy command

Supposing nosh is installed in 192.0.2.1 and I want to access 192.0.2.2 (named myhost)

    ssh -o ProxyCommand='ssh root@192.0.2.1 nc 192.0.2.2 22' root@192.0.2.2

remember that with ssh config you can end up with something like:

    ssh myhost

check this article how you can do it: https://www.cyberciti.biz/faq/linux-unix-ssh-proxycommand-passing-through-one-host-gateway-server/

### CLI

```
 $ ssh user@exo-ttn

Welcome, user.
nosh 1.2 - Network Operator Shell, a shell with very few commands available
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
    opkg install mtr # because this command is used by network operators
    chmod +s /usr/sbin/mtr # allow unprivileged user execution => src https://makandracards.com/bitcrowd/23800-mtr-says-mtr-unable-to-get-raw-sockets
    chmod +s /bin/busybox # allow unprivileged user execution, without this you cannot ping
    # note: this is very dangerous, I hope given the use case: dedicated router/VM for just this task is fine. If you are doing more things TAKE CARE

src https://wiki.openwrt.org/doc/howto/secure.access#create_a_non-privileged_user_in_openwrt

    opkg install shadow-useradd
    useradd user
    mkdir -p /home/user
    chown user /home/user

`vi /etc/passwd` => `user:x:1000:1000:user:/home/user:/bin/ash`

download nosh script

    wget https://raw.githubusercontent.com/guifi-exo/nosh/master/nosh -O /bin/nosh
    chmod +x /bin/nosh

`vi /etc/shells` => `/bin/nosh`

ssh public key access

    mkdir /home/user/.ssh

put

`vi /home/user/.ssh/authorized_keys` => `ssh-rsa (...)`

## Resources

- learning / code resources
    - http://www.gnu.org/software/libc/manual/html_node/Implementing-a-Shell.html#Implementing-a-Shell
    - https://stackoverflow.com/questions/4788374/writing-a-basic-shell
    - https://www.cs.purdue.edu/homes/grr/SystemsProgrammingBook/Book/Chapter5-WritingYourOwnShell.pdf
- other restricted shells (generic)
    - https://git-scm.com/docs/git-shell
    - http://www.pizzashack.org/rssh/
    - https://github.com/jmreyes/simple-c-shell
