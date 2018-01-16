---
title: 数组&指针&string
date: 2017-10-14 12:59:25
update:
tags: [数组,指针]
categories: C++
comments: true
---
# 一、前言

介绍使用数组的基本方法，同时介绍C++中string的初始化和一些常用函数。

<!--more-->

# 数组

数组与vector相似的地方是，数组也是存放类型相同的对象的容器，这些对象本身没有名字需要通过其所在位置访问。与vector不同的是，数组的大小确定不变，不能随意向数组中增加元素。因为数组的大小固定，因此对某些特殊的应用来说程序运行时性能较好，但是相对地也损失了一些灵活性。

**note：** 如果不清楚元素的确切个数，请使用vector。

## 定义和初始化内置数组

数组是一种复合类型，数组中元素的个数也属于数组类型的一部分，编译的时候维度应该是已知的。也就是说，**维度必须是一个常量表达式**。

```C++
unsigned cnt = 42;        //不是常量表达式
constexpr unsigned sz = 42;       //常量表达式
int arr[10];           //含有10个整型的数组
int *parr[sz];          //含有42个整型指针的数组
string bad[cnt];         //错误：cnt不是常量表达式
string strs[get_size()];     //当gett_size是constexpr时正确；否则错误
```
默认情况下，数组的元素被默认初始化。另外数组的元素应为对象，因此不存在引用的数组。

## 显式初始化数组元素

可以对数组的元素进行列表初始化，此时允许忽略数组的纬度。

```C++
const unsigned sz = 3;
int ial[sz] = {0,1,2};      //含有三个元素的数组，元素值分别是０１２
int a2[] = {0 ,1 , 2};      //维度是３的数组
int a3[5] = {0,1,2};        // 等价于{0,1,2,0,0}
string a4[3] = {“hi” , “bye”};  //{“hi”,”bye” ,”“}
int a5[2] = {0,1,2}         //错误，　初始值太多
```

## 字符数组的特殊性（用字符串字面值对数组进行初始化）

字符数组可以用字符串字面值初始化，但是特殊的是结束符（'\0'）也会被拷贝进去
```C++
char a1[] = {‘C’,’+’ ,’+’};       //列表初始化没有空字符
char a2[] = {‘C’,’+’,‘+’,’\0’};    //列表初始化，含有显示的空字符
char a3[] = “C++”;                 //自动添加表示字符串结束的空字符
const char a4[6] =”Daniel”;      //错了，没有空间可以存放空字符
```
a4数组的大小必须至少是7。

## 数组不允许拷贝和赋值

不能将数组的内容拷贝给其他数组作为其初始值，也不能用数组为其他数组赋值：

```C++
int a[] = {0,1,2};
int a2[] = a;         //错误：不允许使用一个数组初始化另一个数组
a2 = a;               //错误：不能把一个数组直接赋值给另一个数组
```

## 理解复杂的数组声明

可以定义一个存放指针的数组。又因为数组本身是对象，所以允许定义数组的指针（指向数组的指针）及数组的引用（对数组的引用）。

```C++
//[]的优先级比*高
int *ptrs[10];                  //ptrs是含有10个整型指针的数组
int (*Parray)[10] = &arr;       //Parray指向一个含有10个整数的数组
int (&arrRef)[10] = arr;        //arrRef引用一个含有10个整数的数组
```

**默认情况下，类型修饰符从右向左一次绑定，** 对于ptrs来说，首先知道我们定义了一个大小为10的数组，它的名字是ptrs，然后知道数组中存放的是指向int的指针。

**要想理解数组声明的含义，最好的办法是从数组的名字开始按照由内向外的顺序阅读。**

Parray的含义：首先*Parray意味着Parray是个指针，接下来观察右边，可知道Parray是个指向大小为10的数组的指针，最后观察左边，知道数组中的元素是int。最终，Parray是一个指针，它指向一个int数组，数组中包含10个元素。

当然，对修饰符的数量并没有特殊限制：

```C++
int *(&array)[10] = ptrs;     //array是数组的引用，该数组含有10个指针
```

## 访问数组元素

数组的元素也能使用范围for语句或下标运算符来访问。

当需要遍历数组的所有元素时，最好的办法也是使用范围for语句。

```C++
for(auto i : scores) {
    cout<<i<<" ";
}
```

##  指针和数组

在C++语言中，指针和数组有非常紧密的联系。使用数组的时候编译器一般会把它转换成指针。

```C++
string nums[] = {"one","two","three"};          //数组的元素是string对象
string *p = &nums[0];                           //p指向nums的第一个元素
```

数组的一个特性：**在很多用到数组名字的地方，编译器都会自动地将其替换为一个指向数组首元素的指针。**

```C++
string *p = nums;       //等价于p2=&nums[0];
```

## auto 和 decltype

```C++
int ia[] = {0,1,2,3,4,5};
auto ia2(ia);       //ia2是一个整型指针，指向ia的第一个元素

decltype(ia) ia3 = {3,4,5,6,7,8};     //ia3类型是由10个整数构成的数组，并对该数组进行赋值
```

## 指针也是迭代器

```C++
int arr[] = {0,1,2,3,4,5,6,7,8,9};
int *p = arr;            //p指向arr的第一个元素
++p;
```

遍历数组元素，我们可以设法获取数组尾元素之后的那个并不存在的元素的地址：

```C++
int *e = &arr[10];       //指向尾元素的下一位置的指针
for(int *b = arr; b!=e; ++b){
    cout<<*b<<end;       //输出arr的元素
}
```

**note:** 尽管能计算得到尾后指针，但是这种用法极易出错，C++11新标准引入了两个名为begin和end的函数。这两个函数与容器中的两个同名成员功能类似。


**begin函数返回指向ia首元素的指针，end函数返回指向ia尾元素下一位置的指针**，这两个函数定义在**iterator**头文件中。

正确的使用形式：
```C++
int ia[] = {1,2,3,4,5};
int *beg = begin(ia);    //指向ia首元素的指针
int *last = end(ia);     //指向arr尾元素的下一位置的指针
for(beg;beg!=last;++beg){
    cout<<*beg<<" ";
}
```

**note:** 一个指针如果指向了某种内置类型数组的尾元素的”下一位置“，则其具备与vector的end()函数返回的与迭代器类似的功能。特别要注意，**尾后指针不能执行解引用和递增操作**。


### 下标和指针

```C++
int ia[] = {0,2,4,6,8};    //含有5个整数的数组
int i = ia[2];        //ia[2]得到(ia+2)所指的元素，即*(ia+2)
int *p = ia;
i = *(p+2);         //等价于i = ia[2];
只要指针指向的是数组中的元素(或者数组中尾元素的下一位置，此时下标需要为负值)，都可以执行下标运算。
int *p = &ia[2];      //p指向索引为2的元素
int j = p[1];         //j = ia[3]
int k = p[-2];        //k = ia[0]
```

**注意：** 内置的下标运算符所用的索引值不是无符号类型，这一点与vector和string不一样。


## C风格字符串

C风格字符串不是一种类型，而是为了表达和使用字符串而形成的一种约定俗成的写法。按此习惯书写的字符串存放在字符数组中并以**空字符结束**（null terminated）。以空字符结束的意思是在字符串最后一个字符后面跟着一个空字符（'\0'）。

**C风格字符字符串函数**

```C++
\\p,p1,p2都是字符数组的形式，在string.h头文件中
strlen(p)         返回p的长度，空字符不计算在内
strcmp(p1,p2)     比较p1和p2的相等。如果p1==p2，返回0；如果p1>p2,返回一个正值；如果p1<p2，返回一个负值
strcat(p1,p2)     将p2附加到p1之后，返回p1
strcpy(p1,p2)     将p2拷贝给p1,返回p1
```

对大多数应用来说，使用标准库string要比使用C风格字符串更安全、更高效。


## 与旧代码的接口

现代的C++ 程序不得不与那些充满了数组或C风格字符串的代码衔接，为了使这一工作简单易行，C++专门提供了一组功能。

## 混用string对象和C风格字符串

允许使用字符串字面值来初始化对象：

```C++
string s("Hello world");      //s的内容是Hello world
```

更一般的情况，**任何出现字符串字面值的地方都可以用以空字符结束的字符数组来替代**：

- 允许使用空字符结束的字符数组来初始化string对象或为string对象赋值。
- 在string对象的加法运算过程中允许使用以空字符串结束的字符数组作为其中一个运算对象（不能两个运算对象都是）；在string对象的复合赋值运算中匀速使用以空字符串结束的字符数组作为右侧的运算对象。


上述性质反过来就不成立，比如不能用string对象直接初始化指向字符的指针。为了完成该功能，string专门提供了一个名为**c_str的成员函数**。

```C++
string s = "wangxinri";
char *p = s ;      //错误，不能用string对象直接初始化指向字符的指针
const char *str = s.c_str();      //正确
```

我们无法保证c_str()返回的数组一直有效，事实上，如果后续的操作改变了s的值就可能让之前返回的数组失去效果。因此使用最好将c_str()返回的数组拷贝一份。

## 使用数组初始化vector对象

不允许使用一个数组为另一个内置类型的数组赋初值，也不允许使用vector对象初始化数组。相反的，允许使用数组来初始化vector对象

```C++
int int_arr[] = {0,1,2,3,4,5};
vector<int> ivec(begin(int_arr),end(int_arr));

//拷贝三个元素：int_arr[1],int_arr[2],int_arr[3]
vector<int> subVec(int_arr+1,int_arr4);
```

**注意：** 现代的C++程序应当尽量使用vector和迭代器，避免使用内置数组和指针；应该尽量使用string，避免使用C风格的基于数组的字符串。


## 多维数组（待补充）

# string

string表示可变长的字符序列，使用string类型必须首先包含string头文件。

## 初始化string对象的方式

```C++
string s1             默认初始化，s1是一个空串
string s2(s1)         s2是s1的副本
string s2 = s1        等价于s2(s1)，s2是s1的副本
string s3("value")    s3是字面值"value"的副本，除了字面值最后的那个空字符外
string s3 = "value"   等价于s3("value")，s3是字面值"value"的副本
string s4(n, 'c')     把s4初始化为由连续n个字符c组成的串
```
## string对象上的操作

```C++
os<<s 	将s写到输出流os当中，返回os
is>>s 	从is中读取字符串赋给s，字符串以空白分隔，返回is
getline(is, s) 	从is中读取一行赋给s，返回is
s.empty() 	s为空赋返回true，否则返回false
s.size() 	返回s中的字符的个数
s[n] 	返回s中第n个字符的引用，位置n从0计起
s1+s2 	返回s1和s2连接后的结果
s1=s2 	用s2的副本代替s1中原来的字符
s1==s2 	如果s1和s2中所含的字符完全一样，则它们相等，返回true
s1!=s2 	如果s1和s2中所含的字符不一样，返回true
<, <=, >, >= 	利用字符在字典中的顺序进行比较，且对字母的大小写敏感
```
## 代码示例

```C++
#include<iostream>
using namespace std;
int main() {
    string str;
    while(cin>>str){   
        cout<<str<<endl;
    }
    return 0;
}

#include<iostream>
using namespace std;
int main() {
    string line;
    while(getline(cin,line)){   
        cout<<line<<endl;
    }
    return 0;
}
```

## 处理string对象中的字符

对字符处理的一些方法，在**cctype**头文件中定义了一组标准库函数处理这部分工作
```C++
isalnmu(c) 	当c是字母或数字为真
isalpha(c) 	当c是字母为真
iscntrl(c) 	当c是控字符时为真
isdigit(c) 	当c是数字为真
isgraph(c) 	当c不是空格但可打印为真
islower(c) 	当c是小写字母为真
isprint(c) 	当c是可打印字符为真(即c是空格或c具有可视形式)
ispunct(c) 	当c是标点符号为真(即c不是控字符、数字、字母、可打印空白中的一种)
isspace(c) 	当c是空白为真(即c是空格、横向制表符、纵向制表符、回车符、换行符、进制符中一种)
issupper(c) 	当c是大写字母为真
isxdigit(c) 	当c是十六进制数字为真
tolower(c) 	若c是大写字母，输出对应小写字母；否则原样输出c
toupper(c) 	若c是小写字母，输出对应大写字母；否则原样输出c
```

## 处理string每个字符，使用基于范围的for语句

```C++
// 用范围for语句和ispunct函数统计string对象中标点符号的个数（使用范围for语句遍历给定序列的每个元素）
#include <iostream>
#include <string>
using namespace std;
int main()
{
string s("Hello World!!!");
decltype(s.size()) punct_cnt = 0;            //punct_cnt的类型同s.size()，即为string :: size_type
for (auto c : s)            // 对于s中的每个字符
      if (ispunct(c))       // 如果该字符是标点符号
           ++ispunct_cnt;  // 计数
cout << punct_cnt << " punctuation characters in " << s << endl;
return 0;
}

// 用范围for语句将字符串改写为大写字母的形式（使用范围for语句改变字符串中的字符）
#include <iostream>
#include <string>
using namespace std;
int main()
{
string s ("Hello World!!!")
// 转换成大写形式
for (auto &c : s)          // 对于s中的每个字符(c是引用)
      c = toupper(c);     // c是一个引用，赋值语句改变了c绑定的字符的值，标准库函数toupper将小写的参数c改为大写
cout << s << endl;
return 0;
} 

```

## 只处理string一部分字符

要想访问string对象总的单个字符有两种方式：一种是使用下标，另外一种是使用迭代器。

**注意：检查下标的合法性**

一种简便易行的方法是：总是设下标的类型为**string::size_type**，因为此类型是无符号数，可以确保下标不会小于0，此时，代码只需要保证下标小于size()的值就可以了。

```C++
const string s = "keep out";
for(auto &c :s){    //C的类型是常量引用，不能通过C修改其绑定的对象
    cout<<c<<endl;
}
```




