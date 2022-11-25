//
//  AppDelegate.swift
//  pink
//
//  Created by isdt on 2022/9/20.
//

import UIKit
import CoreData
import LeanCloud

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        config()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "pink")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    
    // MARK: context存储 - 主线程
    //主队列上的context存储
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: context存储 - 后台线程
    //并发队列上的context存储,本地存储的增删改查
    func saveBackgroundContext(){
        //因可以有多个并发队列的context,故每次persistentContainer.viewContext时都会创建个新的,故不能像上面一样.
        //这里需用使用同一个并发队列的context(即常量文件夹中引用的那个)
        if backgroundContext.hasChanges{
            do {
                try backgroundContext.save()
            } catch {
                fatalError("后台存储数据失败(包括增删改):\(error)")
            }
        }
    }

}

// MARK: - 添加SDK
extension AppDelegate{
    
    private func config(){
        
        // MARK: config - tableView SectionHeader
        //去除tableView SectionHeader上方多出来的一块空隙
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
      
        // MARK: config - navigationItem
        //UI - 设置所有的navigationItem的返回按钮颜色
        UINavigationBar.appearance().tintColor = .label
                
        // MARK: config - 高德Key
        AMapServices.shared().enableHTTPS = true    //开启HTTPS功能
        AMapServices.shared().apiKey = kAMapApiKey       //配置定位Key
                
        // MARK: config - LeanCloud初始化
        //初始化LeanCloud,在LeanCloud控制台找到id、key、serverURL
//            LCApplication.logLevel = .off           //不开启 SDK 的调试日志（debug log）
            do {
                //发推送往测试环境的App(通过Xcode安装的)时需加此设置.上架时需去掉.
                let environment: LCApplication.Environment = [.pushDevelopment]
                let configuration = LCApplication.Configuration(environment: environment)
                
                try LCApplication.default.set(
                    id: kLCAppID,
                    key: kLCAppKey,
                    serverURL: kLCServerURL,
                    configuration: configuration)
            } catch {
                print(error)
            }

            // MARK: app开通推送通知 - 1.注册 APNs 获取推送所需的 token
            //由于是在LC上处理推送功能的相关设置,需要在LC初始化之后注册
            /* 可简写为
             UIApplication.shared.registerForRemoteNotifications()
             源码:
             UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                 switch settings.authorizationStatus {
                 case .authorized:
                     DispatchQueue.main.async {
                         UIApplication.shared.registerForRemoteNotifications()
                     }
                 case .notDetermined:
                     UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
                         if granted {
                             DispatchQueue.main.async {
                                 UIApplication.shared.registerForRemoteNotifications()
                             }
                         }
                     }
                 default:
                     break
                 }
             }
             */
            UIApplication.shared.registerForRemoteNotifications()//若未收到推送,检查app是否处于后台,app推送设置是否打开,手机勿扰模式是否关闭
            
            //遵守UNUserNotificationCenterDelegate,响应通知数据,点击通知跳转到对应的笔记
            UNUserNotificationCenter.current().delegate = self

        
    }
}

