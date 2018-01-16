---
title: try语句块和异常处理
date: 2017-10-15 10:59:00
update: 
tags: [异常处理]
categories: C++
comments: true
---
# 一、前言

简单介绍try语句块和异常处理。

<!--more-->

# 异常
异常处理机制为程序中异常检测和异常处理这两部分的协作提供了支持。在C++语言中，异常处理包括：

- **throw表达式**（throw expression），异常检测部分使用throw表达式来表示它遇到的了无法处理的问题，我们说throw引发了异常。
- **try语句块**（try block）,异常处理部分使用try语句处理异常。try语句块以关键字try开始，并以一个或多个catch字句结束。try语句块中代码抛出的异常通常会被某个catch字句处理。因为**catch字句”处理“异常，所以它们也被称作异常处理代码**。
- **一套异常类**（exception class），用于在throw表达式和相关的catch字句之间传递异常具体信息。

## throw表达式

程序的异常检测部分使用throw表达式引发一个异常。throw表达式包含关键字throw和紧随其后的一个表达式，其中表达式的类型就是抛出的异常类型。throw表达式后面通常紧跟一个分号，从而构成一条表达式语句。

## try语句块

```C++
try{
    program-staments
}catch(exception-declaration){
    handler-staments
}catch(exception-declaration){
    handler-staments
} ...
```

**代码示例**
```++
#include <iostream>
#include <string>
#include <vector>
#include <stdexcept>   //标准异常库
using namespace std;
int main()
{
    int a,b;
    cout<<"请输入相除的两个整数：";
    while(cin>>a>>b)
    {
        try
        {
            if (b == 0) throw std::runtime_error("被除数不能为0");//runtime_error异常类:只有在运行时才能检测出的问题
            cout<<static_cast<double>(a)/b<<endl;//考虑到不可以整除产生小数的情况,先将a强制转化为double类型
        }
        catch (runtime_error err)//err是runtime_error类的一个实例
        {
            cout << err.what() ;
            //实例的成员函数，返回内容由编译其决定
            cout << "\n是否需要重新输入? Enter y or n:" << endl;
            char c;
            cin >> c;
            if (!cin || c == 'n')
                break;//break只能用在开关体或者循环体中
        }//简单来说try是检测异常的，如果产生了异常，就throw(抛出)一个异常，然后被catch到，进行异常的处理
        //如果没有catch部分，仅有try，仍然会报错
        cout<<"请输入相除的两个整数：";
    }
    return 0 ;
}
```
输出结果：

    请输入相除的两个整数：2 4
    0.5
    请输入相除的两个整数：2 0
    被除数不能为0
    是否需要重新输入?
    n


简单来说try是检测异常的，如果产生了异常，就throw(抛出)一个异常，然后被catch到，进行异常的处理，如果没有catch部分，仅有try，仍然会报错。