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
    
    var draftNote: DraftNote?           //草稿笔记
    
    //闭包: 更新草稿后的处理
    var updateDraftNoteFinished: (() -> ())?
    
    //图片添加
    var photos = [
        UIImage(named: "Post-1")!, UIImage(named: "Post-2")!
    ]
//    var videoURL: URL? = Bundle.main.url(forResource: "testVideo", withExtension: "mp4")!
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
        setUI()
    }

    // MARK: -
    
    //显示标题字符数
    @IBAction func TFEditDidBegin(_ sender: Any) { titleCountL.isHidden = false }

    //隐藏标题字符数
    @IBAction func TFEditDidEnd(_ sender: Any) { titleCountL.isHidden = true }
    
    // MARK: 故事版事件 - 点击软键盘的完成按钮收起软键盘
    //和在textFieldShouldReturn里面resignFirstResponder是一个效果
    @IBAction func TFDidEndOnExit(_ sender: Any) {}
    
    // MARK: 故事版事件 - 限制标题字符并实时显示剩余可输字符
    // 输入字符后再判断是否超过限制字数,再处理
    @IBAction func TFEditChanged(_ sender: Any) { handleTFEditChanged() }
    
    // MARK: 故事版事件 - 存草稿到本地
    @IBAction func saveDraftNote(_ sender: Any) {
        
        //存草稿之前需判断当前用户输入的正文文本数量,看是否大于最大可输入数量)
        guard isValidateNote() else { return }
        
        if let draftNote = draftNote{
            updateDraftNote(draftNote)        //更新草稿
        }else{
            createDraftNote()                 //创建草稿
        }

    }
    
    // MARK: 故事版事件 -  发布笔记
    @IBAction func postNote(_ sender: Any) {
        //发布笔记之前需判断当前用户输入的正文文本数量,看是否大于最大可输入数量)
        guard isValidateNote() else { return }
    }
    

    // MARK: - 遵守 ChannelVCDelegate 协议、POIVCDelegate协议 - 传值
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let channelVC = segue.destination as? ChannelVC {
            
            //选择话题时,软键盘退出(不影响标题与正文的二次编辑)
            view.endEditing(true)
            
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
    
    // MARK: 遵守UITextViewDelegate - 更新地点数据 & UI
    func updatePOIName(_ poiName: String) {
       
        //数据
        if poiName == kPOIsInitArr[0][0]{
            self.poiName = ""                   //选择“不显示位置”
        }else{
            self.poiName = poiName
        }
        
        updatePOINameUI()        //UI更新
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
        updateChannelUI()
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

