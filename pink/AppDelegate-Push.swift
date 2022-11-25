//
//  AppDelegate-Push.swift
//  pink
//
//  Created by gbt on 2022/11/18.
//
/*
    IOS推送通知:
 1.注册 APNs 来获取推送所需的 token(不同真机不同token)
 2.保存 Token
 3.配置私钥签名并加密JWT(JSON Web Token)
    3.1 苹果开发者账号 -> 注册APNs密钥,得到.p8文件
    3.2 在LeanCloud后台的推送 -> ‘iOS 推送 Token Authentication’,新增Token Authentication

 */
import LeanCloud

extension AppDelegate{
    // MARK: app开通推送通知 - 2.保存 Token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
//        LCApplication.default.currentInstallation.set(
//            deviceToken: deviceToken,
//            apnsTeamId: "SZ7KARML6N")//开发者账号TeamId
//        LCApplication.default.currentInstallation.save { (result) in
//            switch result {
//            case .success: break
////                print("保存推送 Token 成功")
//            case .failure(error: let error):
//                print("保存推送 Token error \(error)")
//            }
//        }
        
        let installation = LCApplication.default.currentInstallation
        
        installation.set(deviceToken: deviceToken, apnsTeamId: "R3R9W3ZDBN")
        
        //把当前设备关联上当前登录的user,为防止存入失败,此用户再也没机会收到推送,添加判断处理
        //防止在用户登录时写入数据失败,故在每次用户打开App时继续判断处理
        if installation.get(kUserCol) == nil, let user = LCApplication.default.currentUser{
            try? installation.set(kUserCol, value: user)
        }
        
        installation.save { (result) in
            switch result {
            case .success:
                print("保存推送 Token 成功")
            case .failure(error: let error):
                print("保存推送 Token error \(error)")
            }
        }
        
    }
}


extension AppDelegate: UNUserNotificationCenterDelegate{
    // MARK: 遵守UNUserNotificationCenterDelegate - 用户点击推送后触发
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo//获取payload,进而获取传过来的noteID
        if let noteID = userInfo["noteID"] as? String{
            let query = LCQuery(className: kNoteTable)
            query.whereKey(kAuthorCol, .included)
            UIViewController.showGlobalLoadHUD()
            query.get(noteID){ res in
                UIViewController.hideGlobalHUD()
                if case let .success(object: note) = res{
                    //获取tabBarC,找到笔记所在的viewcontroller
                    guard let tabBarC = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController as? UITabBarController else { return }
                    
                    //构建NoteDetailVC
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let detailVC = storyboard.instantiateViewController(identifier: kNoteDetailVCID) { coder in
                        NoteDetailVC(coder: coder, note: note)
                    }
                    detailVC.modalPresentationStyle = .fullScreen
                    detailVC.isFromPush = true
                    tabBarC.selectedViewController?.present(detailVC, animated: true)
                }
                
            }
            
        }
        
        completionHandler()//固定用法
    }
    
    
}
