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