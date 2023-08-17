//
//  UIView-Extensions.swift
//  pink
//
//  Created by gbt on 2022/11/23.
//
/*
    UIView 扩展
 */

import Foundation

extension UILabel{
    //更改label文本颜色
    func setToLight(_ text: String){
        self.text = text
        textColor = .label
    }
}

// MARK: -
extension UIButton{
    
    //自定义登录按钮的可点击状态
    func setToEnabled(){
        isEnabled = true
        backgroundColor = mainColor
    }
    
    //自定义登录按钮的不可点击状态
    func setToDisabled(){
        isEnabled = false
        backgroundColor = mainLightColor
    }
    
    //变成胶囊按钮
    func makeCapsule(_ color: UIColor = .label){
        layer.cornerRadius = frame.height / 2
        layer.borderWidth = 1
        layer.borderColor = color.cgColor
    }
}
// MARK: -
extension UIImage {
    
    //初始化构造器三原则:
    //1.指定构造器必须调用它直接父类的指定构造器方法--见FollowVC
    //2.便利构造器必须调用同一个类中定义的其它初始化方法
    //3.便利构造器在最后必须调用一个指定构造器
    //可失败的便利构造器 init?
    convenience init?(_ data: Data?){
        if let unwrappedData = data{
            self.init(data: unwrappedData)
        }else{
            return nil
        }
    }
    
    enum JPEGQuality: CGFloat{
        case lowest = 0
        case low = 0.25
        case medium = 0.5
        case high = 0.75
        case highest = 1
    }
    
    //选择不同画质类型来压缩图片
    func jpeg(_ jpegQuality: JPEGQuality) -> Data?{
        jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
// MARK: -
extension UITextField{
    //对UITextField 的text 进行安全解包,若当前text为空值,则返回空字符串; 不要直接使用 UITextField.text! 进行强制解包
    var unwrappedText: String { text ?? "" }
    
    //若为空字符串,缩减为""(防止用户输入大量空字符串)
    var exactText: String {
        unwrappedText.isBlank ? "" : unwrappedText
    }
    
    //对空字符串进行判断:将空格去掉后,是否有其他字符
    var isBlank: Bool { unwrappedText.isBlank }
}
    // MARK: -
extension UITextView{
    //unwrappedText 解包字符串
    var unwrappedText: String { text ?? "" }
    
    //若为空字符串,缩减为""(防止用户输入大量空字符串),与empty 搭配用
    var exactText: String {
        unwrappedText.isBlank ? "" : unwrappedText
    }
    
    //对空字符串进行判断:将空格去掉后,是否有其他字符
    var isBlank: Bool { unwrappedText.isBlank }
}

    // MARK: -
extension UIView{
    
    //添加 @IBInspectable , 指给故事版的View设置圆角属性
    @IBInspectable
    var radius: CGFloat{
        get{
            layer.cornerRadius
        }
        set{
            clipsToBounds = true
            layer.cornerRadius = newValue
        }
    }
}

    //MARK: -
extension UIAlertAction{
    
    //通过函数来设置UIAlertAction文本颜色
    func setTitleColor(_ color: UIColor){
        setValue(color, forKey: "titleTextColor")
    }
    
    //通过计算属性来设置UIAlertAction文本颜色
    var titleTextColor: UIColor?{
        get{
            value(forKey: "titleTextColor") as? UIColor
        }
        set{
            setValue(newValue, forKey: "titleTextColor")
        }
    }
}
