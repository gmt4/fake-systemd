# fake-systemd

This is a fork from [kvaps/fake-systemd](https://github.com/kvaps/fake-systemd).

Simple bash script using start-stop-daemon, instead of using original systemctl + dbus + privileges + seccomp + x packages + conjunction of Mercury and Venus.

## Status

This project is effectively unmaintained. I will do my best to shepherd pull requests, but cannot guarantee a prompt response and do not have bandwidth to address issues or add new features. Please let me know via an issue if you'd be interested in taking ownership of fake-systemd.

## Install

```console
curl -O https://github.com/gmt4/fake-systemd/raw/master/systemctl-fake
chmod u+x systemctl-fake
bash ystemctl-fake
```

## Usage

The container will only compile start-stop-daemon and put the file in systemctl.

Build

```console
$ docker build -t fake-systemd .
```

Run interactive docker

```console
$ docker run --rm -it fake-systemd bash
```

Example with httpd

```console
[root@ff6625414fd4 /]# yum install httpd -y
[root@ff6625414fd4 /]# systemctl start httpd

[root@ff6625414fd4 ~]# systemctl status httpd
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/lib/systemd/system/httpd.service; disabled; vendor preset: NI)
   Active: active (running) since Sun Mar 26 08:54:46 2023
     Docs: man:httpd(8) man:apachectl(8)
 Main PID: 1848 (httpd)
   Memory: 0.0%
   CGroup: /system.slice/httpd.service
           └─1848 /usr/sbin/httpd

[root@ff6625414fd4 ~]# curl -XHEADER localhost
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">

[root@ff6625414fd4 ~]# systemctl stop httpd
[root@ff6625414fd4 ~]# curl -XHEADER localhost
curl: (7) Failed connect to localhost:80; Connection refused
```

Example with httpd enable/disable

```console
[root@ff6625414fd4 ~]# systemctl enable httpd
Created symlink from /etc/systemd/system/multi-user.target.wants/httpd.service to /usr/lib/systemd/system/httpd.service.
[root@ff6625414fd4 ~]# systemctl is-enabled httpd
enabled
[root@ff6625414fd4 ~]# systemctl is-active httpd
failed
[root@ff6625414fd4 ~]# systemctl status httpd
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; vendor preset: not_implemented)
   Active: failed (Result: not_implemented)
[root@ff6625414fd4 ~]# systemctl start httpd
[root@ff6625414fd4 ~]# systemctl is-active httpd
active
```

Example with sshd

```console
[root@ff6625414fd4 ~]# yum install -y openssh-clients openssh-server sshpass

[root@ff6625414fd4 ~]# systemctl start sshd
[root@ff6625414fd4 ~]# systemctl status sshd
● sshd.service - OpenSSH server daemon
   Loaded: loaded (/lib/systemd/system/sshd.service; disabled; vendor preset: NI)
   Active: active (running) since Sun Mar 26 08:43:25 2023
     Docs: man:sshd(8) man:sshd_config(5)
 Main PID: 977 (sshd)
   Memory: 0.0%
   CGroup: /system.slice/sshd.service
           └─977 /usr/sbin/sshd -D

[root@ff6625414fd4 ~]# echo "root:docker" | chpasswd
[root@ff6625414fd4 ~]# sshpass -p docker ssh -oStrictHostKeyChecking=no localhost uptime
 09:29:28 up 5 days, 18:14,  0 users,  load average: 0.00, 0.02, 0.05
```

## Currently supported actions

**Unit Commands:**

* start
* stop
* restart
* is-active
* status: works with the pidfile,  if a PIDfile options isn't defined, one will be created in /run/UNIT_NAME.pid.

**Unit File Commands:**

* enable
* disable
* is-enabled

**Variables:**

* MAINPID

**Specifiers:**

* %i
* %I
* %n
* %N

**Unit Options:**

* Description
* Documentation

**Install Options:**

* WantedBy

**Service Options:**

* EnvironmentFile: if starting with a minus/dash (ex EnvironmentFile=-/etc/sysconfig/myconfig), errors are ignored
* ExecStart
* ExecStartPost
* ExecStartPre
* ExecStop
* ExecStopPost
* ExecStopPre
* PIDFile
* Type (oneshot, simple, notify and forking only)
* User
* WorkingDirectory

`Exec[Start|Stop][Post|Pre]` commands with `\` and multiples occurrence are supported well.
If a command starts with a minus/dash, the error is ignored.

# Licences

`Original fake-systemd` Copyright (c) 2017 kvaps Licence MIT https://opensource.org/licenses/MIT

Many thanks to Ahmet Demir [ahmet2mir](https://github.com/ahmet2mir) for many improvements and continue development this script.

`start-stop-daemon` is under public domain, see https://github.com/daleobrien/start-stop-daemon#notes

```
A rewrite of the original Debian's start-stop-daemon Perl script
in C (faster - it is executed many times during system startup).

Written by Marek Michalkiewicz <marekm@i17linuxb.ists.pwr.wroc.pl>,
public domain.  Based conceptually on start-stop-daemon.pl, by Ian
Jackson <ijackson@gnu.ai.mit.edu>.  May be used and distributed
freely for any purpose.  Changes by Christian Schwarz
<schwarz@monet.m.isar.de>, to make output conform to the Debian
Console Message Standard, also placed in public domain.  Minor
changes by Klee Dienes <klee@debian.org>, also placed in the Public
Domain.

Changes by Ben Collins <bcollins@debian.org>, added --chuid, --background
and --make-pidfile options, placed in public domain aswell.

Port to OpenBSD by Sontri Tomo Huynh <huynh.29@osu.edu>
               and Andreas Schuldei <andreas@schuldei.org>
Changes by Ian Jackson: added --retry (and associated rearrangements).

Modified for Gentoo rc-scripts by Donny Davies <woodchip@gentoo.org>:
 I removed the BSD/Hurd/OtherOS stuff, added #include <stddef.h>
 and stuck in a #define VERSION "1.9.18".  Now it compiles without
 the whole automake/config.h dance.
```

