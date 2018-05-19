---
title: alarm与pause
date: 2018-05-18 21:59:00
update: 
tags: [信号]
categories: UNIX环境高级编程
comments: true
---

## alarm

**使用alarm函数可以设置一个定时器（闹钟时间），在将来的某个时刻该定时器会超时。当定时器超时时，产生SIGALRM信号。如果忽略或不捕获此信号，则其默认动作是终止调用该alarm函数的进程**。

<!--more-->

```C++
#include <unistd.h>
unsigned int alarm(unsigned int seconds);   //返回值：0或以前设置的闹钟时间的余留秒数
```

参数seconds的值是产生信号SIGALRM需要经过的时钟秒数。当这一时刻到达时，信号由内核产生，由于进程调度的延迟，所以进程得到控制从而能够处理该信号还需要一个时间间隔。

每个进程只能有一个闹钟时间。如果在调用alarm时，之前已为该进程注册的闹钟时间还没有超时，则该闹钟时间的余留值作为本次alarm函数调用的值返回。已经注册的闹钟时间则被新值取代。

如果由以前注册的尚未超过的闹钟时间，而且本次调用的second值是0，则取消以前的闹钟时间，其余留值仍作为为alarm函数的返回值。

### 示例

```C++
#include "head.h"

static void sig_alarm(int signo){
    printf("receivec %d signal\n");
}

int main(void){
	if(signal(SIGALRM,sig_alarm) == SIG_ERR){
		printf("signal error\n");
	}
	alarm(10);
	sleep(5);
	printf("sleep over\n");
	int ret = alarm(2);    //restablished new alarm
	printf("last alarm last second = %d\n",ret);
    pause();
    return 0;
} 
```

```shell
[vrlive@iZ23chs2r19Z ten]$ ./alarm.o 
sleep over
last alarm last second = 5
receivec 14 signal
```

## pause

**pause函数使调用进程挂起直至捕捉到一个信号**。

```C++
#include <unistd.h>
int pause(void);    //返回值-1，errno设置为EINTR
```

**只有执行了一个信号处理程序并从其中返回时，pause才返回**。这种情况下，pause返回-1，errno设置为EINTR。

```C++
#include "head.h"

static void sig_usr(int signo){
	printf("wangxinri\n");
}

int main(void){
	if(signal(SIGUSR1,sig_usr) == SIG_ERR){
		printf("signal error\n");
	}
	printf("begin the pause function\n");
	pause();
	printf("end the main function\n");
	return 0;
}
```

```shell
[vrlive@iZ23chs2r19Z ten]$ ps -auf
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
vrlive    5263  0.0  0.0 115512  2148 pts/0    Ss   19:50   0:00 -bash
vrlive    5291  0.0  0.0   4168   356 pts/0    S+   19:51   0:00  \_ ./sleep.o
vrlive    5226  0.0  0.0 115512  2144 pts/1    Ss   19:45   0:00 -bash
vrlive    5293  0.0  0.0 139496  1612 pts/1    R+   19:52   0:00  \_ ps -auf
root       473  0.0  0.0 110036   844 tty1     Ss+   2017   0:00 /sbin/agetty --noclear tty1 linux
[vrlive@iZ23chs2r19Z ten]$ kill -USR1 5291


[vrlive@iZ23chs2r19Z ten]$ ./sleep.o 
begin the pause function
wangxinri
end the main function
```








