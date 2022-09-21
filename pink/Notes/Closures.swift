//
//  Closures.swift
//  LittlePinkBook
//
//  Created by isdt on 2022/9/16.
//
// https://docs.swift.org/swift-book/LanguageGuide/Closures.html

import UIKit


// MARK: 语法--代码执行块(closure/block)
/*
 
 { (parameters) -> return type in
     statements(程序代码块)
 }
 
 */

// MARK: - 使用场景1 -- 全局函数
//直接调用
let label: UILabel = {
    let label = UILabel()
    label.text = "xxx"
    return label
}()

//先定义,之后调用
let learn = { (lan: String) -> String in
    "学习\(lan)"
}

//和函数的区别
func learn1(_ lan: String) -> String{
    "学习\(lan)"
}

//调用函数
func main(){
    learn("iOS")
    learn1("iOS")
}

// MARK: - 使用场景2 -- 嵌套函数(重要)--作为另外一个函数的参数或返回值
//定义函数codingSwift(),有参数day、appName
func codingSwift(day: Int, appName: () -> String){
    print("学习Swift\(day)天了,写了\(appName())App")
}

/* 传参数 appName 时直接写闭包
codingSwift(day: 40, appName: { () -> String in
    "天气"
})
 */

/* 传参时写已经写好了的闭包'名',用 闭包 定义参数appName
let appName = { () -> String in
    "Todos"
}
codingSwift(day: 60, appName: appName)
*/

/* 传参时写已经写好了的函数名(需参数和返回值的个数和类型完全一样),用 函数 定义参数appName
func appName1() -> String{
    "计算器"
}
codingSwift(day: 100, appName: appName1)
*/
// MARK: - 闭包简写1 -- 尾随闭包 Trailing Closure
/* 简写前
codingSwift(day: 40, appName: { () -> String in
    "天气"
 
 简写后,只能简写最后一个参数
 codingSwift(day: 130) { () -> String in
     "机器学习"
 }
})
 */

// MARK: - 闭包简写2 -- 根据上下文推断类型
func codingSwift(day: Int, appName: String, res: (Int, String) -> String){
    print("学习Swift\(day)天了,\(res(1, "Alamofire")),做成了\(appName)App")
}

/*
 
 原闭包形式:
 codingSwift(day: <#T##Int#>, appName: <#T##String#>) { <#Int#>, <#String#> in
     <#code#>
 }
 
 调用闭包:
 codingSwift(day: 40, appName: "天气") { takeDay, use in
     "花了\(takeDay)天,使用了\(use)技术"        //参数 takeDay为Int类型,use 为String 类型
 }
 
 等同于:
 codingSwift(day: 40, appName: "天气") {
     "花了\($0)天,使用了\($1)技术"              //调用第一个参数,第二个参数
 }
 
 结果:
  学习了40天,花了1天,使用了Alamofire技术,做成了天气App

 */

// MARK: - 系统函数案例 -- sorted
let arr = [3,5,1,2,4]
let sortedArr = arr.sorted(by: <)

/*
 
原函数形式:
try? arr.sorted(by: <#T##(Int, Int) throws -> Bool#>)
 
调用闭包: 从小到大排序
let sortedArr = arr.sorted(by: <)
 
等同于:
let sortedArr = arr.sorted(by: {
    $0 < $1
 })
 
 其他高阶函数,https://juejin.cn/post/6844903856900407304
 
*/

// MARK: - 闭包捕获
func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    /*
     函数形式
    func incrementer() -> Int {
        runningTotal += amount
        return runningTotal
    }
     
     */
    let incrementer = { () -> Int in
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}

//参数 forIncrement 是一个闭包,闭包有算法操作( runningTotal += amount)
let incrementByTen = makeIncrementer(forIncrement: 10)

/*
 每次调用都会在之前保存下来的数据的前提下,继续算法操作
 
 incrementByTen() //10
 incrementByTen() //20
 incrementByTen() //30
 
 */

let incrementBySeven = makeIncrementer(forIncrement: 7)

/*
 每次调用都会在之前保存下来的数据的前提下,继续算法操作
 incrementBySeven 和 incrementByTen 是独立的调用,数据不通用
 
 incrementBySeven() //7
 incrementByTen() //40
 
*/

// MARK: - 闭包是引用类型
let alsoIncrementByTen = incrementByTen

/*
 alsoIncrementByTen 等同于 incrementByTen
 前面多次调用使 incrementByTen 保存下来的数据是40,所以 alsoIncrementByTen() 返回 50
 
 alsoIncrementByTen() //50
 incrementByTen() //60
 
*/

// MARK: - 逃逸闭包(@escaping)
//官方文档--当闭包需要存储在外层函数外面作用域的某个变量里去的时候,必须标记为逃逸闭包
var completionHandlers: [() -> ()] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    //开启某个网络耗时任务(异步),在耗时任务执行完之后需要调用闭包,此处为模拟
    completionHandlers.append(completionHandler)
}


func someFunctionWithNonescapingClosure(closure: () -> Void) {
    closure()
}

class SomeClass {
    var x = 10
    func doSomething() {
        someFunctionWithEscapingClosure { self.x = 100 }        //逃逸闭包, 未使 x 属性赋值
        someFunctionWithNonescapingClosure { x = 200 }          //非逃逸闭包,使 x 属性赋值为 200
    }
}

/*
let instance = SomeClass()
 //因非逃逸闭包未执行完毕,所以逃逸闭包未执行, doSomething() 的外层函数 someFunctionWithNonescapingClosure 执行非逃逸闭包后,使 x 属性赋值为 200
instance.doSomething()
print(instance.x)           //200

completionHandlers.first?()  //逃逸闭包此刻真正被执行,使 x 属性赋值为 100
print(instance.x)      //100,逃逸闭包可以在非逃逸闭包执行后任何时间被执行
 
 */

//耗时任务--异步开启某个(如网络)耗时任务,在耗时任务执行完之后需要调用闭包的时候,这个闭包必须标记为逃逸闭包
class SomeVC{
    func getData(finished: @escaping (String) -> ()){
        print("外层函数开始执行")
        
        //async 异步任务,DispatchQueue 以内(finished())和以外("外层函数开始执行"、"外层函数执行结束")的任务分开执行
        DispatchQueue.global().async {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                finished("我是数据")
            }
        }
        print("外层函数执行结束")
    }
}

/*
 
 调用:
 let someVC = SomeVC()
 // finished 逃逸闭包程序,参数 data为 "我是数据"
 someVC.getData { data in
     print("逃逸闭包执行,拿到了耗时任务过来的数据--\(data),可以做一些其他处理了")
 }
 
 结果:
 外层函数开始执行
 外层函数执行结束
 逃逸闭包执行,拿到了耗时任务过来的数据--我是数据,可以做一些其他处理了       //<我是数据>是逃逸闭包finished的参数
 
 
 */

