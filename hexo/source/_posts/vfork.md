---
title: vfork
date: 2018-04-20 22:59:00
update: 
tags: [进程]
categories: UNIX环境高级编程
comments: true
---

## vfork

vfork函数的调用序列和返回值与fork相同，但两者的语义不同。

<!--more-->

vfork函数用于创建一个新进程，而该新进程的目的是exec一个新程序。vfork和fork一样都会创建一个子进程，**但是它并不将父进程的地址空间完全复制到子进程中，因为子进程会立即调用exec(或exit)，于是它并不会引用该地址空间**。不过在子进程调用exec或exit之前，它在父进程的空间中运行。这种优化工作方式在某些UNIX系统的实现中提高了效率，但如果子进程修改了数据（除了用于存放vfork返回值的变量）、进行函数调用、或者没有调用exec或exit就返回都可能带来未知的结果（就像上一节fork中提及的，实现采用写时复制技术以提高fork之后跟随exec操作的效率，但是不复制比部分赋值还是更快一些）。

vfork和fork之间的另一个区别是：**vfork保证子进程先运行，再它调用exec或者exit之后父进程才可能被调度运行（子进程调用exec或exit之前，内核会使父进程处于休眠状态），当子进程调用这两个函数中的任意一个时，父进程会恢复运行。（如果在调用这两个函数之前子进程依赖于父进程的进一步动作，则会导致死锁）**。

### 示例

```C++
#include "head.h"
int globvar = 6;
int main(void){
	int var;
	pid_t pid;
	var = 88;
	printf("before vfork\n");
	if( (pid=vfork()) < 0){
		printf("vfork error\n");
	}else if(pid == 0){  
		++globvar;     //child;
		++var;
		_exit(0);    //child terminates
	}
	//parent continues here
	printf("pid = %d,glob = %d,var = %d\n",getpid(),globvar,var);
	exit(0);
}
```

```
[vrlive@iZ23chs2r19Z eight]$ ./vfork.o 
before vfork
pid = 29440,glob = 7,var = 89
```

子进程对变量做增1的操作，结果改变了父进程中的变量值。因为子进程子进程在父进程的地址空间中运行，所以这并不令人惊讶。但是其作用的确与fork不同。

### fork与vfork的区别：


1）fork()： 父子进程的执行次序不确定。

vfork()：保证子进程先运行,在它调用 exec（进程替换） 或 exit（退出进程）之后父进程才可能被调度运行。

2）fork()： 子进程拷贝父进程的地址空间，子进程是父进程的一个复制品。

vfork()：子进程共享父进程的地址空间（准确来说，在调用 exec（进程替换） 或 exit（退出进程） 之前与父进程数据是共享的）

![image](http://ou6yob3zd.bkt.clouddn.com/vfork.png)


**用 vfork() 创建进程，子进程里一定要调用 exec（进程替换） 或 exit（退出进程 _exit(0) ），否则，程序会出问题，没有意义。**

[参考：vfork() 函数详解](https://blog.csdn.net/tennysonsky/article/details/45847107)













