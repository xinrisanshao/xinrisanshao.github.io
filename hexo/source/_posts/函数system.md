---
title: system函数
date: 2018-05-14 20:59:00
update: 
tags: [系统函数]
categories: UNIX环境高级编程
comments: true
---

## 函数system

在程序中执行一个命令字符串很方便，例如，假定要将时间和日期放在某个文件中：通过调用time得到当前日历时间，接着调用localtime将日历时间变换为年、月、日、时、分、秒的分解形式，然后调用strftime对上面的结果进行格式化处理，最后将结果写入到文件中。

<!--more-->

```C++
#include "head.h"
int main(){
	time_t t;
	struct tm *tmp;
	char buf1[16];
	char buf2[64];
	time(&t);
	tmp = localtime(&t);
	if(strftime(buf1,16,"time and date:%r,%a %b %d,%Y",tmp) == 0)
		printf("buffer length 16 is too small\n");
	else 
		printf("%s\n",buf1);
	if(strftime(buf2,64,"time and date:%r,%a %b %d,%Y",tmp) == 0)
		printf("buffer length 64 is too small\n");
	else
		printf("%s\n",buf2);
	return 0;
}
```

```shell
[vrlive@iZ23chs2r19Z six]$ ./strftime.o 
buffer length 16 is too small
time and date:07:31:31 PM,Mon May 14,2018
```

但是用下面的system函数则更容易做到这一点：

```C++
//system("date>file");

#include "head.h"

int main(){
	system("date>file");
	exit(0);
}

```
函数原型：

```C++
#include <stdlib.h>
int system(const char *cmdstring);
```

如果cmdstring是一个空指针，则仅当命令处理程序可用时，system返回非0值，这一特征可以确定在一个给定的操作系统上是否支持system函数。在UNIX中，system总是可用的。

**因为system在其实现中调用了fork、exec和waitpid，因此有3种返回值**。

1. fork失败或者waitpid返回除EINTR之外的出错，则system返回-1，并且设置errno以指示错误类型。
2. 如果exec失败（表示不能执行shell），则其返回值如果shell执行了exit(127)一样。
3. 否则所有3个函数（fork、exec和waitpid）都成功，那么system的返回值是shell的终止状态，其格式已在waitpid中说明。


如下给出了system函数的一种实现。它对信号没有进行处理：

```C++
[vrlive@iZ23chs2r19Z eight]$ cat head.h 
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>
#include <wchar.h>
#include <sys/utsname.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <setjmp.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <errno.h>

#define FLAGS O_RDWR | O_CREAT
#define MODE S_IRUSR | S_IWUSR | S_IXUSR
#define MAXLINE 4096

void pr_exit(int status){
	if(WIFEXITED(status)){
		printf("normal termination,exit status = %d\n",WEXITSTATUS(status));
	}else if(WIFSIGNALED(status)){
		printf("abnormal termination,signal number = %d %s\n",WTERMSIG(status),
	#ifdef WCOREDUMP
		WCOREDUMP(status) ? " (core file generated)" : " ");
	#else  
		" ");
	#endif
	}else if(WIFSTOPPED(status)){
		printf("child stopped,signal number = %d\n",WSTOPSIG(status));
	}
}

int system(const char *cmdstring){    //version without signal handling
	pid_t pid;
	int status;
	if(cmdstring == NULL){
		return(1);   //always a command processor with UNIX
	}
	if( (pid=fork()) < 0){
		status = -1;     //probably out of processes
	}else if(pid == 0){
		execl("/bin/sh","sh","-c",cmdstring,(char*)0);
		_exit(127);    //execl error
	}else{
		while(waitpid(pid,&status,0) < 0){
			if(errno != EINTR){
				status = -1;    //error other than EINTR form waitpid()
			}
		}
	}

	return(status);
}
```

shell的-c选项告诉shell程序取下一个命令行参数（在这里是cmdstring）作为命令输入（而不是从标准输入或从一个给定的文件中读命令）。shell对以null字节终止的字符串进行语法分析，将它们分成命令行参数。传递给shell的命令字符串可以包含任一有效的shell命令。例如，可以用<和>对输入和输出重定向。

注意，我们调用_exit而不是exit。这是为了防止任一标准I/O缓冲（这些缓冲会在fork中由父进程复制到子进程）在子进程中被冲洗。

以下代码对system函数进行测试：

```C++
#include "head.h"

int main(){
	int status;
	if((status = system("date")) < 0){
		printf("system() error\n");
	}
	pr_exit(status);
	if((status = system("nosuchcommand")) < 0){
		printf("system() error\n");
	}
	pr_exit(status);
	if((status = system("who; exit 44")) < 0){
		printf("system() error\n");
	}
	pr_exit(status);
	exit(0);
}
```

```shell
[vrlive@iZ23chs2r19Z eight]$ ./runsystem.o 
Mon May 14 21:00:03 CST 2018
normal termination,exit status = 0     //date
sh: nosuchcommand: command not found
normal termination,exit status = 127     //nosuchcommand
vrlive   pts/0        2018-05-14 19:23 (14.108.28.90)
vrlive   pts/1        2018-05-14 19:23 (14.108.28.90)
vrlive   pts/2        2018-05-14 19:23 (14.108.28.90)
vrlive   pts/3        2018-05-14 20:32 (119.86.103.135)
vrlive   pts/4        2018-05-14 20:40 (119.86.103.135)
normal termination,exit status = 44     //exit 44
```

**使用system而不是直接使用fork和exec的优点是：system进行了所需要的各种出错处理以及各种信号处理**。



下面这一块不太懂，以后再看看：

注：如果一个进程正以特殊的权限（设置用户ID或设置组ID）运行，它又想生成另一个进程执行另一个程序，则它应当直接使用fork和exec，而且在fork之后、exec之前要更改会普通权限，**设置用户ID或者设置组ID程序绝不应调用system函数**。





