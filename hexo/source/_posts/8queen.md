---
title: 8皇后问题
date: 2018-04-20 21:59:00
update: 
tags: [编程]
categories: 算法
comments: true
---

# 八皇后问题

在8*8的国际象棋上摆放8个皇后，使其不能相互攻击，即任意两个皇后不得处在同一行、同一列或者同一条对角线上。请问总共有多少种符合条件的摆法？ 

<!--more-->

## 思路

剑指offer上的方法，通过排列组合求出所有不在同一行、同一列的组合，然后剔除在同一对角线的组合，即为最终结果

定义一个数组ivec[8]，数组中第i个数字表示位于第i行的皇后的列号，先把数组ivec中的8个数字分别用0-7初始化，然后对数组ivec进行全排列，因为我们用不同的数字初始化数组，所以任意两个皇后肯定不同列。接下来只需要判断每一个排列对应的8个皇后是不是在同一条对角线上，也就是对于数组的两个下标i,j，如果存在 (abs(i-j)) == (abs(ivec[i]-ivec[j]))，则剔除。否则为其中一种摆法。

## 代码

```C++
#include <iostream>
#include <vector>
using namespace std;

/*问题描述:在8*8的国际象棋上排放8个皇后，使其不能相互攻击，
即任意两个皇后不得处在同一行、同一列或者同一条对角线上。*/

void helper(vector<int> &ivec,int start,vector<vector<int>> &allVec){
    if(start == (ivec.size()-1)) allVec.push_back(ivec);
    for(int i=start;i<ivec.size();++i){
        swap(ivec[i],ivec[start]);
        helper(ivec,start+1,allVec);
        swap(ivec[i],ivec[start]);
    }
}

void Permutation(vector<int> &ivec,vector<vector<int>> &allVec){
    helper(ivec,0,allVec);
}

int main()
{
    vector<int> ivec{0,1,2,3,4,5,6,7};
    //先求所有皇后可能出现的列的组合，排列组合问题
    vector<vector<int>> allVec;
    Permutation(ivec,allVec);
    //此时保证皇后都是不同行，不同列的情况，接着剔除同一对角线的
    // abs(i-j) == abs(vec[i]-vec[j])，处于同一对角线，删除
    vector<vector<int>> resVec;
    for(auto iter=allVec.begin();iter!=allVec.end();++iter){
        bool flag = true;
        for(int i=0;i<8;++i){
            bool flag2 = true;
            for(int j=0;j<8;++j){
                if(i!=j){
                    if( (abs(i-j)) == ( abs((*iter)[i]-(*iter)[j]) ) ){  //剔除
                        flag = false;
                        flag2 = false;
                        break;
                    }
                }
            }
            if(!flag2) break;
        }
        if(flag) resVec.push_back(*iter);
    }
    cout<<"解法共有："<<resVec.size()<<endl;
    int i = 1;
    for(auto vec : resVec){
        cout<<"解法"<<i<<": ";
        for(auto ele : vec) cout<<ele<<" ";
        cout<<endl;
        ++i;
    }
    return 0;
}
```

## 结果

解法共有92种，时间复杂度为 8！*  ((8 * 7)/2)。8！为排列组合需要的时间复杂度，(8 * 7)/2 为剔除每一个排列组合需要的时间复杂度。

