---
title: exit与wait函数系列
date: 2018-05-15 21:59:00
update: 
tags: [系统函数]
categories: UNIX环境高级编程
comments: true
---

## 函数exit

进程有5中正常终止和3中异常终止方式。**5中正常终止方式具体如下**：

<!--more-->

1. 在main函数内执行return语句。这等效于调用exit。
2. 调用exit函数，此函数由ISO C定义，其操作包括调用各终止处理程序（终止处理程序在调用atexit函数时登记），然后关闭所有标准I/O流等。
3. 调用_exit或者 _Exit函数。ISOC定义 _Exit，其目的是为进程提供一种无需运行终止处理程序或信号处理程序而终止的方法。对标准I/O流是否进行冲洗，这取决于实现。在UNIX系统中， _Exit和 _exit是同义的，并不冲洗标准I/O流。 _exit函数由exit函数调用（在大多数UNIX系统实现中，exit是标准C库中的一个函数，而 _exit则是一个系统调用）。
4. 进程的最后一个线程在其启动例程中执行return语句。但是，该线程的返回值不用作进程的返回值。当最后一个线程从其启动例程返回时，该进程以终止状态0返回。
5. 进程的最后一个线程调用pthread_exit函数，如同前面一样，在这种情况中，进程终止状态总是0，这与传送给pthread_exit的参数无关。

**3中异常终止具体如下**：

1. 调用abort。它产生SIGABRT信号，这是下一种异常终止的一种特例。
2. 当进程接收到某些信号时。信号可由进程自身（如调用abort函数）、其他进程或内核产生。例如，若进程引用地址空间之外的存储单元、或者除以0，内核就会为该进程产生响应的信号。
3. 最后一个线程对“取消”（cancellation）请求作出响应。默认情况下，“取消”以延迟方式发生：一个线程要求取消另一个线程，若干时间之后，目标线程终止。

**不管进程如何终止，最后都会执行内核中的同一段代码。这段代码为相应进程关闭所有打开描述符，释放它所使用的存储器等。**

```C++
#include <stdlib.h>
void exit(int status);
void _Exit(int status);
#include <unistd.h>
void _exit(int status);
```

对上述任意一种终止情形，我们都希望终止进程能够通知其父进程它是如何终止的。对于3个终止函数（exit、_exit和 _Exit），实现这一点的方法是，将其退出状态（exit status）作为参数传递给函数。在异常终止情况，内核（不是进程本身）产生一个指示其异常终止原因的终止状态（termination status）。**在任意一种情况下，该终止进程的父进程都能用wait或waitpid函数取得其终止状态**。

子进程在父进程调用fork后产生，子进程将其终止状态返回给父进程。但是如果父进程在子进程之前终止，将如何呢？

**对于父进程已经终止的所有进程，它们的父进程都改变为init进程。我们称这些进程由init进程收养。其操作过程大致是：在一个进程终止时，内核逐个检查所有活动进程，以判断它是否是正要终止进程的子进程，如果是，则该进程的父进程ID就改为1（init进程ID）。这种处理办法保证了每个进程有一个父进程**。

**内核为每个终止子进程保存了一定量的信息，所以当终止进程的父进程调用wait或者waitpid时，可以得到这些信息**。这些信息至少包括进程ID、该进程的终止状态以及该进程使用的CPU时间总量。内核可以释放终止进程所使用的所有存储区，关闭其所有打开文件。

在UNIX术语中，一个已经终止、但是其父进程尚未对其进行善后处理（获取终止子进程的有关信息，释放它仍占用的资源）的进程称为**僵死进程**（Zombie）

一个由init进程收养的进程终止时会发生什么？它会不会变成一个僵死进程？对此问题的回答是“否”，因为**init被编写成无论何时只要有一个子进程终止，init就会调用一个wait函数取得其终止状态。这样也就防止了系统中塞满僵死进程**。


## 函数wait和waitpid

当一个进程正常或异常终止时，内核就向其父进程发送SIGCHLD信号，因为子进程终止是个异步时间（这可以在父进程运行的任何时候发生），所以这种信号也是内核向父进程发的异步通知。父进程可以选择忽略该信号，或者提供一个该信号发生时即被调用执行的函数（信号处理程序）。对于这种信号的系统默认动作是忽略它，现在需要知道的是调用wait或waitpid的进程可能会发生什么。

- 如果其所有子进程都还在运行，则阻塞。
- 如果一个子进程已终止，正等待父进程获取其终止状态，则取得该子进程的终止状态立即返回。
- 如果它没有任何子进程，则立即出错返回。

如果进程由于接收到SIGCHLD信号而调用wait，我们期望wait会立即返回。但是如果在调用wait，则进程可能会阻塞。

```C++
#include <sys/wait.h>
pid_t wait(int *statloc);
pid_t waitpid(pid_t pid,int *statloc,int options);
//两个函数返回值：若成功，返回进程ID；若出错，返回0或-1
```

**两个函数的区别**
- 在一个子进程终止前，wait使其调用者阻塞，而waitpid有一选项，可使调用者不阻塞。
- waitpid并不等待在其调用之后的第一个终止进程，它有若干个选项，可以控制它所等待的进程。


如果子进程已经终止，并且是一个僵死进程，则wait立即返回并取得该子进程的状态；否则wait使其调用者阻塞，直到一个子进程终止。如调用者阻塞而且它有多个子进程，则在其某一子进程终止时，wait就立即返回。**因为wait返回终止子进程的进程ID，所以它总能了解是哪一个子进程终止了**。

这两个函数的参数statloc是一个整型指针。如果statloc不是一个空指针，则终止进程的终止状态就存放在它所指向的单元内。如果不关心终止状态，则可将该参数指定为空指针。

依据传统，这两个函数返回的整型状态字是由实现定义的。其中某些位表示退出状态（正常返回），其他位则指示信号编号（异常返回），有一位指示是否产生了core文件等。POSIX.1规定，终止状态用定义在<sys/wait.h>中的各个宏来查看。有4个互斥的宏可用来取得进程终止的原因，它们的名字都以WIF开始。基于这4个宏中哪一个值为真，就可选用其他宏来取得退出状态、信号编号等，这4个互斥的宏如下图：

![image](http://ou6yob3zd.bkt.clouddn.com/wait%E5%92%8Cwaitpid%E6%89%80%E8%BF%94%E5%9B%9E%E7%9A%84%E7%BB%88%E6%AD%A2%E7%8A%B6%E6%80%81%E7%9A%84%E5%AE%8F.png)


函数pr_exit使用上图中中的宏以打印进程终止状态的说明。

head.h
```C++
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
```
wait.c

```C++
#include "head.h"

int main(void){
	pid_t pid;
	int status;
	if((pid=fork()) <0 ){
		printf("fork error\n");
	}
	else if(pid ==0){
		exit(7);   //child
	}
	if(wait(&status) != pid){    //wait for child
		printf("wait error\n");
	}
	pr_exit(status);    //print child status
	
	if((pid=fork()) < 0){
		printf("fork error\n");
	}else if(pid == 0){    //child
		abort();   //generates SIGABRT
	}
	if(wait(&status) != pid){
		printf("wait error\n");
	}
	pr_exit(status);
	
	if((pid=fork())<0){
		printf("fork error\n");
	}
	else if(pid == 0){
		status /= 0;    //divide by 0 generates SIGFPE
	}
	if(wait(&status) != pid){
		printf("wait error\n");
	}
	pr_exit(status);

	exit(0);
}
```

```
[vrlive@iZ23chs2r19Z eight]$ ./wait.o 
normal termination,exit status = 7
abnormal termination,signal number = 6     //SIGABRT的值为6
abnormal termination,signal number = 8     //SIGFPE的值为8
```

### waitpid

```C++
#include <sys/wait.h>
pid_t waitpid(pid_t pid,int *statloc,int options);
//若成功，返回进程ID；若出错，返回0或-1
```

等待一个指定的进程终止，POSIX定义了waitpid函数以提供这种功能（以及其他一些功能）。

对于waitpid函数中pid参数的作用解释如下：

- pid == -1 等待任一子进程。此种情况下，waitpid与wait等效。
- pid>0  等待进程ID与pid相等的子进程。
- pid == 0  等待组ID等于调用进程组ID的任一子进程。
- pid < -1  等待组ID等于pid绝对值的任一子进程。

waitpid函数返回终止子进程的进程ID，并将该子进程的终止状态存放在由statloc指向的存储单元中。对于wait，其唯一的出错是调用进程没有子进程（函数调用被另一个信号中断时，也可能返回另一种出错）。但是对于waitpid，如果指定的进程或进程组不存在，或者参数pid指定的进程不是调用进程的子进程，都可能出错。

options参数使我们能进一步控制waitpid的操作。此参数或者是0，或者是下图中常量按位或运算的结果。

![image](http://ou6yob3zd.bkt.clouddn.com/waitpid%E7%9A%84options%E5%B8%B8%E9%87%8F.png)

**waitpid函数提供了wait函数没有提供的3个功能**：

- waitpid可等待一个特定的进程，而wait则返回任一终止子进程的状态。
- waitpid提供了一个wait的非阻塞版本。有时希望获取一个子进程的状态，但不想阻塞。
- waitpid通过WUNTRACED和WCONTINUED选项支持作业控制。

示例：如果一个进程fork一个子进程，但不要它等待子进程终止，也不希望子进程处于僵死状态直到父进程终止，实现这一要求的诀窍是调用fork两次。

```C++
#include "head.h"

int main(void){
	pid_t pid;
	if((pid=fork()) < 0) {
		printf("fork error\n");
	}else if(pid == 0){    //first child
		if((pid=fork()) <0){
			printf("fork error\n");
		}else if(pid > 0){   //first child,second parent
			exit(0);   //parent from second fork == first child
		}
		// second child
		sleep(2);
		printf("second child,parent pid = %d\n",getppid());
		exit(0);
	}
	// first child parent
	if(waitpid(pid,NULL,0) != pid){   //wait for first child
		printf("waitpid error\n");
	}
	printf("parent process end\n");
	exit(0);
}
```

第二个子进程调用sleep以保证在打印父进程ID时第一个子进程已终止。在fork之后，父进程和子进程都可继续执行，并且我们无法预知哪一个会先执行。在fork之后，如果不使第二个子进程休眠，那么它可能比其父进程先执行，于是它打印的父进程ID将是创建它的父进程，而不是init进程（进程ID为1）。

```
[vrlive@iZ23chs2r19Z eight]$ ./forktwice.o 
parent process end
[vrlive@iZ23chs2r19Z eight]$ second child,parent pid = 1
```


<font color=red> **1.为何要fork()两次来避免产生僵尸进程？** </font>

当我们只fork()一次后，存在父进程和子进程。这时有两种方法来避免产生僵尸进程：

- 父进程调用waitpid()等函数来接收子进程退出状态。
- 父进程先结束，子进程则自动托管到Init进程（pid = 1）。

目前先考虑子进程先于父进程结束的情况：     

若父进程未处理子进程退出状态，在父进程退出前，子进程一直处于僵尸进程状态。
若父进程调用waitpid()（这里使用阻塞调用确保子进程先于父进程结束 ）来等待子进程结束，将会使父进程在调用waitpid()后进入睡眠状态，只有子进程结束父进程的waitpid()才会返回。 如果存在子进程结束，但父进程还未执行到waitpid()的情况，那么这段时期子进程也将处于僵尸进程状态。

由此，可以看出父进程与子进程有父子关系，**除非保证父进程先于子进程结束或者保证父进程在子进程结束前执行waitpid()，子进程均有机会成为僵尸进程**。那么如何使父进程更方便地创建不会成为僵尸进程的子进程呢？这就要用两次fork()了。

父进程一次fork()后产生一个子进程随后立即执行waitpid(子进程pid, NULL, 0)来等待子进程结束，然后子进程fork()后产生孙子进程随后立即exit(0)。这样子进程顺利终止（父进程仅仅给子进程收尸，并不需要子进程的返回值），然后父进程继续执行。这时的孙子进程由于失去了它的父进程（即是父进程的子进程），将被转交给Init进程托管。于是父进程与孙子进程无继承关系了，它们的父进程均为Init，Init进程在其子进程结束时会自动收尸，这样也就不会产生僵尸进程了。

**示例2**

```C++
#include "head.h"

int main(void){
	pid_t pid;
	if((pid=fork()) < 0){
		printf("fork error\n");
	}else if(pid != 0){     //parent
		sleep(2);
		if(waitpid(pid,NULL,0)!=pid){
			printf("waitpid error\n");
		}else{
			printf("waitpid first child  success\n");
		}
		exit(2);
	}
	//first child
	printf("pid = %d,ppid = %d\n",getpid(),getppid());
	
	if((pid=fork()) < 0){
		printf("fork error\n");
	}else if(pid != 0){
		sleep(4);
		if(waitpid(pid,NULL,0)!=pid){
			printf("waitpid error\n");
		}else{
			printf("waitpid second child success\n");
		}
		abort();
	}

	//  seond child
	printf("second child\n");
	
	exit(0);
}
```

```shell
[vrlive@iZ23chs2r19Z eight]$ ./account.o 
pid = 676,ppid = 675
second child
waitpid second child success
waitpid first child  success
```

### waitid

waitid：取得进程终止状态的函数，此函数类似于waitpid，但提供了更多的灵活性。

```C++
#include <sys/wait.h>
int waitid(idtype_t idtype,id_t id,siginfo_t *infop,int options);
//若成功，返回0；失败，返回-1
```

具体介绍参考APUE

### wait3和wait4

wait3和wait4提供的功能比wait、waitpid和waitid所提供功能要多一个，这与附加参数有关，该参数允许内核返回由终止进程及其所有子进程使用的资源概况。

```C++
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/time.h>
#include <sys/resource.h>
pid_t wait3(int *statloc,int options,struct rusage *rusage);
pid_t wait4(pid_t pid,int *statloc,int options,struct rusage *rusage);
//若成功，返回进程ID；若出错，返回-1
```

资源统计信息包括用户CPU时间总量、系统CPU时间总量、缺页次数、接收到信号的次数等。

**相比较于waitid，wait3，wait4，wait和waitpid已经可以满足大多数应用，waitid使用方法与waitpid相似，可以看做是waitpid的增强版。wait3和wait4相比较于wait，waitpid，waitid，增加了获取进程所使用资源的功能**。