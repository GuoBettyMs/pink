//
//  SceneDelegate.swift
//  pink
//
//  Created by isdt on 2022/9/20.
//

import UIKit
import LeanCloud

var kStatusBarH: CGFloat = 0    //获取当前机型状态栏的高度
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    //程序一启动就被执行
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
//        guard let _ = (scene as? UIWindowScene) else { return }
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        kStatusBarH = windowScene.statusBarManager?.statusBarFrame.height ?? 0  //获取当前机型状态栏的高度
        
        let userInterfaceStyleInt = UserDefaults.standard.integer(forKey: kUserInterfaceStyle)
        if userInterfaceStyleInt == 1{
            window?.overrideUserInterfaceStyle = .light
        }else if userInterfaceStyleInt == 2{
            window?.overrideUserInterfaceStyle = .dark
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    // MARK: app进入前台后清除推送通知的角标
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
        //云端数据
        LCApplication.default.currentInstallation.badge = 0
        LCApplication.default.currentInstallation.save { (result) in
            switch result {
            case .success:
                break
            case .failure(error: let error):
                print("LCApplication.default.currentInstallation save error",error)
            }
        }
        
        //UI
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    // MARK: 支付宝登录授权接口
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {return}

//        print(url)                  //若本应用未被kill,则包括authcode等各种授权回调信息会通过这个url自动传入auth_V2的回调中
        
        //若url 包含"safepay",App是从支付宝跳转过来 “pink://safepay/?%7...”
        if url.host == "safepay"{
            
            //调用processAuth_V2Result:standbyCallback:方法获取支付宝登录业务授权结果
            AlipaySDK.defaultService()?.processAuth_V2Result(url, standbyCallback: { res in
                //若本应用在授权期间被kill了,则在这里的res里获取授权回调信息,此处省略处理
            })
        }
        
    }
    

}

