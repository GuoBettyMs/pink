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
        LCApplication.default.currentInstallation.set(
            deviceToken: deviceToken,
            apnsTeamId: "SZ7KARML6N")//开发者账号TeamId
        LCApplication.default.currentInstallation.save { (result) in
            switch result {
            case .success:
                print("保存推送 Token 成功")
            case .failure(error: let error):
                print("保存推送 Token error \(error)")
            }
        }
    }
}
