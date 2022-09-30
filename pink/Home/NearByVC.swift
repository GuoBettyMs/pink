//
//  NearByVC.swift
//  LittlePinkBook
//
//  Created by isdt on 2022/9/15.
//
/*
    视图控制器 HomeVC buttonBarView 的“附近”子视图控制器
 
 */
import UIKit
import XLPagerTabStrip

class NearByVC: UIViewController, IndicatorInfoProvider {

    // MARK: - GCD(Grand Central Dispatch)-多线程执行任务的解决方案
    
    //任务(执行的代码)
    //1.同步执行任务(sync)-不具备开启多线程的能力
    //2.异步执行任务(async)-具备开启多线程的能力
    
    //队列(排队等待处理的任务)-FIFO(先进先出)-先排队的人先受理
    //1.串行队列(Serial Dispatch Queue)-顺次执行队列中的任务
    //2.并发队列(Concurrent Dispatch Queue)-同时执行队列中的任务
    
    //以10辆汽车在公路上行驶举例:
    //每辆汽车代表一个任务,排队等候的汽车代表队列,公路代表线程;汽车从公路上通过代表任务执行.
    //1.串行队列同步执行:10辆汽车排成一支长队,只有一条公路,故只能顺次通过
    //2.串行队列异步执行:10辆汽车排成一支长队,有好几条公路,只能选其中一条顺次通过
    //3.并发队列同步执行:10辆汽车排成多支队伍,只有一条公路,故也只能顺次通过
    //4.并发队列异步执行:10辆汽车排成多支队伍,有好几条公路,各队伍可同时通过
    
    //总结:
    //1.串行并行-汽车排了几队:排一队的就像是连成一串,为串行;排几队就是待会可以并行,为并行.
    //2.同步异步-有几条公路:一条就只能顺次通过,为同步;好几条就可以同时通过,为异步.
    //3.默认代码为串行同步,网络请求为并发异步
    
    lazy private var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 16, y: 44, width: 300, height: 300))
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(imageView)
        
        // MARK: 串行队列-同步sync执行
        //决定按代码顺序执行
//        let serialQueue = DispatchQueue(label: "serialQueue")
//        serialQueue.sync {
//            for i in 1...3{
//                print("i:\(i)")
//            }
//        }
//
//        for j in 10...13{
//            print("j:\(j)")
//        }
        
        // MARK: 串行队列-异步async执行
//        //可能按代码顺序执行,可能不按代码顺序执行
//        let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
//        concurrentQueue.async {
//            for i in 1...3{
//                print("i:\(i)")
//            }
//            print(Thread.current)       //打印当前线程属于几号线程
//        }
//        concurrentQueue.async {
//            for j in 10...13{
//                print("j:\(j)")
//            }
//            print(Thread.current)       //打印当前线程属于几号线程
//        }
//        
//        // MARK: 并发队列-线程间的通信
//        //全局并发队列
//        DispatchQueue.global().async {
//            print(Thread.current)          //子线程
//
//            DispatchQueue.main.async {
//                print(Thread.current)       //主线程
//            }
//        }
//        
//        // MARK: 并发队列-线程间通信的实际使用
//        DispatchQueue.global().async{               //使用子线程获取数据
//            let data = try! Data(contentsOf: URL(string: "https://pic4.zhimg.com/v2-1a72072cf6819399d195908e5fcac14f_r.jpg")!)
//            let image = UIImage(data)!
//            DispatchQueue.main.async {
//                self.imageView.image = image        //使用主线程给imageView赋值
//            }
//        }
//        
//        // MARK: 在主线程上延迟执行
//        //并发队列异步延迟执行
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            
//        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        IndicatorInfo(title: NSLocalizedString("NearBy", comment: "首页上方的附近标签"))
    }

}
