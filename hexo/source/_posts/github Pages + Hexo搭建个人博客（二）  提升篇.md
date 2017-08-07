---
title: github Pages + Hexo搭建个人博客（二）  提升篇
date: 2017-08-07 12:59:25
update:
tags: [hexo,github]
categories: hexo
comments: true
---
# 一、前言
在之前的[初级篇](http://wangxinri.cn/2017/08/06/github Pages + Hexo搭建个人博客（一） 初级篇/)中介绍了如何搭建个人博客。本文介绍如何更换博客主题、设置第三方服务和最重要的如何管理发布博客。
<!--more-->
# 二、更换主题
在这篇文章中，假定你已经成功安装了Hexo,并使用Hexo提供的命令创建了一个站点。

在Hexo中有两份主要的配置文件，其名称都是**_config.yml**。其中，一份位于站点根目录下（此处为G:\GitHub\hexo），主要包含Hexo本身的配置；另一份位于主题根目录下，这份配置由主题作者提供，主要用于配置主题相关的选项。

为了描述方便，在以下说明中，将前者称为**站点配置文件**，后者称为**主题配置文件**。 

## 1. 安装NExT
Hexo 安装主题的方式非常简单，只需要将主题文件拷贝至站点目录的 themes 目录下， 然后修改下配置文件即可。具体到 NexT 来说，安装步骤如下。 
### 1）下载主题
如果你熟悉Git，建议你使用**克隆最新版本**的方式，之后的更新可以通过**git pull**来快速更新，而不用再次下载压缩包替换。 （说多了都是累啊，早知道就该看官网了，我就是下载的压缩包，估计是没法快速更新了）

在终端窗口下，定位到 Hexo 站点目录下。使用 Git 命令：
``` bash
cd G:\GitHub\hexo
git clone https://github.com/iissnan/hexo-theme-next themes/next  #后面意思是clone到该目录下themes/next文件夹中
```
### 2)启用主题
与所有 Hexo 主题启用的模式一样。当克隆/下载完成后，打开**站点配置文件**，找到**theme**字段，并将其值更改为**next**。 
``` bash
theme: next
```
