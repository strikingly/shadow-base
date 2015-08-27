shadowsocks manyuser branch
===========
Which people need this branch
------------------
1.share shadowsocks server

2.create multi server by shadowsocks

3.manage server (transfer / account)

Change
-------
从efd106dfb5这个提交开始能够独立于前端运行了，原因在于考虑到udp的话可靠性不好。在数据库中修改passwd，switch，enable，流量都会立即生效(比如改密码不需要再通过Managesocket去手动stop某个服务了)。不过内部实现还是通过数据库线程发送一个udp包来触发的，因为数据库这个操作改成异步的会灰常灰常麻烦，所以千万不要在iptabls里面把udp全给堵死了。<del>我的线上环境变成了瘟都死所以这个没有时间和环境测试，对运行过程中出现服务崩溃，服务器冒烟不负任何责任。</del>发现有问题的话给我个提交？诶哟好累英语太拙计就写中文好了。

Install
-------
install MySQL 5.x.x

`pip install cymysql`

create a database named `shadowsocks`

import `shadowsocks.sql` into `shadowsocks`

edit Config.py
Example:

	#Config
	MYSQL_HOST = 'mdss.mengsky.net'
	MYSQL_PORT = 3306
	MYSQL_USER = 'ss'
	MYSQL_PASS = 'ss'
	MYSQL_DB = 'shadowsocks'

	MANAGE_PASS = 'ss233333333'
	#if you want manage in other server you should set this value to global ip
	MANAGE_BIND_IP = '127.0.0.1'
	#make sure this port is idle
	MANAGE_PORT = 23333

TestRun `cd shadowsocks` ` python server.py`

if no exception server will startup. you will see such like
Example:

	db start server at port [%s] pass [%s]

Database user table column
------------------
`passwd` server pass

`port` server port

`t` last keepalive time

`u` upload transfer

`d` download transer

`transfer_enable` if u + d > transfer_enable this server will be stop (db_transfer.py del_server_out_of_bound_safe)

Manage socket
------------------
Manage server work in UDP at `MANAGE_BIND_IP` `MANAGE_PORT`

use `MANAGE_PASS:port:passwd:0` to del a server at port `port`

use `MANAGE_PASS:port:passwd:1` to run a server at port `port` password is `passwd`

Python Eg:

	udpsock.sendto('MANAGE_PASS:65535:123456:1', (MANAGE_BIND_IP, MANAGE_PORT))
	
PHP Eg:

	$sock = socket_create(AF_INET, SOCK_DGRAM, SOL_UDP);
	$msg = 'MANAGE_PASS:65535:123456:1';
	$len = strlen($msg);
	socket_sendto($sock, $msg, $len, 0, MANAGE_BIND_IP, MANAGE_PORT);
	socket_close($sock);

NOTICE
------------------
If error such like `2014-09-18 09:02:37 ERROR    [Errno 24] Too many open files`

edit /etc/security/limits.conf

Add:

	*                soft    nofile          8192
	*                hard    nofile          65535


add `ulimit -n 8192` in your startup script before runing

shadowsocks
===========

[![PyPI version]][PyPI] [![Build Status]][Travis CI] 

A fast tunnel proxy that helps you bypass firewalls.

[中文说明][Chinese Readme]

Install
-------

You'll have a client on your local machine, and install a server on a
remote server.

### Client

* [Windows] / [OS X]
* [Android] / [iOS]
* [OpenWRT]

### Server

#### Debian / Ubuntu:

    apt-get install python-pip python-m2crypto
    pip install shadowsocks

Or simply `apt-get install shadowsocks` if you have [Debian sid] in your
source list.

#### CentOS:

    yum install m2crypto python-setuptools
    easy_install pip
    pip install shadowsocks

Configuration
-------------

On your server create a config file `/etc/shadowsocks.json`.
Example:

    {
        "server":"my_server_ip",
        "server_port":8388,
        "local_address": "127.0.0.1",
        "local_port":1080,
        "password":"mypassword",
        "timeout":300,
        "method":"aes-256-cfb",
        "fast_open": false,
        "workers": 1
    }

Explanation of the fields:

| Name          | Explanation                                     |
| ------------- | ----------------------------------------------- |
| server        | the address your server listens                 |
| server_port   | server port                                     |
| local_address | the address your local listens                  |
| local_port    | local port                                      |
| password      | password used for encryption                    |
| timeout       | in seconds                                      |
| method        | default: "aes-256-cfb", see [Encryption]        |
| fast_open     | use [TCP_FASTOPEN], true / false                |
| workers       | number of workers, available on Unix/Linux      |

Run `ssserver -c /etc/shadowsocks.json` on your server. To run it in the
background, use [Supervisor].

On your client machine, use the same configuration as your server, and
start your client.

If you use Chrome, it's recommended to use [SwitchySharp]. Change the proxy 
settings to

    protocol: socks5
    hostname: 127.0.0.1
    port:     your local_port

If you can't install [SwitchySharp], you can launch Chrome with the following
arguments to force Chrome to use the proxy:

    Chrome.exe --proxy-server="socks5://127.0.0.1:1080" --host-resolver-rules="MAP * 0.0.0.0 , EXCLUDE localhost"

If you can't even download Chrome, find a friend to download a
[Chrome Standalone] installer for you.

Command line args
------------------

You can use args to override settings from `config.json`.

    sslocal -s server_name -p server_port -l local_port -k password -m bf-cfb
    ssserver -p server_port -k password -m bf-cfb --workers 2
    ssserver -c /etc/shadowsocks/config.json

List all available args with `-h`.

Wiki
----

https://github.com/clowwindy/shadowsocks/wiki

License
-------
MIT

Bugs and Issues
----------------

* [Troubleshooting]
* [Issue Tracker]
* [Mailing list]


[Android]:           https://github.com/clowwindy/shadowsocks/wiki/Ports-and-Clients#android
[Build Status]:      https://img.shields.io/travis/clowwindy/shadowsocks/master.svg?style=flat
[Chinese Readme]:    https://github.com/clowwindy/shadowsocks/wiki/Shadowsocks-%E4%BD%BF%E7%94%A8%E8%AF%B4%E6%98%8E
[Chrome Standalone]: https://support.google.com/installer/answer/126299
[Debian sid]:        https://packages.debian.org/unstable/python/shadowsocks
[Encryption]:        https://github.com/clowwindy/shadowsocks/wiki/Encryption
[iOS]:               https://github.com/shadowsocks/shadowsocks-iOS/wiki/Help
[Issue Tracker]:     https://github.com/clowwindy/shadowsocks/issues?state=open
[Mailing list]:      http://groups.google.com/group/shadowsocks
[OpenWRT]:           https://github.com/clowwindy/shadowsocks/wiki/Ports-and-Clients#openwrt
[OS X]:              https://github.com/shadowsocks/shadowsocks-iOS/wiki/Shadowsocks-for-OSX-Help
[PyPI]:              https://pypi.python.org/pypi/shadowsocks
[PyPI version]:      https://img.shields.io/pypi/v/shadowsocks.svg?style=flat
[Supervisor]:        https://github.com/clowwindy/shadowsocks/wiki/Configure-Shadowsocks-with-Supervisor
[TCP_FASTOPEN]:      https://github.com/clowwindy/shadowsocks/wiki/TCP-Fast-Open
[Travis CI]:         https://travis-ci.org/clowwindy/shadowsocks
[Troubleshooting]:   https://github.com/clowwindy/shadowsocks/wiki/Troubleshooting
[SwitchySharp]:      https://chrome.google.com/webstore/detail/proxy-switchysharp/dpplabbmogkhghncfbfdeeokoefdjegm
[Windows]:           https://github.com/clowwindy/shadowsocks/wiki/Ports-and-Clients#windows
