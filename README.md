# fake-systemd

This is a fork from [kvaps/fake-systemd](https://github.com/kvaps/fake-systemd).

Shell script using [start-stop-daemon](https://github.com/daleobrien/start-stop-daemon), instead of using the original *systemd*: `systemctl + dbus + privileges + seccomp + x packages + conjunction of Mercury and Venus`.

## Status

This project is effectively unmaintained. I will do my best to shepherd pull requests, but cannot guarantee a prompt response and do not have bandwidth to address issues or add new features. Please let me know via an issue if you'd be interested in taking ownership of fake-systemd.

## Install

```console
curl -LO https://github.com/gmt4/fake-systemd/raw/master/systemctl
chmod u+x systemctl
bash systemctl
```

## Usage

```console
systemctl [OPTIONS...] {COMMAND} ...
systemctl (fake) # @version v1.0 (c) gmt4 https://github.com/gmt4/fake-systemd

Query or send control commands to the systemd manager.

Options:
  -h --help           Show this help
  -v --version        Show this version.

Unit Commands:
  start NAME...                   Start (activate) one or more units
  stop NAME...                    Stop (deactivate) one or more units
  restart NAME...                 Start or restart one or more units
  is-active PATTERN...            Check whether units are active
  status [PATTERN...|PID...]      Show runtime status of one or more units
  list-units [UNITS...]           List runtime status of one or more units

Unit File Commands:
  enable NAME...                  Enable one or more unit files
  disable NAME...                 Disable one or more unit files
  is-enabled NAME...              Check whether unit files are enabled
```

## Examples

Build and run interactive docker, to compile start-stop-daemon and put the file in systemctl

```console
$ docker build -t fake-systemd .
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

## Supported actions

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

- See [LICENSE](../../blob/master/LICENSE)
- `Original fake-systemd` Copyright (c) 2017 kvaps Licence MIT https://opensource.org/licenses/MIT
- `start-stop-daemon` is under public domain, see https://github.com/daleobrien/start-stop-daemon#notes

Many thanks to Ahmet Demir [ahmet2mir](https://github.com/ahmet2mir) for many improvements and continue development this script.


