//
//  NoteEditVC.swift
//  LittlePinkBook
//
//  Created by isdt on 2022/9/16.
//
/*
    小粉书的底部导航栏的“发布”功能 -> 编辑界面
  1.图片添加功能
  2.文本添加功能(包含标题和文案)
  3.参与话题功能
  4.查询地点功能
 */

import UIKit

class NoteEditVC: UIViewController {
 
    @IBOutlet weak var photoCollectionV: UICollectionView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titleCountL: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var channelIcon: UIImageView!
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var channelPlaceholderLabel: UILabel!
    @IBOutlet weak var poiNameIcon: UIImageView!
    @IBOutlet weak var poiNameLabel: UILabel!
    
    //图片添加
    var photos = [
        UIImage(named: "Post-1")!, UIImage(named: "Post-2")!
    ]
//    var videoURL: URL = Bundle.main.url(forResource: "testVideo", withExtension: "mp4")!
    var videoURL: URL?
    var photoCount: Int{ photos.count }     //定义计算属性,无论数据是否有发生改变,都计算一遍数据,更新数据//
    var isVideo: Bool { videoURL != nil }
    
    //文本添加
    var textViewIAView: TextViewIAView{ textView.inputAccessoryView as! TextViewIAView }
   
    //参与话题
    var channel = ""
    var subChannel = ""
    var poiName = ""
    
    //查询地点
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }


    @IBAction func TFEditDidBegin(_ sender: Any) {
        titleCountL.isHidden = false
    }

    @IBAction func TFEditDidEnd(_ sender: Any) {
        titleCountL.isHidden = true
    }
    
    // MARK: 点击软键盘的完成按钮收起软键盘
    //和在textFieldShouldReturn里面resignFirstResponder是一个效果
    @IBAction func TFDidEndOnExit(_ sender: Any) {
    }
    
    // MARK: 限制标题字符并实时显示剩余可输字符
    // 输入字符后再判断是否超过限制字数,再处理
    @IBAction func TFEditChanged(_ sender: Any) {
        //当前有高亮文本时(拼音键盘)return,防止拼音尚未输完整,却因超字数而无法编辑
        guard titleTextField.markedTextRange == nil else { return }

        //用户输入完字符后进行判断,若大于最大字符数,则截取前面的文本(if里面第一行)
        if titleTextField.unwrappedText.count > kMaxNoteTitleCount{

            // prefix截取前 kMaxNoteTitleCount 位字符
            titleTextField.text = String(titleTextField.unwrappedText.prefix(kMaxNoteTitleCount))

            showTextHUD("标题最多输入\(kMaxNoteTitleCount)字哦")

            //用户粘贴文本后的光标位置,默认会跑到粘贴文本的前面,此处改成末尾
            DispatchQueue.main.async {
                let end = self.titleTextField.endOfDocument
                self.titleTextField.selectedTextRange = self.titleTextField.textRange(from: end, to: end)
            }
        }
        
        //实时显示剩余可输字符
        titleCountL.text = "\(kMaxNoteTitleCount - titleTextField.unwrappedText.count)"
    }

    // MARK: 调用 ChannelVCDelegate 协议、POIVCDelegate协议
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let channelVC = segue.destination as? ChannelVC {
            
            //将ChannelVC获取到的话题传到 NoteEditVC
            channelVC.PVDelegate = self                 //当前协议不是NoteEditVC的属性,所以PVDelegate不需要标记weak
            channelVC.subChannel = subChannel           //固定标记
        }else if let poiVC = segue.destination as? POIVC{
            
            //将POIVC获取到的地点传到 NoteEditVC
            poiVC.pOIVCDelegate = self
            poiVC.poiName = poiName                     //固定标记
        }
    }
}

// MARK: -
extension NoteEditVC: UITextViewDelegate{
    
    // MARK: 遵守UITextViewDelegate - 更新限制字符数量
    func textViewDidChange(_ textView: UITextView) {

        //当前有高亮文本时(拼音键盘)return,防止拼音尚未输完整,却因超字数而无法编辑
        guard textView.markedTextRange == nil else { return }
        textViewIAView.currentTextCount = textView.text.count
    }
}

    // MARK: -
extension NoteEditVC: POIVCDelegate{
    
    // MARK: 遵守UITextViewDelegate - 更新地点UI
    func updatePOIName(_ poiName: String) {
        if poiName == kPOIsInitArr[0][0]{
            //选择“不显示位置”
            self.poiName = ""
            poiNameIcon.tintColor = .label
            poiNameLabel.text = "添加地点"
            poiNameLabel.textColor = .label
        }else{
            //数据
            self.poiName = poiName
            //UI
            poiNameIcon.tintColor = blueColor
            poiNameLabel.text = poiName
            poiNameLabel.textColor = blueColor
        }
    }
}

// MARK: -
extension NoteEditVC: ChannelVCDelegate{
    
    // MARK: 遵守ChannelVCDelegate - 更新话题数据 & UI
    func updateChannel(channel: String, subChannel: String) {
        //接收 ChannelVC 数据
        self.channel = channel
        self.subChannel = subChannel
        
        //UI更新
        channelIcon.tintColor = blueColor
        channelLabel.text = subChannel
        channelLabel.textColor = blueColor
        channelPlaceholderLabel.isHidden = true
    }
}

// MARK: - 遵守UITextFieldDelegate
//因系统自带拼音键盘把拼音也当做字符,故需在输入完之后判断,故全部移到 TFEditChanged方法 中进行处理
//shouldChangeCharactersIn 输入字符同时判断是否超过限制字数再处理(弊端: 使用拼音键盘会出现拼音过多导致不正常的判断)
//extension NoteEditVC: UITextFieldDelegate{
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        //range.location--当前输入的字符或粘贴文本的第一个字符的索引
//        //string--当前输入的字符或粘贴的文本
//
//        //实时显示剩余可输字符
//        titleCountL.text = "\(kMaxNoteTitleCount - titleTextField.unwrappedText.count)"
//
//        //限制字串长度为20，以下情况返回false（即不让输入）：
//        //1-输入的字符或粘贴的文本在整体内容的索引是20的时候（第21个字符不让输）
//        //2-当前输入的字符的长度+粘贴文本的长度超过20时--防止从一开始一下子粘贴超过20个字符的文本
//        //当前输入的字符的长度: textField.unwrappedText.count; string.count:粘贴文本的长度
//        let isExceed = range.location >= kMaxNoteTitleCount || (textField.unwrappedText.count + string.count > kMaxNoteTitleCount)
//
//        if isExceed{ showTextHUD("标题最多输入\(kMaxNoteTitleCount)字哦") }
//        return !isExceed
//    }
//}

