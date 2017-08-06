---
title: github Pages + Hexo搭建个人博客（一）  初级篇
date: 
update: 
tags: [hexo,github]
categories: hexo
comments: true
---
# 一、前言
之前一直是在有道云上做一些笔记的，上周末在网上看到了一些别人搭建的个人博客，顿时感兴趣起来，然后自己就瞎捣鼓了几天，最终搭建成功了，哈哈。在这个过程中发现，搭建一个网站还是比较简单的，难得是管理博客，更难的是写博客！！！
<!--more-->
这个过程中，注册了自己的第一个github账号（很失败有木有，太out了），同时也了解了一些git的版本控制，还知道了Markdown这种标记语言，后面的这些博客都是用这个标记语言写的，还是很有收获的。

今天特地总结一下使用github Pages + Hexo搭建个人博客的过程，以备不时之需。这里不谈理论，只谈过程，理论自己也不是很清楚，就不瞎说了，以后慢慢熟悉了，在补充！


# 二、环境准备
## 1. 注册github账号
这个就不多说了，账号注册好后，登陆，在首页右边有一个 **+** 号图标，点击之后，选择New repository进行仓库的创建。Repository name命名为username.github.io（username是你的账号名，记住一定要这样命令哦)，点击Create repository，创建成功。
## 2. 安装Git
我们之所以要安装git，是因为后面我们要用到git命令，将生成的静态博客网页等信息推送至github仓库，我们的git使用一般由两种方式，一种是**图形化界面（GUI）**,另外一种是通过**命令行**。这里我选择安装前者，带界面的，菜鸟嘛，不会git命令，先熟悉熟悉流程，顺带在这个过程中在了解git的一些常用命令。另外安装前者，在桌面上会生成两个图标， **GitHub和Git Shell**,这两个图标分别是图形界面和命令行工具，意思就是我们不仅可以使用图形界面的工具管理我们github上的仓库，同时也可以使用命令行的形式管理，自由切换，爽歪歪！

Github for Windows: [点击下载](http://download.csdn.net/detail/devsplash/9666012)

下载安装完后，桌面上生成**GitHub和Git Shell**两个图标，然后点击**GitHub**图标，输入前面注册的github账号和密码，登录完成，ok，暂时先这样，接着往下走。

Github for Windows 安装配置使用教程: [参考](http://blog.csdn.net/chenxun_2010/article/details/43670651)

## 3. 安装Node.js

安装Node.js,因为Hexo是一个基于Node.js的静态博客程序，所以首先安装Node.js。

点击进入[Node.js官网](https://nodejs.org/en/)

我们选择左边的通用版，点击下载后，设置安装路径然后默认安装就可以了。

## 4. 安装Hexo

以上环境配好了之后，那么恭喜您！接下来只需要使用npm即可完成Hexo的安装。

打开终端，输入：

``` bash
npm install -g hexo-cli
```

如果执行这条命令时长时间未成功，那么请先使用下面的命令将npm镜像源更改为国内的镜像，再执行上面的安装命令，因为国外的镜像源很有可能被墙了。

``` bash
npm config set registry https://registry.npm.taobao.org
```

安装好Hexo以后，在终端输入：

``` bash
hexo
```

若出现下图，说明hexo安装成功：

![](http://ou6yob3zd.bkt.clouddn.com/20170806141617.png)

# 三、使用Hexo建站

## 1. 初始化博客

新建一个网站。如果没有设置 folder ，Hexo 默认在目前的文件夹建立网站。比如我在终端进入到G:Github目录，输入hexo init hexo，则在该目录下创建了hexo博客文件夹。

``` bash
hexo init [folder]
```

接下来进入到博客文件夹，这里是E:Github/hexo，执行如下命令，根据该目录下的package.json中既定的dependencies配置安装所有的依赖包

``` bash
npm install
```

## 2. 配置

网站的主配置文件为hexo根目录下的**_config.yml**文件：

默认配置如下：

{% codeblock %}
# Hexo Configuration
## Docs: https://hexo.io/docs/configuration.html
## Source: https://github.com/hexojs/hexo/

# Site
title: Hexo
subtitle:
description:
author: John Doe
language:
timezone:

# URL
## If your site is put in a subdirectory, set url as 'http://yoursite.com/child' and root as '/child/'
url: http://yoursite.com
root: /
permalink: :year/:month/:day/:title/
permalink_defaults:

# Directory
source_dir: source
public_dir: public
tag_dir: tags
archive_dir: archives
category_dir: categories
code_dir: downloads/code
i18n_dir: :lang
skip_render:

# Writing
new_post_name: :title.md # File name of new posts
default_layout: post
titlecase: false # Transform title into titlecase
external_link: true # Open external links in new tab
filename_case: 0
render_drafts: false
post_asset_folder: false
relative_link: false
future: true
highlight:
  enable: true
  line_number: true
  auto_detect: false
  tab_replace:
  
# Home page setting
# path: Root path for your blogs index page. (default = '')
# per_page: Posts displayed per page. (0 = disable pagination)
# order_by: Posts order. (Order by date descending by default)
index_generator:
  path: ''
  per_page: 10
  order_by: -date
  
# Category & Tag
default_category: uncategorized
category_map:
tag_map:

# Date / Time format
## Hexo uses Moment.js to parse and display date
## You can customize the date format as defined in
## http://momentjs.com/docs/#/displaying/format/
date_format: YYYY-MM-DD
time_format: HH:mm:ss

# Pagination
## Set per_page to 0 to disable pagination
per_page: 10
pagination_dir: page

# Extensions
## Plugins: https://hexo.io/plugins/
## Themes: https://hexo.io/themes/
theme: landscape

# Deployment
## Docs: https://hexo.io/docs/deployment.html
deploy:
  type:

{% endcodeblock %}

这些配置项所代表的意思可以参考Hexo中文网：[_config.yml配置](https://hexo.io/zh-cn/docs/configuration.html) ，我们需要修改的配置只有这几项，拿我自己修改的配置作为示例。

### 1). 修改网站相关信息

``` bash
title: 新日三少的博客 
subtitle: Big big pig   
description: Love Coding,Enjoy Life
author: 新日三少
language: zh-CN      #themes主题文件夹下的languages下面有很多语言可选
timezone: Asia/Shanghai
```

**注意**：每一项的填写，其:后面都要保留一个空格，下同。

### 2). 配置统一资源定位符（个人域名）

``` bash
url: http://www.wangxinri.cn
```

对于root（根目录）、permalink（永久链接）、permalink_defaults（默认永久链接）等其他信息保持默认。
如无个人域名，无需修改这一项。

### 3). 配置部署

``` bash
deploy: 
  type: git
  repo: https://github.com/xinrisanshao/xinrisanshao.github.io.git
  branch: master
```
其中repo项是之前Github上创建好的仓库的地址，，可以通过如下图所示的方式得到：

![](http://ou6yob3zd.bkt.clouddn.com/20170806151918.png)

## 3.  本地发布博客

接下来，在网站中建立第一篇文章，**打开终端，进入到博客文件夹根目录**，这里是E:Github/hexo，然后输入

``` bash
hexo new "文章标题"
```

我们可以在本地博客文件夹source->_post文件夹下看到我们新建的markdown文件。通过Markdown编辑器对我们文章进行编辑，我这采用的是Markdownpad2编辑器。

MarkdownPad2：[点击下载](http://download.csdn.net/detail/rentongtmd/8333707)

Markdown语法：[Marddown中文网](http://www.markdown.cn/)

为了能够使Hexo部署到GitHub上，需要安装一个插件：

``` bash
npm install hexo-deployer-git --save
```

接下来,我们进行本地发布：
``` bash
hexo generate
hexo server      
```

执行完后，打开浏览器，输入：
``` bash
http://localhost:4000/
```

我们可以在浏览器端看到我们搭建好的博客和发布的文章，如果访问失败，可能端口被占用，更换端口 hexo server -p 5000 ,将默认4000端口换成5000。
![](http://ou6yob3zd.bkt.clouddn.com/20170806161241.png)

## 4. 发布博客至github仓库

但是毕竟我们目前发布的博客只有本机看得到，怎么让其他人看到我们写的博客呢？这时候我们来看看博客的部署。

打开终端，进入到博客文件夹根目录，这里还是**E:Github/hexo**，执行如下命令：

``` bash
hexo generate
hexo deploy      
```

输入我们的网址：[xinrisanshao.github.io](http://xinrisanshao.github.io) ,即可访问博客了。

此时查看github中的仓库，发现我们博客文件夹根目录中的**public文件夹**里面的文件已经发布到仓库中了。

此时搭建的博客还只是入门，外观确实一般般，接下来将更进一步，比如如何更换主题、如何管理博客等等。

好累啊，先休息下，果然还是写博客最累啊。