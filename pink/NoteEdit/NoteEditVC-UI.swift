//
//  NoteEditVC-UI.swift
//  pink
//
//  Created by isdt on 2022/9/28.
//
/*
    发布笔记编辑页面的 viewDidLoad 内容 - 编辑草稿&笔记界面
 */

extension NoteEditVC{
    func setUI(){
        setDraftNoteEditUI()
    }
}

    // MARK: -
extension NoteEditVC{
    
    // MARK: 一般函数 - 编辑草稿笔记
    private func setDraftNoteEditUI(){
        if let draftNote = draftNote{
            titleTextField.text = draftNote.title
            textView.text = draftNote.text
            channel = draftNote.channel!
            subChannel = draftNote.subChannel!
            poiName = draftNote.poiName!
        }
        
        if !subChannel.isEmpty { updateChannelUI()}
        if !poiName.isEmpty { updatePOINameUI()}
        
    }
    
    // MARK: 一般函数 - 更新话题UI
    func updateChannelUI(){
        channelIcon.tintColor = blueColor
        channelLabel.text = subChannel
        channelLabel.textColor = blueColor
        channelPlaceholderLabel.isHidden = true
    }
    
    // MARK: 一般函数 - 更新地点UI
    func updatePOINameUI(){
        if poiName == ""{
            poiNameIcon.tintColor = .label
            poiNameLabel.text = "添加地点"
            poiNameLabel.textColor = .label
        }else{
            poiNameIcon.tintColor = blueColor
            poiNameLabel.text = poiName
            poiNameLabel.textColor = blueColor
        }
    }
    
}
