//
//  NoteEditVC-Config.swift
//  pink
//
//  Created by isdt on 2022/9/23.
//
/*
    发布笔记编辑页面的 viewDidLoad 内容
 */

import Foundation

extension NoteEditVC{
    func config(){
        hideKeyboardWhenTappedAround()              //点击空白处收起键盘
        
        // MARK: collectionview
        photoCollectionV.dragInteractionEnabled = true //开启拖放交互
        
        // MARK: titleCountLabel
        titleCountL.text = "\(kMaxNoteTitleCount)"      //kMaxNoteTitleCount 发生改变时直接修改,无需再修改故事版的kMaxNoteTitleCount
        
        // MARK: textView
        // 去除文本和placeholder的上下左右边距
        let lineFragmentPadding = textView.textContainer.lineFragmentPadding    //去除内容缩进(左右边距)
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -lineFragmentPadding, bottom: 0, right: -lineFragmentPadding)      //去除文本边距(上下边距)
       
        
        // 行间距、输入文本属性、光标颜色
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6          //使用 lineHeightMultiple 会改变光标的高度,不推荐使用
        let typingAttributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.secondaryLabel
        ]
        textView.typingAttributes = typingAttributes
        
        // 光标颜色
        textView.tintColorDidChange()
        
        //给软键盘添加自定义工具栏 TextViewIAView (加载xib上的View)
        textView.inputAccessoryView = Bundle.loadView(fromNib: "TextViewIAView", with: TextViewIAView.self)
        textViewIAView.doneBtn.addTarget(self, action: #selector(resignTextView), for: .touchUpInside)
        textViewIAView.maxTextCountLabel.text = "/\(kMaxNoteTextCount)"
        
        /*等同于
         if let textViewIAView = Bundle.main.loadNibNamed("TextViewIAView", owner: nil, options: nil)?.first as? TextViewIAView{
             textView.inputAccessoryView = textViewIAView
         }
         (textView.inputAccessoryView as! TextViewIAView).doneBtn.addTarget(self, action: #selector(resignTextView), for: .touchUpInside)
         (textView.inputAccessoryView as! TextViewIAView).maxTextCountLabel.text = "/\(kMaxNoteTextCount)"
         */

        // MARK: AMapLocationManager、AMapSearchAPI
        //请求定位权限
        locationManager.requestWhenInUseAuthorization()
        
        //定位权限 隐私合规
        AMapLocationManager.updatePrivacyAgree(AMapPrivacyAgreeStatus.didAgree)
        AMapLocationManager.updatePrivacyShow(AMapPrivacyShowStatus.didShow, privacyInfo: AMapPrivacyInfoStatus.didContain)
//        AMapSearchAPI.updatePrivacyAgree(AMapPrivacyAgreeStatus.didAgree)
//        AMapSearchAPI.updatePrivacyShow(AMapPrivacyShowStatus.didShow, privacyInfo: AMapPrivacyInfoStatus.didContain)
        
        
        // MARK: 文件相关
        /*
        //NSHomeDirectory()         //沙盒根目录,存文件时不建议直接访问根目录
        //两种寻找文件的方法
        //1.返回路径:NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        //2.返回URL:FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        //path为普通字符串,而url一般长这样
        //file:///xxx/xx.mov"(本地)/"https://xx/xx.mov"(远程)
        
        //关于沙盒中的Library/SplashBoard文件夹
        //系统会缓存LaunchScreen.storyboad中的图片,即使删除App也没用,故需手动删除,迭代时需加入代码(可能还需其余优化操作):
         //删除快照文件夹
         do{
             try FileManager.default.removeItem(atPath: "\(NSHomeDirectory())/Library/SplashBoard")
         }catch{
             print(error)
         }

        //打印沙盒路径
        print(NSHomeDirectory())
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, false)[0])
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
         */
        print(NSHomeDirectory())
    }
}
// MARK: -
extension NoteEditVC{
    
    // MARK: 监听 - 点击“完成”按钮移除软键盘
    @objc private func resignTextView(){
        textView.resignFirstResponder()
    }
}

