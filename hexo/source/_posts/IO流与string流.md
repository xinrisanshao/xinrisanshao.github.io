---
title: I/O流与string流
date: 2017-10-23 21:59:00
update: 
tags: [I/O流,string流]
categories: C++
comments: true
---
# 一、前言
介绍I/O流和string流及其基本使用。
<!--more-->

# IO类

## IO对象无拷贝或赋值

由于不能拷贝IO对象，因此我们也不能将形参或返回类型设置为流类型。进行IO操作的函数通常以引用方式传递和返回流。读写一个IO对象会改变其状态，因此传递和返回的引用不能是const的。

## 条件状态

```C++
#include <iostream>
using namespace std;
istream& func(istream &is)
{
    string buf;
    while (is >> buf)
        cout << buf << endl;
    is.clear();   //将流的状态设置为有效
    return is;
}
int main()
{
    istream& is = func(std::cin);
    cout << is.rdstate() << std::endl;
    cout<<"hi!"<<endl;   //输出hi和一个换行，然后刷新缓冲区
    cout<<"hi!"<<flush;  //输出hi，然后刷新缓冲区，不附加任何额外的字符串
    cout<<"hi!"<<ends;   //输出hi和一个空字符，然后刷新缓冲区
    return 0;
}
```

## 文件输入输出

头文件**fstream**定义了三个类型来支持文件IO：**ifstream**从给定文件读取数据，**ofstream**向一个给定文件写入数据，以及**fstream**可以读写文件。

这些类型提供的操作与我们之前已经使用过的对象cin和cout的操作一样，特别是，我们可以用IO运算符（<<和>>）来读写文件，可以用getline从一个ifstream读取数据。

**代码示例：**
```C++
#include <iostream>
#include <fstream>
#include <vector>
#include <string>
using namespace std;
void readfile(string filename,vector<string>& svec){   //从文件中读取数据到svec中
    ifstream input;   //从一个给定文件读取数据
    input.open(filename);
    if(input){
        /*
        string line;
        while(getline(input,line)){   //按行读取文件，input当成输入流cin处理就行
            svec.push_back(line);
        }*/
        string word;
        while(input>>word){   //按单词读取文件，input当成输入流cin处理就行
            svec.push_back(word);
        }

    }else{
        cout<<"couldn't open: " + filename<<endl;
    }
    input.close();
}

void writefile(string filename,const vector<string>& svec){   //从文件中读取数据到svec中
    ofstream out;  //ofstream向一个给定文件写入数据
    out.open(filename,ofstream::app);  //不清空文件，末尾追加写入
    if(out){
       for(auto word : svec){
           out<<word<<endl;   //输出流，也就将word写入到文件中
       }
    }else{
        cout<<"couldn't open: " + filename<<endl;
    }
    out.close();
}
int main()
{
    string filename = "STRING.txt";
    vector<string> svec;
    readfile(filename,svec);
    for(auto line : svec){
        cout<<line<<endl;
    }
    //从svec写入数据到文件中
    filename = "WRITE.txt";
    writefile(filename,svec);
    return 0;
}
```

## 文件模式

每个流都有一个关联的文件模式（mode），用来指出如何使用文件。具体的mode有哪些呢？
```C++
in       以读方式打开
out      以写方式打开
app      每次写操作前均定位到文件末尾（从文件尾开始写，不覆盖前面写的）
ate      打开文件后立即定位到文件末尾
trunc     截断文件
binary    以二进制方式进行IO
```


不管用哪种方式打开文件，我们都可以指定文件模式，调用open显式打开或者用一个文件名初始化文件流来隐式打开文件都可指定文件模式。
但是上述模式间有限制关系：

- 只可以对ifstream和ifstream对象设定in模式
- 只可以对ofstream和fstream对象设定out模式
- 只有当out被设定时才能设定trunc模式
- 只要trunc没被设定，就可以设定app模式。在app模式下，即使没有显式指定out模式，文件也总是以输出方式打开
- 默认情况下，即使我们没有指定trunc模式，以out模式打开的文件也会被截断。为了保留以out模式打开的文件内容，我们必须同时指定app模式，这样只会将数据追加写到文件末尾；或者同时指定in模式，即打开文件同时进行读写操作。


每个文件流类型都定义了一个默认的文件模式，当我们未指定文件模式时，就使用此默认模式。**与ifstream关联的文件默认以in模式打开，与ofstream关联的文件默认以out模式打开，与fstream关联的文件默认以in和out模式打开。**

 
此外，有两点需要特别注意：

**1：以out模式打开文件会丢弃已有数据**

默认情况下，当我们打开一个ofstream时，文件的内容会被丢弃。阻止清空文件的方法是同时指定app模式。

```C++
// 这三条语句中，file都将被截断
ofstream out("file");     // 隐含以输出模式打开文件并截断文件
ofstream out("file",ofstream::out);   // 隐含地截断文件
ofstream out("file",ofstream::out|ofstream::trunc); 
//这两条语句中，文件内容将被保存
ofstream out("file",ofstream::app);     //隐含为输出模式
ofstream app("file",ofstream::out|ofstream::app);
```
 
**小结：保留被ofstream打开的文件中内容的唯一方法是显示指定app或in模式。**

**2 ：每次调用open时都会确定文件模式**

对于一个给个流，每当打开文件时，都可以改变其文件模式。

```C++
ofstream  out;         // 未指定文件打开模式
out.open("file");      // 隐含设置为输出和截断
out.close();          // 与out绑定的名为file的文件被关闭，以便我们将对象out用于其他文件
out.open("preFile",ofstream::app);      //模式为输出和文件尾追加
out.close();
```

名为file的文件内容将被清空，名为preFile的文件中已有的数据将都被保存。

**小结：每次打开文件时，都要设置文件模式，可以是显式的设置，也可以是隐式的设置。当文件未指定模式时，都是使用默认值。**  


# String流

sstream头文件定义了三个类型来支持内存IO，这些类型可以向string写入数据，从string读取数据，就像string是一个IO流一样。

**istringstream从string读取数据，ostreamstream向string写入数据，而头文件stringstream既可以读数据也可向string写数据。**

头文件sstream中定义的类型都继承自我们已经使用过的iostream头文件中定义的类型。除了继承得来的操作，sstream中定义的类型还增加了一些成员来管理与流相关联的string。

```C++
stringstream特有的操作
sstream strm； strm是一个未绑定的stringstream对象。sstream是头文件sstream中定义的一个类型
sstream strm(s); strm是一个sstream对象，保存strings的一个拷贝。此构造函数是explicit的
strm.str（） 返回strm所保存的string类型
strm.str(s) 将string的s拷贝到strm中，返回void
```

## 使用istringstream

当我们的某些工作是对整行文本进行处理，而其他一些工作是处理行内的某个单词时，通常可以使用istringstream。

考虑如下文件，列出了一些人和他们的电话号码（电话号码多选）
```
morgan 20155555 685522
drew 5524566
lee 425422 542122 55444222
```
我们定义一个简单的类来描述输入数据：

```C++
struct PersonInfo{
    string name;
    vector<string> phones;
}
```
我们从文本中读入输入数据，并将输入数据写入到vector<PersonInfo>容器中：

以下是完整代码：

```C++
#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include <sstream>
using namespace std;
//成员默认公有
struct PersonInfo{
    string name;
    vector<string> phones;
};
int main()
{
    string filename = "Info.txt";
    ifstream input;   //从文件中读取数据
    vector<PersonInfo> Pvec;
    input.open(filename);
    if(input){
        string line;
        string phone;
        while(getline(input,line)){
            PersonInfo info;
            istringstream record(line);   //将记录绑定到刚读入的行
            record>>info.name;     //读取名字
            while(record>>phone){  //读取电话号码
                info.phones.push_back(phone);
            }
            Pvec.push_back(info);   //将记录追加到people末尾
        }
    }else{
        cout<<"couldn't not open file"<<endl;
    }
    input.close();
    for(auto people : Pvec){   //输出
        cout<<people.name;
        for(auto phone : people.phones){
            cout<<" "<<phone;
        }
        cout<<endl;
    }
    return 0;
}
```

## 使用ostringstream
**
当我们逐步构造输出，希望最后一起打印是，ostringstream是很有用的。**

```C++
ostringstream badNums;
string num = "123";
string name = "xin";
badNums<<num<<name;     //将数的字符串的形式存入badNums
cout<<badNums.str()<<endl;    //输出123xin
```

**输出badNums.str()!**






















