---
title: Bitmap简单实现
date: 2018-04-8 21:59:00
update: 
tags: [算法]
categories: 数据结构
comments: true
---

# BitMap算法

Bit-map就是用一个bit位来标记某个元素对应的Value， 而Key即是该元素。由于采用了bit为单位来存储数据，因此在存储空间方面，可以大大节省。

<!--more-->

我们知道，一般可以直接操控的最小的单位是字节，比如在C/C++中，定义一个类型char，对它进行各种操作。然后很多时候，面对一个很大数据量，且我们仅仅希望知道某个数是否存在，我们不妨可以（**有时候是必须**）使用Bitmap算法来完成相关操作。比如腾讯的下面这道题：

## 示例

在40亿个没有排序的无符号整数中，我们如何快速判断某个无符号整数是否在这40亿个数中？

40亿，这是一个很大的数字，就是海量数据的处理，所以我们必须要考虑到内存的问题。我们知道一个无符号整数的大小为4个字节，那么40亿个需要占多少的内存？4*40亿是多大量级？咋一看有点难算，不过我们可以估算一下。 
1KB=1024B 
1MB=1024KB 
1GB=1024MB 
我们近似估计一下，1GB≈1000 * 1000 * 1000B= 1 000 000 000B = 10亿B，因此40亿*4B / 10亿B = 16G。就是说需要占据大概16GB的内存，这显然对于一般的电脑是不行的。

如果我们可以使用位图来存，一整型占4字节32比特位，因此如果用一个bit来存的话，在上面的例子中仅仅需要16G/32=0.5G大概就是500MB的内存。

题目要求我们快速判断，最快的算法当然是O（1）的操作，我们可以开一个无符号整型最大值的空间（保证这42亿个数都在这个范围内），每个数映射一个bit位，如果存在就将该bit位置1，不然就置0。因此想要查找某个数只需要开他映射的那个比特位是0还是1就可以了。

比如我们想要在这些数中查找一个33。

首先我们要开辟一块size_t（无符号整型）的空间，我们不妨使用整形数组arr来存。 其中每个元素都是size_t占4个字节32位.

刚开始每个空格全是0，这时候我们存一个33，arr[0]对应着0-31的比特位，arr[1]对应着32-63的比特位，因此33就在arr[1]第二个比特位。。。我们只需要将这个比特位置1就好了，到时候查找也是这个位是否为1。

bitmap表为：

arr[0] ——> 0 - 31

arr[1] ——> 32 - 63

arr[2] ——> 64 - 95

arr[3] ——> 96 - 127

结论：**对于任意一个数x，x / 32对应着它在vector的第几个位置，x % 32对应它的比特位。**

## 简单实现

```C++
#include <iostream>
using namespace std;

const int N = 100;   //数组容量为100
int arr[N] = {0};

void setNumber(int num){   //设置num所在位标志为1
    int index = num/32;  //所在数组的对应下标
    int pos = num%32;    //对应下标具体的位置
    arr[index] |= (1<<pos);
}

bool hasExisted(int num){  //checknum是否存在
    int index = num/32;
    int pos = num%32;
    if((arr[index]&(1<<pos))!=0) return true;
    return false;
}

int main()
{
    setNumber(10);
    setNumber(50);
    if(hasExisted(10)) cout<<"10 is existed"<<endl;
    if(hasExisted(20)) cout<<"20 is existed"<<endl;
    else cout<<"20 is not existed"<<endl;
    if(hasExisted(50)) cout<<"50 is existed"<<endl;
    return 0;
}
```






