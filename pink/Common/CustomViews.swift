//
//  CustomViews.swift
//  pink
//
//  Created by isdt on 2022/10/13.
//
/*
    创建系统类的子类
 */
import Foundation

//自定义button View
@IBDesignable           //在故事版实时显示
class BigButton: UIButton{
    
    //添加 @IBInspectable , 指给故事版的View设置圆角属性
    @IBInspectable var customCornerRadius: CGFloat = 0{
        didSet{
            layer.cornerRadius = customCornerRadius
        }
    }
    
    //若 BigButton 在代码中被调用,执行以下内容
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    //若 BigButton 在故事版中被调用,执行以下内容
    required init?(coder: NSCoder){
        super.init(coder: coder)
        sharedInit()
    }
    
    //BigButton 属性初始化
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        sharedInit()
    }
    
    private func sharedInit(){
        backgroundColor = .secondarySystemBackground
        tintColor = .placeholderText
        setTitleColor(.placeholderText, for: .normal)
        
        //水平对齐
        contentHorizontalAlignment = .leading
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        
    }
}

@IBDesignable
class RoundLabel: UILabel{
    
    //给label设置内边距
    override func draw(_ rect: CGRect) {
        super.drawText(in: rect.inset(by: UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 0)))
    }
}
