---
layout: post
title:  "ubuntu-14.04-server配置Jexus –安装步骤记录"
date:   2014-06-28 11:38:59
author: "Richard Hao"
header-img: "//static.haoxilu.net/post-bg.jpg"
tags:
    - jexus
description: ''
main-class: 'linux'
color: '#2DA0C3'
introduction: 'jexus是一款国人开发的，基于Liunx的.Net跨平台开发工具'
---
* * *

作者：[郝喜路](http://weibo.com/haoxilu)&nbsp;&nbsp; 个人主页：[ http://haoxilu.net ](http://haoxilu.net/)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 博客地址：[http://haoxilu.net](http://haoxilu.net)&nbsp;&nbsp;&nbsp;

* * *

说明：我是Linux菜鸟，自己尝试配置Jexus服务器，中间遇到了很多错误，参考园子里很多大神的博客。才完成配置。如果你和我一样是个菜菜，那么，你不用东奔西跑了，这儿有你想要的。。。

1、 使用Putty连接远程Ubuntu服务器：

如果不能连接，可使用如下解决方案;

参考地址：[http://www.linuxidc.com/Linux/2012-04/59409.htm](http://www.linuxidc.com/Linux/2012-04/59409.htm)l

1.先明确你能ping通远程的Ubuntu或者虚拟机。

2.如果还不能登录，分析原因是大多都没有真正开启ssh-server服务。最终成功的 方法如下：

sudo apt-get install openssh-server

Ubuntu缺省安装了openssh-client,所以在这里就不安装了，如果你的系统没有安 装的话，再用apt-get安装上即可。

然后确认sshserver是否启动了：

ps -e |grep ssh

如果只有ssh-agent那ssh-server还没有启动，需要/etc/init.d/ssh start，如果看 到sshd那说明ssh-server已经启动了。

ssh-server配置文件位于/ etc/ssh/sshd_config，在这里可以定义SSH的服务端口， 默认端口是22，你可以自己定义成其他端口号，如222。然后重启SSH服务：

sudo /etc/init.d/ssh resart

[![wps_clip_image-26493](http://images.cnitblog.com/blog/578906/201406/282242462426518.png "wps_clip_image-26493")](http://images.cnitblog.com/blog/578906/201406/282242446019217.png)

2、 使用WinSCP 上传安装需要的文件（文件可以上传到自定义文件，我上传的路径是home/icode/software）

安装文件下载地址：[http://pan.baidu.com/s/1jGFVTyA ](http://pan.baidu.com/s/1jGFVTyA)

[![wps_clip_image-11352](http://images.cnitblog.com/blog/578906/201406/282242483044349.png "wps_clip_image-11352")](http://images.cnitblog.com/blog/578906/201406/282242470701405.png)

3、 文件上传好了，下面开始安装，但是在安装之前需要对当前的系统进行更新

参考地址：[http://www.linuxdot.net/bbsfile-3090](http://www.linuxdot.net/bbsfile-3090)

sudo apt-get update

sudo apt-get upgrade

安装第二个更新时耗时较长，此时可以泡杯咖啡静静地等会儿~

4、 构建编译环境

sudo apt-get install build-essential

sudo apt-get install automake autoconf

5、 安装libgdiplus和mono所依赖的库文件

sudo apt-get install bison libglib2.0-dev
sudo apt-get install libgif-dev libtiff4-dev libpng12-dev libexif-dev libx11-dev libxft-dev libjpeg-dev

6、 安装libgdiplus

1&gt;解压libgdiplus-2.10.tar.bz2

tar -jxvf libgdiplus-2.10.tar.bz2

2&gt;进入libgdiplus-2.10 文件夹 执行命令

./configure --prefix=/usr
make
sudo make install

注：在执行编译&nbsp; make 时遇到了错误，

[![wps_clip_image-6560](http://images.cnitblog.com/blog/578906/201406/282242512268608.png "wps_clip_image-6560")](http://images.cnitblog.com/blog/578906/201406/282242494296793.png)

参考链接：

[http://www.cnblogs.com/24la/p/libgdiplus-install-error-record.html](http://www.cnblogs.com/24la/p/libgdiplus-install-error-record.html)

解决方法：

ln -s /usr/include/freetype2 /usr/include/freetype

或者在构建编译环境的时候执行

sudo apt-get install libgif-dev

sudo apt-get install libpng12-dev

安装这两个依赖组件

然后继续 make&nbsp; 报如下错误：

/usr/lib64/libglib-2.0.so.0: could not read symbols: Invalid operation

collect2: error: ld returned 1 exit status

make[2]: *** [testgdi] Error 1 make[2]: Leaving directory `/usr/local/src/libgdiplus-2.10.9/tests'

make[1]: *** [all-recursive] Error 1 make[1]: Leaving directory `/usr/local/src/libgdiplus-2.10.9'

make: *** [all] Error 2

解决方法：

先执行 ./configure 命令， 然后编辑 test/Makefile 文件；

将 130 行的 LIBS = -lpthread -lfontconfig 改为 LIBS = -lpthread -lfontconfig -lglib-2.0 -lX11

再次执行 make 命令即可。

最后，继续执行 sudo make install 安装完成

7、 安装Mono（说明：Mono的安装编译时间非常长，此时可以出去运动一下哦~）

1&gt;解压&nbsp; tar -zxvf mono-3.4.0.tar.gz

2&gt;cd mono-3.4.0&nbsp; 进入 mono-3.4.0文件夹执行编译安装操作

./configure --prefix=/usr
&nbsp; make
&nbsp; sudo make install

注：

如果在执行时 ./configure --prefix=/usr遇到如下错误

[![wps_clip_image-10284](http://images.cnitblog.com/blog/578906/201406/282242531331925.png "wps_clip_image-10284")](http://images.cnitblog.com/blog/578906/201406/282242521482523.png)

解决方法： sudo apt-get install gettext

然后继续执行&nbsp; ./configure --prefix=/usr
3&gt;可以通过 mono -V 查看当前的版本 来判断mono是否安装成功，成功显示下图

[![wps_clip_image-7057](http://images.cnitblog.com/blog/578906/201406/282242544144181.png "wps_clip_image-7057")](http://images.cnitblog.com/blog/578906/201406/282242537268038.png)

8、 安装Jexus

1&gt; 解压&nbsp; jexus-5.5.2.tar.gz

tar -zxvf jexus-5.5.2.tar.gz

2&gt;&nbsp; cd jexus-5.5.2 进入&nbsp; jexus-5.5.2 文件夹进行安装操作

sudo ./install

[![wps_clip_image-15803](http://images.cnitblog.com/blog/578906/201406/282242562115996.png "wps_clip_image-15803")](http://images.cnitblog.com/blog/578906/201406/282242550863553.png)

看到上图表示安装成功！

3&gt;启动Jexus服务

cd /usr/jexus

sudo ../jws start

[![wps_clip_image-5601](http://images.cnitblog.com/blog/578906/201406/282242579613798.png "wps_clip_image-5601")](http://images.cnitblog.com/blog/578906/201406/282242575706212.png)看到此图表示服务启动成功！

注：

Jws相关的命令&nbsp; jws {start|stop|restart|regsvr|status|-v}

sudo ./jws status&nbsp; 可以查看当前jexus服务的状态

[![wps_clip_image-30320](http://images.cnitblog.com/blog/578906/201406/282243000862414.png "wps_clip_image-30320")](http://images.cnitblog.com/blog/578906/201406/282242596646585.png)

在客户机浏览器输入服务器IP如果看到下图，也表示安装Jexus成功

[![wps_clip_image-27371](http://images.cnitblog.com/blog/578906/201406/282243026487331.png "wps_clip_image-27371")](http://images.cnitblog.com/blog/578906/201406/282243016956173.png)

9、 设置Jexus服务开机自启动

当Ubuntu服务器重启后，刚刚安装的Jexus服务并为随机启动，当你再次在客户机浏览器输入服务器Ip时将会看到下图

[![wps_clip_image-6003](http://images.cnitblog.com/blog/578906/201406/282243062113718.png "wps_clip_image-6003")](http://images.cnitblog.com/blog/578906/201406/282243052587262.png)

当你再次输入 sudo ./jws status 时 会出现下图信息

[![wps_clip_image-20134](http://images.cnitblog.com/blog/578906/201406/282243072261363.png "wps_clip_image-20134")](http://images.cnitblog.com/blog/578906/201406/282243069141334.png)

那么如何解决这个问题呢？

解决方案：

sudo vi /etc/rc.local

在这个配置文件中最后添加一条

/usr/jexus/jws start

10、 Jexus 的各种使用方法详见[http://www.linuxdot.net/bbsfile-3500](http://www.linuxdot.net/bbsfile-3500)

启动：sudo /usr/jexus/jws start
停止：sudo /usr/jexus/jws stop
重启：sudo /usr/jexus/jws restart
重启指定网站：sudo /usr/jexus/jws restart siteName
停止指定网站：sudo /usr/jexus/jws stop siteName

Jexus升级，最新版本 关注 [www.jexus.org](http://www.jexus.org)

cd /tmp
sudo /usr/jexus/jws stop
sudo rm jexus-5.5*
wget http://www.linuxdot.net/down/jexus-5.5.1.tar.gz
tar -zxvf jexus-5.5.1.tar.gz
cd jexus-5.5.1
sudo ./upgrade

11、 配置Asp.Net Mvc4 测试网站

1&gt;在vs中创建mvc4项目&nbsp; 然后发布并上传到/home/icode/software/jexusmono

2&gt;&nbsp; 编辑Jexus配置文件

sudo vi /usr/jexus/siteconf/default&nbsp;

将配置文件中/var/www/default 改为/var/www/cnicode

[![wps_clip_image-8858](http://images.cnitblog.com/blog/578906/201406/282243081641049.png "wps_clip_image-8858")](http://images.cnitblog.com/blog/578906/201406/282243077116976.png)

将测试网站上传到 /home/icode/software/jexusmono/

将网站内容，复制到/var/www/cnicode

cp -Rf /home/icode/software/jexusmono/* /var/www/cnicode

最后重启Jexus服务sudo /usr/jexus/jws restart

运行效果：

[![wps_clip_image-26989](http://images.cnitblog.com/blog/578906/201406/282243094458007.png "wps_clip_image-26989")](http://images.cnitblog.com/blog/578906/201406/282243086482364.png)

&nbsp;

我今天一天都在一边配置一边记录文档，文档弄得自己感觉还可以，执行语句都加粗加红了，看上去有层次感，但是不知道复制到博客上就没有这个感觉了，所以我把文档上传到百度网盘了，大家如果觉得博客看上去不太舒服，可以去下载文档。

下载地址：链接: http://pan.baidu.com/s/1sjtwX9F 密码: 9iji

郝喜路 记录于 2014年6月28日
