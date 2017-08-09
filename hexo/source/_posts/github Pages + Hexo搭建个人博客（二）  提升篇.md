---
title: github Pages + Hexo搭建个人博客（二）  提升篇
date: 2017-08-07 12:59:25
update:
tags: [hexo,github]
categories: hexo
comments: true
---
# 一、前言
在之前的**初级篇**中介绍了如何搭建个人博客。本文介绍如何更换博客主题、设置第三方服务和最重要的如何管理发布博客。
<!--more-->
# 二、更换主题
在这篇文章中，假定你已经成功安装了Hexo,并使用Hexo提供的命令创建了一个站点。

在Hexo中有两份主要的配置文件，其名称都是**_config.yml**。其中，一份位于站点根目录下（此处为G:\GitHub\hexo），主要包含Hexo本身的配置；另一份位于主题根目录下，这份配置由主题作者提供，主要用于配置主题相关的选项。

为了描述方便，在以下说明中，将前者称为**站点配置文件**，后者称为**主题配置文件**。 

## 1. 安装NexT
Hexo 安装主题的方式非常简单，只需要将主题文件拷贝至站点目录的 themes 目录下， 然后修改下配置文件即可。具体到 NexT 来说，安装步骤如下。 
### 1) 下载主题
如果你熟悉Git，建议你使用**克隆最新版本**的方式，之后的更新可以通过**git pull**来快速更新，而不用再次下载压缩包替换。 （说多了都是累啊，早知道就该看官网了，我就是下载的压缩包，估计是没法快速更新了）

在终端窗口下，定位到 Hexo 站点目录下。使用 Git 命令：
``` bash
cd G:\GitHub\hexo
git clone https://github.com/iissnan/hexo-theme-next themes/next  #后面意思是clone到该目录下themes/next文件夹中
```
### 2) 启用主题
与所有 Hexo 主题启用的模式一样。当克隆/下载完成后，打开**站点配置文件**，找到**theme**字段，并将其值更改为**next**。 

``` bash
theme: next
```
此时我们在**主题配置文件**中设置语言。修改**language**字段。在主题的languages文件夹中选择语言，此处目录为G:\GitHub\hexo\themes\next\languages 。

``` bash
language: zh-Hans   #选择汉语，选择其他语言填写其他值即可
```

到此，NexT主题安装完成。下一步将验证主题是否正确启用。在切换主题之后、验证之前，我们最好使用hexo clean 来清除Hexo的缓存。 

### 3) 验证主题

进入到博客文件夹根目录，此处为G:\GitHub\hexo，执行如下命令：

``` bash
hexo clean  #更换主题，最好先清除Hexo缓存
hexo generate  #生成静态页面
hexo server   # hexo server -p **** 更换默认4000端口为****
```

此时即可使用浏览器访问 http://localhost:4000。

检查站点是否正确运行，如长时间访问不了，更改端口。

![](http://ou6yob3zd.bkt.clouddn.com/20170808201948.png)

现在，你已经成功安装并启用了NexT主题。下一步我们将要更改一些主题的设定，包括个性化以及集成第三方服务。

# 三、主题设定

NexT官网和网上资料非常丰富，就不细说了，参考如下：

官方参考：[NexT使用文档](http://theme-next.iissnan.com/getting-started.html)

网上资源：[hexo的next主题个性化教程：打造炫酷网站](http://blog.csdn.net/qq_33699981/article/details/72716951)

**补充几点：**
## 1. 添加评论功能
我选择的是**来比力**，很简单，注册一个账号，妈的，是韩国的网站，发验证码竟然是韩文，通过有道词典才知道它讲的是啥，输入四位验证码回车后，然后填写相关信息，申请获取代码，然后得到安装代码中的data-uid。

编辑主题配置文件， 编辑 livere_uid 字段，设置如下：

``` bash
livere_uid: #your livere_uid
```

## 2. 修改背景图片

首先找到一个背景图片放到 hexo（hexo工程文件）-> themes -> next -> source -> images 的路径下；

然后进入hexo（hexo工程文件）-> themes -> next -> source -> css -> _custom ，找到路径下的custom.styl文件，在文件的最上方加入如下代码就完事了。

``` bash
// Custom styles.
body {
  background:url(/images/background.jpeg);
  background-attachment: fixed;   #固定背景图，使得不随页面移动
}
```

## 3. 修改博客内容宽度
Pisces Scheme 直接在./themes/next/source/css/_variables/custom.styl文件中添加

``` bash
$main-desktop = 1200px 
$content-desktop = 900px
```

可以避免直接修改源码，可以解决内容宽度问题，而且在移动设备上显示正常。

参考：[感觉浏览器留白太多，代码块看起来比较麻烦](https://github.com/iissnan/hexo-theme-next/issues/759#issuecomment-202242848)

到这的时候，主题应该也优化的差不多，接下来就是写博客和管理了，加油搞起。

# 四、博客管理维护

## 1. 概述

Hexo部署到GitHub上的文件，是.md（你的博文）转化之后的.html（静态网页）。因此，当你重装电脑或者想在不同电脑上修改博客时，因为.md文件不存在了，就不可能了（除非你自己写html）。

其实，Hexo生成的网站文件中有.gitignore文件，因此它的本意也是想我们将Hexo生成的网站文件存放到GitHub上进行管理的（而不是用U盘或者云备份啦）。这样，不仅解决了上述的问题，还可以通过git的版本控制追踪你的博文的修改过程，是极赞的。

**注：** .gitignoree文件中的内容是忽略上传至Github仓库的文件，这里我修改成如下：
``` bash
.deploy*/    #只忽略上传.deploy*/开头的文件
```

但是，如果每一个GitHub Pages都需要创建一个额外的仓库来存放Hexo网站文件，我感觉很麻烦（10个项目需要20个仓库）。

所以，我利用了分支！！！

简单地说，每个想建立GitHub Pages的仓库，起码有两个分支，一个用来存放Hexo网站的文件，一个用来发布网站。

下面以我的博客作为例子详细地讲述。

## 2. 博客搭建流程

  1.创建仓库，xinrisanshao.github.io；

  2.创建两个分支：master 与 hexo；

  3.设置hexo为默认分支（因为我们只需要手动管理这个分支上的Hexo网站文件）；

  4.使用如下命令拷贝仓库

``` bash
git clone https://github.com/xinrisanshao/xinrisanshao.github.io.git 
```
  
  5.在本地xinrisanshao.github.io文件夹下通过Git shell依次执行npm install hexo、hexo init、npm  
   install 和 npm install hexo-deployer-git（此时当前分支应显示为hexo）;

  6.修改_config.yml中的deploy参数，分支应为master；
  
  7.依次执行git add .、git commit -m “…”、git push origin hexo提交网站相关的文件（Hexo网站根目录执行）；

  8.执行hexo generate -d生成网站并部署到GitHub上（Hexo网站根目录执行）。

这样一来，在GitHub上的xinrisanshao.github.io仓库就有两个分支，一个hexo分支用来存放网站的原始文件，一个master分支用来存放生成的静态网页。修改了博客网站原始文件，然后发布到hexo分支上进行保存，同时修改后新的静态网页deploy到master,同步更新，两者都保存至Github仓库上，不怕文件丢失了。

**注：**流程的5,6步hexo init创建的是一个新的Hexo网站文件，我们在本地配置好的Hexo+next主题的网站文件可以直接复制到.\xinrisanshao.github.io\文件夹中，直接代替5,6步创建的流程，这样就不需要我们再次重复配置了，其他的过程都是一样的。

## 3. 博客管理流程

### 1. 编辑与修改博客

在本地对博客进行修改（添加新博文、修改样式等等）后，通过下面的流程进行管理：

1.依次执行git add .、git commit -m “…”、git push origin hexo指令将改动推送到GitHub（此时当前分支应为hexo）；

2.然后才执行hexo generate -d发布网站到master分支上。

虽然两个过程顺序调转一般不会有问题，不过逻辑上这样的顺序是绝对没问题的（例如突然死机要重装了，悲催….的情况，调转顺序就有问题了）。

### 2. 本地资料丢失
当重装电脑之后，或者想在其他电脑上修改博客，可以使用下列步骤：
1.首先安装Git，Node.js和Hexo。

2.使用git clone git@github.com:CrazyMilk/CrazyMilk.github.io.git拷贝仓库（默认分支为hexo）；

3.因为之前的.gitignore文件只忽略了上传.deploy*/开头的文件，所以我们上传到hexo分支的是整个的Hexo网站文件，下载之后直接什么依赖配置都好了，此时即可照着编辑与修改博客流程进行博客编辑了，大功告成。

以上博客管理参考：[点击查看](http://crazymilk.github.io/2015/12/28/GitHub-Pages-Hexo%E6%90%AD%E5%BB%BA%E5%8D%9A%E5%AE%A2/#more)

### 3. 博客图片存放（补）
如果将博客的图片放在Hexo网站文件中，那么加载博客的时候会变得非常慢，此时，我们可以选择一个合适的图床存放图片，然后获得图片的链接地址，这样访问速度会变快许多。

我选择的是**七牛云**存放图片，具体使用方法很简单，注册账号，上传图片至空间中，这些就不细说了，网上一大堆资料。


# 五、总结

不想再敲了，好累！这也算是对搭建这个博客的一个总结吧，休息去。





