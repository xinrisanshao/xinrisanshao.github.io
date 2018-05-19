---
title: exec系列
date: 2018-05-14 21:59:00
update: 
tags: [进程]
categories: UNIX环境高级编程
comments: true
---

## exec

用fork函数创建新的子进程后，子进程往往要调用一种exec函数以执行另一个程序，**当进程调用一种exec函数时，该进程执行的程序完全替换为新程序，而新程序则从其main函数开始执行。因为调用exec并不创建新进程，所以前后的进程ID并未改变。exec只是用磁盘上的一个新程序替换了当前进程的正文短、数据段、堆段和栈段**。

<!--more-->

有7中不同的exec函数可供使用，它们常常被统称为exec函数，我们可以使用这7个函数中的任一个。这些exec函数使得UNIX系统进程控制原语更加完善。用fork可以创建新进程，用exec可以初始执行新的程序。exit函数和wait函数处理终止和等待终止。这些是我们需要的基本的进程控制原语。

```C++
#include <unistd.h>
int execl(const char *pathname,const char *arg0, ... /* (char*)0  */ );
int execv(const char *pathname,char *const argv[]);
int execle(const char *pathname,const char *arg0, ...  /* (char*)0,char *const envp[] */);
int execve(const char *pathname,char *const argv[],char *const envp[]);
int execlp(const char *filename,const char *arg0, ...   /* (char*)0  */);
int execvp(const char *filename,char *const argv[]);
int fexecve(int fd,char *const argv[],char *const envp[]);
            //若出错，返回-1；若成功，不返回
```

这些函数之间的**第一个区别**是前4个函数去路径名作为参数，后两个函数则取文件名作为参数，最后一个取文件描述符作为参数。当指定filename作为参数时：

- 如果filename中包含/，则就将其视为路径名。
- **否则就按PATH环境变量，在它所指定的各目录中搜寻可执行文件**。

PATH变量包含了一张目录表（称为路径前缀），目录之间用冒号（:）分隔。

**查看PATH环境变量**：

```
[vrlive@iZ23chs2r19Z eight]$ env | grep PATH
PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/vrlive/.local/bin:/home/vrlive/bin
```

如果execlp或者execvp使用路径前缀中的一个找到了一个可执行文件，但是该文件不是由连接编辑器长生的机器可执行文件，则就认为该文件是一个shell脚本，于是试着调用/bin/sh，并以该filename作为shell的输入。

**第二个区别**与参数表的传递有关（l表示list，v表示矢量vector）。函数execl、execlp和execle要求将新程序的每个命令行参数都说明为一个单独的参数，这种参数以空指针结尾（(char*)0）。对于另外4个函数（execv、execvp、execve和fexecve），则应先构造一个指向各参数的指针数组，然后将该数组地址作为这4个函数的参数。

**最后一个区别**与向新程序传递的环境表相关。以e结尾的3个函数（execle、execve和fexecve）可以传递一个指向环境字符串指针数组的指针。其他4个函数则使用调用进程中的environ变量为新程序复制现有环境。

这7个exec函数的参数很难记忆。函数名中的字符串会给我们一些帮助。字母p表示该函数取filename作为参数，并且用PATH环境变量寻找可执行文件。字母l表示该函数取一个参数表，它与字母v互斥。v表示该函数取一个argv[]矢量。最后，字母e表示该函数取envp[]数组，而不使用当前环境。下图显式了这7个函数之间的区别。

![image](http://ou6yob3zd.bkt.clouddn.com/7%E4%B8%AAexec%E5%87%BD%E6%95%B0%E4%B9%8B%E9%97%B4%E7%9A%84%E5%8C%BA%E5%88%AB.png)

在很多UNIX实现中，这7个函数中只有execve时内核的系统调用。另外6个只是库函数，他们最终都要调用该系统调用。这7个函数之间的关系如下：

![image](http://ou6yob3zd.bkt.clouddn.com/7%E4%B8%AAexec%E5%87%BD%E6%95%B0%E4%B9%8B%E9%97%B4%E7%9A%84%E5%85%B3%E7%B3%BB.png)

在这种安排下，库函数execlp和execvp使用PATH环境变量，查找查找第一个包含名为filename的可执行文件的路径名前缀。fexecve库函数使用/proc把文件描述符参数转换成路径名，execve用该路径名去执行程序。

### 示例

演示execle和execlp的用法

exec.c

```C++
#include "head.h"

char *env_init[] = {"USER = unknown","PATH=/tmp",NULL};
int main(void){
	pid_t pid;
	if((pid = fork()) < 0){
		printf("fork error\n");
	}else if(pid == 0){     //child   specify pathname,specify environment
		if(execle("/home/vrlive/linuxProgram/apueProgram/eight/echoall.o","echoall.o","myarg1","MY ARG2",(char*)0,env_init) < 0) 
			printf("execle error\n");
	}

	if(waitpid(pid,NULL,0) < 0){
		printf("waitpid error\n");
	}

	if((pid = fork()) < 0){
		printf("fork error\n");
	}else if(pid == 0){
		if(execlp("echoall.o","echoall.o","only 1 arg",(char*)0) < 0)
			printf("execlp error\n");
	}
	if(waitpid(pid,NULL,0) < 0){
		printf("waitpid error\n");
	}
	
	exit(0);
}
```

程序要执行两次的echoall程序如下echoall.c所示。这是一个很普通的程序，它回显所有命令行参数及全部环境表。

**注意**：

- 我们将第一个参数（新程序中的argv[0]）设置为路径名的文件名分量（"echoall.o"）。某些shell将此参数设置为完全的路径名。这只是一个惯例。我们可将argv[0]设置为任何字符串。当login命令执行shell时就是这样做的。在执行shell之前，login在argv[0]之前加一个/作为前缀，这向shell指明它是作为登录shell被调用的。登录shell将执行启动配置文件（start-up profile）命令，而非登录shell则不会执行这些命令。
- execle要求路径名和一个特定的环境。而execlp，它用一个文件名，所以其PATH环境变量所指向的各目录中搜寻可执行文件，我们的echoall.o在/home/vrlive/bin也有一份。

```
[vrlive@iZ23chs2r19Z eight]$ env | grep PATH
PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/vrlive/.local/bin:/home/vrlive/bin
```

echoall.c

```C++
#include "head.h"
int main(int argc,char *argv[]){
	int i;
	char **ptr;
	extern char **environ;    //extern the environ
	for(i = 0;i<argc;++i){    //echo all command-line args
		printf("argv[%d]: %s\n",i,argv[i]);
	}
	for(ptr = environ;*ptr!=0;++ptr){
		printf("%s\n",*ptr);
	}
	exit(0);
}
```

```
[vrlive@iZ23chs2r19Z eight]$ ./exec.o 
argv[0]: echoall.o
argv[1]: myarg1
argv[2]: MY ARG2
USER = unknown
PATH=/tmp                          //first child  end
argv[0]: echoall.o              
argv[1]: only 1 arg
XDG_SESSION_ID=25503
HOSTNAME=iZ23chs2r19Z
TERM=xterm
SHELL=/bin/bash
HISTSIZE=1000
SSH_CLIENT=14.108.30.83 34140 22
SSH_TTY=/dev/pts/2
USER=vrlive
LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=01;36:*.au=01;36:*.flac=01;36:*.mid=01;36:*.midi=01;36:*.mka=01;36:*.mp3=01;36:*.mpc=01;36:*.ogg=01;36:*.ra=01;36:*.wav=01;36:*.axa=01;36:*.oga=01;36:*.spx=01;36:*.xspf=01;36:
MAIL=/var/spool/mail/vrlive
PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/vrlive/.local/bin:/home/vrlive/bin
PWD=/home/vrlive/linuxProgram/apueProgram/eight
LANG=en_US.UTF-8
HISTCONTROL=ignoredups
SHLVL=1
HOME=/home/vrlive
LOGNAME=vrlive
SSH_CONNECTION=14.108.30.83 34140 172.16.0.1 22
LESSOPEN=||/usr/bin/lesspipe.sh %s
XDG_RUNTIME_DIR=/run/user/1000
_=./exec.o
OLDPWD=/home/vrlive/linuxProgram/apueProgram
```


