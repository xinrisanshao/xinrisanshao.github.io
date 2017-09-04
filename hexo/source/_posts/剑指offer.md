---
title: 牛客网-剑指offer
date: 2017-08-19 9:30:25
update:
tags: [剑指offer,刷题,编程]
categories: 刷题
comments: true
---

# 前言
牛客网剑指offer题目汇总，记录自己刷题历程，原文链接：[点击查看](https://www.nowcoder.com/ta/coding-interviews)
<!--more-->
## 题目一：二维数组中的查找   （数组）

**题目描述:**在一个二维数组中，每一行都按照从左到右递增的顺序排序，每一列都按照从上到下递增的顺序排序。请完成一个函数，输入这样的一个二维数组和一个整数，判断数组中是否含有该整数。

**思路：**矩阵从左到右，从上到下都是有序的，因此，先查找目标数target在二维数组中的哪一行，通过判断是否在该行的第一个数和最后一个数之间，如果是，则定位到了行，因为该行是有序的，所以接下来通过二分查找，即可查找成功。

**注：**时间复杂度的话，查找行花了O(n), 二分查找O(logn),总共应该O(n)+O(logn),奇怪的是我使用普通的遍历查找，运行时间更更少！这不科学，二分查找效率应该更高，这应该是数据量小导致的。

**代码：**

```java
public class Solution {
    public boolean Find(int target, int [][] array) {
        if(array[0].length==0) { //[[]]的情况
            return false;
        }   //判断二维数组是否为空
        for(int i=0;i<array.length;i++) {
            // 找出target所在二维数组的行
            if(target>=array[i][0]&&target<=array[i][array[i].length-1]) {
                //找到所在行之后，因为该行是有序的，此时使用二分查找即可
                int low = 0;
                int high = array[i].length-1;
                int mid;
                while(low<=high) {
                    mid = (high + low)/2;
                    if(array[i][mid]>target) {
                        high = mid - 1;
                    }else if(array[i][mid]<target){
                        low = mid + 1;
                    }else {
                        return true;
                    }
                }
            }
        }
        return false;
    }
}
```

## 题目二：替换空格  （字符串）

**题目描述:**请实现一个函数，将一个字符串中的空格替换成“%20”。例如，当字符串为We Are Happy.则经过替换之后的字符串为We%20Are%20Happy。

**思路：**

**第一种：** 直接用StringBuffer提供的replace函数。(不可取，得自己搞)

```java
replace(int start, int end, String str);
```

Replaces the characters in a substring of this sequence with characters in the specified String.

**第二种：** 先统计出空格的个数，然后计算得到替换后的字符串的长度，然后重新更新字符串的长度，此时，**从后向前**遍历字符串，如果是空格，替换，如果不是空格，赋原值，知道遍历结束。

**注：**从后往前，每个空格后面的字符只需要移动一次。从前往后，当遇到第一个空格时，要移动第一个空格后所有的字符一次；当遇到第二个空格时，要移动第二个空格后所有的字符一次；以此类推。所以总的移动次数会更多。

**代码：**

```java
public class Solution {
    public String replaceSpace(StringBuffer str) {
        int oldlength = str.length()-1;
        int newlength = oldlength;  //替换之后新数组的大小
        for(int i=0;i<str.length();i++) {
            if(str.charAt(i)==' '){
                newlength += 2;   //由一个' '变为"%20",长度增加2
            }
        }
        str.setLength(newlength+1);  //扩展str的长度,多余的位置是空字符
        //此时oldlength和newlength都是数组的长度-1
        for(;oldlength>=0&&oldlength<newlength;oldlength--){
            if(str.charAt(oldlength)==' '){
                str.setCharAt(newlength--, '0');
                str.setCharAt(newlength--, '2');
                str.setCharAt(newlength--, '%');
            }else{
                str.setCharAt(newlength--, str.charAt(oldlength));
            }
        }
        return str.toString();
    }
}
```
## 题目三：从尾到头打印链表 （链表）

**题目描述:**输入一个链表，从尾到头打印链表每个节点的值。

**思路：**

**第一种：** 遍历链表，将链表存入Arraylist数组vals中，然后对vals进行反转。(确实很low)

**第二种：** 使用递归思想，递归到最后一个结点，然后层层返回，此时依次add进vals数组中。

**代码：**

```java
/**
*    public class ListNode {
*        int val;
*        ListNode next = null;
*
*        ListNode(int val) {
*            this.val = val;
*        }
*    }
*
*/
import java.util.ArrayList;
public class Solution {
    public ArrayList<Integer> printListFromTailToHead(ListNode listNode) {
        ArrayList<Integer> vals = new ArrayList<>();
        int count=0;
        while(listNode != null) {
            vals.add(listNode.val);
            listNode = listNode.next;
            count++;
        }
        for(int i=0;i<count/2;i++) {
            int tem = vals.get(i);
            vals.set(i, vals.get(count-i-1));
            vals.set(count-i-1, tem);
        }
        return vals;  
    }
}
```

```java
public class linklist{
    public static ArrayList<Integer> vals = new ArrayList<>();
    public static void printListFromTailToHead(ListNode listNode) {
        if(listNode != null) {
            printListFromTailToHead(listNode.next);
    	    vals.add(listNode.val);
        }
    }
    //return val; 返回val不需要，因为vals本身就相当于全局变量一样，每次迭代更新的都是同一个vals。
}
```

![](http://ou6yob3zd.bkt.clouddn.com/20170819204904.png)

## 题目四：重建二叉树 （树）

## 题目五：用两个栈实现队列 （栈、队列）

**题目描述:**用两个栈来实现一个队列，完成队列的Push和Pop操作。 队列中的元素为int类型。

**思路：**
 
入队push:将元素进栈A。

出队pop:判断栈B是否为空，如果为空，则将栈A中所有元素pop，并push进栈B，然后栈B出站。

**注：** 1 push，将数据直接压入stack1即可；2 pop,将stack1中的数据弹出压入到stack2中，则数据顺序相反，为保证最新进入的数据一致处于栈顶，只有将stack2中的数据全部pop后，才能继续将stack1中的数据压入到stack2中，继续做pop。

**代码：**

```java
public class Solution {
    Stack<Integer> stack1 = new Stack<Integer>();
    Stack<Integer> stack2 = new Stack<Integer>();
     
    public void push(int node) {
        stack1.push(node);
    }
     
    public int pop() {
        while(stack1.empty()&&stack2.empty()){
            System.out.println("队列为空!");
        }
        if(stack2.empty()){
            while(!stack1.empty()){
                stack2.push(stack1.pop());
            }
        }
        return stack2.pop();
    }
}
```
## 题目十一：二进制中1的个数 （位运算）
**题目描述:**输入一个整数，输出该数二进制表示中1的个数。其中负数用补码表示。

**思路：**

**方法一：** 通过n&n-1可以消除整数最右边的1。多次执行n=n&n-1，最终n为0时，表示所有的1都被消除了，消除1所执行的次数即为1的个数。

**分析：**为啥n&n-1可以消除整数最右边的1？ 如果一个整数不为0，那么这个整数至少有一位是1。如果我们把这个整数减1，那么原来处在整数最右边的1就会变成0，原来在最右边1后面的所有的0都会变成1（如果最右边的1后面还有0的话）。其余所有位将不会受到影响。我们发现减1的结果是把从最右边的1开始的所有位都取反了，这个时候将n于n-1做与运算，从原来整数最右边一个1那一位开始所有位都会变成0。也就是说，把一个整数减去1，再和原整数做与运算，会把该整数最右边一个1变为0，那么一个整数的二进制有多少个1，就可以进行多少次这样的操作。

    n=12          1100 
    n-1=11        1011
    n=12&11       1000
    n=8           1000
    n-1=7         0111
    n=8&7         0000

**代码：**
```java
public int NumberOf1(int n) {  
    int count = 0;
    while(n!=0){
        n &= n-1;
        count++;
    }
    return count;
}
```

更多参考点击：[算法-求二进制数中1的个数](http://www.cnblogs.com/graphics/archive/2010/06/21/1752421.html)

## 题目十二：数值的整数次方 （代码的完整性）
**题目：**给定一个double类型的浮点数base和int类型的整数exponent。求base的exponent次方。

**思路：**

**方法一：**估计是个人都能想出来，假设要求a^b，只需将a连乘b次，此时的时间复杂度是O(b)。

**方法二：** **快速幂**，快速幂能将复杂度降至O(logb)，确实是快了不少。

原理：假设我们要求a^b，b拆成二进制时，该二进制数第i位的权值为2^(i-1)，如下：

a^11 = a^(1011) = a^(1000+0010+0001) = a^(2^0 + 2^1 + 2^3) = a^(2^0)\*a^(2^1)\*a^(2^3)

通过使用&和>>位运算操作，依次遍历指数二进制表示中的每一位，我们发现，结果为每一位值为1时，也即a^(2^i)的累乘，此时，相邻位的值都是前一个值的翻倍。

更多信息：[快速幂](http://www.cnblogs.com/CXCXCXC/p/4641812.html)

**代码：**
```java
public class Solution {
    public double Power(double base, int exponent) {
        double result = 1.0;
        int e = exponent;
        exponent = Math.abs(exponent);
        if(exponent == 0){
            return result;
        }
        while(exponent!=0){
            if((exponent&1)==1){
                result *= base;
            }
            base *= base;    //每移动一位，该为代表的乘数都翻倍
            exponent = exponent >> 1;  //右移一位
        }
        return e>0?result:1/result;    
    }
}
```


## 题目十三：调整数组顺序使奇数位于偶数前面 （数组）
**题目描述:**输入一个整数数组，实现一个函数来调整该数组中数字的顺序，使得所有的奇数位于数组的前半部分，所有的偶数位于位于数组的后半部分，并保证奇数和奇数，偶数和偶数之间的相对位置不变。

**思路：**

**方法一：** 插入排序的思想。从第二个数开始，之前的数（也就只有一个数）是已经排好序的，此时如果第二个数是奇数的话，我们只需要插入到之前序列中所有偶数之前，如果是偶数的话，则不需要插入；继续第三个数，依次遍历完数组即可。

**方法二：**重新定义一个vector，从前往后遍历vector,遇到奇数push_back；再遍历一遍vector，遇到偶数push_back,以空间换时间，这就不实现了，easy。

**代码：**
```java
public class Solution {
    public void reOrderArray(int [] array) {
        for(int i=1;i<array.length;i++){
    	    if(array[i]%2==0){  //偶数的话，继续下一个数
                continue;
    	    }else{   
                int tem = array[i];  //保存待插入到偶数之前的奇数
                int j;
                for(j=i-1;j>=0&&(array[j]%2==0);j--){  //找到偶数之前插入的位置
                    array[j+1] = array[j];  //偶数集体后移一位
                }
                array[j+1] = tem;  //将奇数插入到该位置上
            }
    	}      
    }
}
```

## 题目十四：链表中倒数第k个结点
**题目描述:**输入一个链表，输出该链表中倒数第k个结点。

**思路：** 定义两个指针p1,p2，分别指向表头，再定义count=0,表示p1在第0个结点，此时p1开始遍历链表，每经过一个结点count++，当count>=k时，p2开始遍历链表，直到p1遍历结束，此时p2指向的结点即为倒数第k个结点。

**代码：**
```java
/*
public class ListNode {
    int val;
    ListNode next = null;
 
    ListNode(int val) {
        this.val = val;
    }
}*/
public class Solution {
    public ListNode FindKthToTail(ListNode head,int k) {
        int count = 0;
        ListNode p = head;
        ListNode node = null;  //head为空，返回null
        if(k<=0) return node;  //k<=0无效，返回null
        while(head!=null){
            count++;
            head = head.next;
            if(count >= k) {  //相对第一个元素为k-1的间隔时,head和p同时往后走
                node = p;
                p = p.next;
            }
        }
        return node;
    }
}
```

## 题目十五：反转链表
**题目描述:**输入一个链表，反转链表后，输出链表的所有元素。

**思路：** 依次遍历每个结点，同时通过头插法再重新创建新的链表

**注：**可以利用之前的结点，而不需要重新创建新的结点，以后改进。

**代码：**
```java
/*
public class ListNode {
    int val;
    ListNode next = null;
 
    ListNode(int val) {
        this.val = val;
    }
}*/
public class Solution {
    public ListNode ReverseList(ListNode head) {
        ListNode p = null;
        if(head == null) {
            return p;
        }else{
            p = new ListNode(head.val);
        }
        ListNode q = head.next;
        while(q!=null){
            ListNode s = new ListNode(q.val);
            s.next = p;
            p = s;
            q = q.next;
        }
        return p;
    }
}
```


## 题目十六：合并两个排序的链表
**题目描述:**输入两个单调递增的链表，输出两个链表合成后的链表，当然我们需要合成后的链表满足单调不减规则。

**思路：** 当两个链表list1，list2（指向第一个结点）不空时，比较list1.val和list2.val的值，较小的作为合并后的第一个结点，假设list1.val较小，此时list1 = list1.next，继续比较list1.val和list2.val，直到某一个链表遍历结束，将没遍历结束的链表添加到合并后链表末尾。

**注：**可以利用之前的结点，而不需要重新创建新的结点，这样，最后直接指向没遍历结束的链表即可，同时也节省了创建新的结点的空间，后续改进。

**代码：**

```java
/*
public class ListNode {
    int val;
    ListNode next = null;
 
    ListNode(int val) {
        this.val = val;
    }
}*/
public class Solution {
    public ListNode Merge(ListNode list1,ListNode list2) {
        ListNode p = new ListNode(0);  //创建一个头结点,数据域初始化为0，不存储数据,指针域为null
        ListNode head = p ;  //头指针,指向头结点
        if(list1 == null && list2 == null) return null;
        while(list1!=null && list2!=null){
            if(list1.val < list2.val){
                ListNode s = new ListNode(list1.val);
                p.next = s;
                p = s;
                list1 = list1.next;
                 
            }else {
                ListNode s = new ListNode(list2.val);
                p.next = s;
                p = s;
                list2 = list2.next;
            }
        }
        while(list1!=null){
            ListNode s = new ListNode(list1.val);
            p.next = s;
            p = s;
            list1 = list1.next;
        }
        while(list2!=null){
            ListNode s = new ListNode(list2.val);
            p.next = s;
            p = s;
            list2 = list2.next;
        }
        return head.next;  //头结点不存储元素,head.next指向第一个元素节点，返回 
    }
}
```