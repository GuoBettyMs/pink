//
//  TextViewIAView.swift
//  pink
//
//  Created by isdt on 2022/9/23.
//
/*
 
    发布笔记编辑页面,编辑时系统自带软键盘的自定义工具栏,包括
    1.textView 的 “目前字符数/限制字符数” label
    2. ”完成“按钮
 
 */
import UIKit

class TextViewIAView: UIView {

    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var textCountStackView: UIStackView!
    @IBOutlet weak var textCountLabel: UILabel!
    @IBOutlet weak var maxTextCountLabel: UILabel!
    
    //当前字符数统计
    var currentTextCount = 0{
        didSet{
            if currentTextCount <= kMaxNoteTextCount{
                doneBtn.isHidden = false
                textCountStackView.isHidden = true
            }else{
                doneBtn.isHidden = true
                textCountStackView.isHidden = false
                textCountLabel.text = "\(currentTextCount)"
            }
        }
    }
}
