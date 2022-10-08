//
//  LocalLogin-Extensions.swift
//  pink
//
//  Created by isdt on 2022/10/8.
//
/*
     扩展-本地登录界面
 */

import Foundation

extension UIViewController{
    func localLogin(){
        
        //初始化JVERIFICATIONService
        let config = JVAuthConfig()         //JVAuthConfig类，应用配置信息类
        config.appKey = kJAppKey
//        config.authBlock = { (result) -> Void in
//                if let result = result {
//                 if let code = result["code"], let content = result["content"] {
//                    print("初始化结果 result: code = \(code), content = \(content)")
//                    }
//                }
//            }
        JVERIFICATIONService.setup(with: config)
    }
}
