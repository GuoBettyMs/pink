//
//  Global-Functions.swift
//  pink
//
//  Created by gbt on 2022/11/18.
//
/*
    全局函数
 */
import Foundation

//全局图标
func largeIcon(_ iconName: String, with color: UIColor = .label) -> UIImage{
    let config = UIImage.SymbolConfiguration(scale: .large)
    let icon = UIImage(systemName: iconName, withConfiguration: config)!
    return icon.withTintColor(color)
}

//全局字符图标
func fontIcon(_ iconName: String, fontSize: CGFloat, with color: UIColor = .label) -> UIImage{
    let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: fontSize))
    let icon = UIImage(systemName: iconName, withConfiguration: config)!
    return icon.withTintColor(color)
}

//全局提示框
func showGlobalTextHUD(_ title: String){
    let window = UIApplication.shared.windows.last!
    let hud = MBProgressHUD.showAdded(to: window, animated: true)
    hud.mode = .text            //不指定的话显示菊花和配置的文本
    hud.label.text = title
    hud.hide(animated: true, afterDelay: 2)
}

//跳转到手机自带的‘设置’页面: 是否接收app通知
func jumpToSetting(){
    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
}
