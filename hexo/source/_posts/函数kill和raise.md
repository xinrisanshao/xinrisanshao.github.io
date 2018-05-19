---
title: kill和raise
date: 2018-05-17 19:59:00
update: 
tags: [信号]
categories: UNIX环境高级编程
comments: true
---

## kill和raise

kill函数将信号发送给进程或进程组。raise函数则允许进程向自身发送信号。

<!--more-->

```C++
#include <signal.h>
int kill(pid_t pid,int signo);
int raise(int signo);
        //若成功，返回0；若出错，返回-1
```

调用
```C++
raise(signo);
//等价于调用
kill(getpid(),signo);
```

kill的pid参数有以下4中不同的情况。

- pid>0 将该信号发送给进程ID为pid的进程。
- pid == 0 将该信号发送给与发送进程属于同一进程组的所有进程。
- pid < 0 将该信号发送给其他进程组ID等于pid绝对值，而且发送进程具有权限向其发送信号的所有进程。
- pid == -1 该信号发送给发送进程有权限向它们发送信号的所有进程。

```C++
#include "head.h"

static void sig_usr1(int);

int main(void){
	if(signal(SIG_USR1,sig_usr1) == SIG_ERR){
		printf("signal error\n");
	}
	kill(getpid(),SIG_USR1);
	printf("send a SIG_USR1\n");
	exit(0);
}

static void sig_usr1(int signo){
	printf("received a %d signal\n");
}
```

```shell
[vrlive@iZ23chs2r19Z ten]$ ./kill.o 
received a 897804016 signal
send a SIGUSR1
```




