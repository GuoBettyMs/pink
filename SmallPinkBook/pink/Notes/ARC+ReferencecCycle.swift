//
//  ARC+ReferencecCycle.swift
//  LittlePinkBook
//
//  Created by isdt on 2022/9/16.
//  https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html
//

import UIKit
// MARK: - ARC(Automatic Reference Counting)-自动引用计数
/*
是iOS的内存管理机制,只适用引用类型数据,如 Class、函数、闭包
所以当调用 dismiss 时,ARC 会自动销毁不需要的代码,不需要手动 deinit
 
 */

// MARK: - ARC 缺点:导致内存泄露(memory leak)
//引用类型数据容易造成不好的现象:Reference Cycle/Retain Cycles-循环引用,从而导致内存泄露(memory leak)
/*

class Author{
    var name: String
    var video: Video?
    init(name: String) {
        self.name = name
    }
    deinit {
        print("author对象被销毁了")
    }
}


class Video{
    var author: Author
    init(author: Author) {
        self.author = author
    }
    deinit {
        print("video对象被销毁了")
    }
}

 // Author、Video 循环引用
 var author: Author? = Author(name: "Lebus")
 var video: Video? = Video(author: author!)     //变量author 赋值给Video里的author
 author?.video = video                          //变量video 赋值给Author里的video

 author = nil       //变量 author销毁,但 Video里的author 未被销毁
 video = nil        //变量 video销毁,但 Author里的video 未被销毁
 
 结果:
 未打印出任何东西,说明Author、Video 未被销毁干净,导致内存泄露
 
 */

//解决方法: weak(弱引用)和unowned(无主引用)--只要其中一个就行
class Author{
    var name: String
    weak var video: Video?          //添加 weak(弱引用),修饰可选类型
    init(name: String) {
        self.name = name
    }
    deinit {
        print("author对象被销毁了")
    }
}


class Video{
    unowned var author: Author      //添加 unowned(无主引用),修饰非可选类型
    init(author: Author) {
        self.author = author
    }
    deinit {
        print("video对象被销毁了")
    }
}

/*
 调用:
 
 var author: Author? = Author(name: "Lebus")
 var video: Video? = Video(author: author!)
 author?.video = video

 author = nil
 video = nil
 
 结果:
 author对象被销毁了
 video对象被销毁了
 
 */

// MARK: - delegate等属性被标记为weak的原因,也需防止滥用
class vc: UIViewController, UITableViewDelegate{
    var tableView: UITableView!
    override func viewDidLoad() {
        tableView.delegate = self
    }
}
/*
当页面不加载后,UIViewController、 UITableViewDelegate 还在循环引用
因此 delegate 需被标记为weak, 防止滥用
 */

// MARK: - 捕获列表CaptureList -- 闭包循环引用的解决方案
//1.全局函数闭包
class HTMLElement {

    let name: String
    let text: String?

    lazy var asHTML: () -> String = {
        [unowned self] in               //若捕获的值可能为nil, 选用[weak self]
        if let text = self.text {       //使用闭包的属性时,属性前面都标上 self
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }

    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }

    deinit {
        print("\(name) is being deinitialized")
    }

}

/*
 var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
 print(paragraph!.asHTML()) // Prints "<p>hello, world</p>"
 paragraph = nil
 
 */

//2.逃逸闭包--见didFinishPicking(TabBarC.swift - 104)

