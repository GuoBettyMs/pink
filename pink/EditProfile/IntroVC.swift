//
//  IntroVC.swift
//  pink
//
//  Created by gbt on 2022/11/15.
//
/*
    个人页面的个人简介textView编辑页面
 
 */
import UIKit

class IntroVC: UIViewController {
    
    var intro = ""  //正向传值
    var delegate: IntroVCDelegate?
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var countL: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.becomeFirstResponder()
        textView.text = intro
        countL.text = "\(kMaxIntroCount)"
    }
    
    // MARK: 更新个人页面的个人简介并退出编辑页面
    @IBAction func done(_ sender: Any) {

        delegate?.updateIntro(textView.exactText)
        dismiss(animated: true)
        
    }
    

}


extension IntroVC: UITextViewDelegate{
    
    // MARK: 遵守UITextViewDelegate - 更新字符数
    func textViewDidChange(_ textView: UITextView) {
        guard textView.markedTextRange == nil else {return}
        countL.text = "\(kMaxIntroCount - textView.text.count)"
    }
    
    // MARK: 遵守UITextViewDelegate - 限制简介字符数
    //询问委托是否替换文本视图中的指定文本,true旧案文由新案文取代, textView更改的文本视图,range当前选择范围,text要插入的文本
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let isExceed = range.location >= 100 || (textView.text.count + text.count > 100)
        if isExceed { showTextHUD("个人简介最多输入\(kMaxIntroCount)字哦") }
        return !isExceed
    }
}
