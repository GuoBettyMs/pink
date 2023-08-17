//
//  Valuetypes+Referencetypes.swift
//  LittlePinkBook
//
//  Created by isdt on 2022/9/16.
//

import UIKit

//内存的两个分块: 1.栈-stack; 2.堆-heap
//指针(pointer) = 内存地址

// MARK: - 值类型 Valuetypes

/*
 栈-stack, 无法节省内存, 内存地址不同
 存储的是值类型数据,如 Struct(Int、Double、Float、String、Array、Dictionary、Set)、enum、tuple
 赋值为深拷贝(Deep Copy)，即新对象和源对象是独立的，当改变新对象的属性，源对象不会受到影响，反之同理。
 
 */
struct PersonS{
    var name = "小王"
    var age = 20
}

/*
 
 let p1 = PersonS()
 var p2 = p1            //值类型变量,新对象和源对象是独立的,只能 var
 p2.age = 30
 p1.age      //20
 
 */



// MARK: - 引用类型 Referencetypes
/*
 堆-heap, 可节省内存,内存地址相同
 存储的是引用类型数据,如 Class、函数、闭包
 赋值是浅拷贝(Shallow Copy)，即新对象和源对象的变量名不同，但其引用（指向的内存空间）是一样的，因此当使用新对象操作其内部数据时，源对象的内部数据也会受到影响。
 
 */
class PersonC{
    var name = "小王"
    var age = 20
}

/*
 
 let p3 = PersonC()
 let p4 = p3            //引用类型变量,引用（指向的内存空间）是一样的, 可用 let
 p4.age = 30
 p3.age      //30

 */
