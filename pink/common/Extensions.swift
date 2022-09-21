//
//  Extensions.swift
//  LittlePinkBook
//
//  Created by isdt on 2022/9/15.
//

import UIKit
import MBProgressHUD

extension UIView{
    
    //添加 @IBInspectable , 指给故事版的View设置圆角属性
    @IBInspectable
    var radius: CGFloat{
        get{
            layer.cornerRadius
        }
        set{
            layer.cornerRadius = newValue
        }
    }
}

extension UIViewController{
    
    // MARK: 展示加载框或提示框
    
    //加载框--手动隐藏
    
    // 提示框--自动隐藏
    func showTextHUD(_ title: String, _ subTitle: String? = nil){
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .text //不指定的话显示菊花和下面配置的文本
        hud.label.text = title
        hud.detailsLabel.text = subTitle
        hud.hide(animated: true, afterDelay: 2)
    }
}

extension Bundle{
    
    //TabBarC 文件中,33行,存图片进相册App的'我的相簿'里的文件夹名称
    var appName: String{
        if let appName = localizedInfoDictionary?["CFBundleDisplayName"] as? String{
            return appName
        }else{
            return infoDictionary!["CFBundleDisplayName"] as! String
        }
    }
}
