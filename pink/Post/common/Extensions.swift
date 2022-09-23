//
//  Extensions.swift
//  LittlePinkBook
//
//  Created by isdt on 2022/9/15.
//
/*
 
    扩展
 */

import UIKit

extension UITextField{
    //对UITextField 的text 进行安全解包,若当前text为空值,则返回空字符串; 不要直接使用 UITextField.text! 进行强制解包
    var unwrappedText: String { text ?? "" } 
}

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
    
    // MARK: 加载框--手动隐藏
    
    // MARK:  提示框--自动隐藏
    func showTextHUD(_ title: String, _ subTitle: String? = nil){
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .text //不指定的话显示菊花和下面配置的文本
        hud.label.text = title
        hud.detailsLabel.text = subTitle
        hud.hide(animated: true, afterDelay: 2)         //2秒后自动隐藏
    }
    
    // MARK: 点击空白处收起键盘
    func hideKeyboardWhenTappedAround(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        //保证tap手势不会影响到其他touch类控件的手势
        //若不设，则本页面有tableview时，点击cell不会触发didSelectRowAtIndex（除非长按）
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard(){
        view.endEditing(true) //让view中的所有textfield失去焦点--即关闭小键盘
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
    
    // MARK: 静态属性和方法--1.直接用类名进行调用,2.省资源
    // MARK: static和class的区别
    //static能修饰class/struct/enum的存储属性、计算属性、方法;class能修饰类的计算属性和方法
    //static修饰的类方法不能继承；class修饰的类方法可以继承
    //在protocol中要使用static
    
    //加载xib上的view
    //为了更通用，使用泛型。as?后需接类型，故形式参数需为T.Type，实质参数为XXView.self--固定用法
    static func loadView<T>(fromNib name: String, with type: T.Type) -> T{
        if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T{
            return view
        }
        fatalError("加载\(type)类型的view失败")
    }
}
