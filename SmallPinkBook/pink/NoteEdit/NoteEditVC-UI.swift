//
//  NoteEditVC-UI.swift
//  pink
//
//  Created by isdt on 2022/9/28.
//
/*
    发布笔记编辑页面的 viewDidLoad 内容 - 编辑草稿界面
    1.保存草稿功能
    2.发布笔记功能
 */
import PopupDialog

extension NoteEditVC{
    func setUI(){
       
        //重新设置个人页面‘草稿’cell中,笔记编辑导航栏的leftBarButtonItem,使返回按钮不带标题
        let icon = largeIcon("chevron.left")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(dismissUpdate))

        addPopup()                      //右上角加按钮并展示popup弹框
        setDraftNoteEditUI()            //编辑草稿笔记
        setNoteEditUI()                 // 编辑用户自己的笔记
    }
    
    @objc private func dismissUpdate(){
        navigationController?.popViewController(animated: true)
    }
    
}

    // MARK: - 编辑草稿笔记/用户自己的笔记
extension NoteEditVC{
    
    // MARK: 编辑草稿笔记
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

    // MARK: 编辑用户自己的笔记
    private func setNoteEditUI(){
        if let MyNote = editMyNote {
            titleTextField.text = MyNote.getExactStringVal(kTitleCol)
            textView.text = MyNote.getExactStringVal(kTextCol)
            channel = MyNote.getExactStringVal(kChannelCol)
            subChannel = MyNote.getExactStringVal(kSubChannelCol)
            poiName = MyNote.getExactStringVal(kPOINameCol)
        }
        
        if !subChannel.isEmpty { updateChannelUI()}
        if !poiName.isEmpty { updatePOINameUI()}
        
    }
}

    //MARK: - 编辑草稿笔记/笔记时的统一处理
extension NoteEditVC{
    // MARK: 编辑笔记 - 更新话题UI
    func updateChannelUI(){
        channelIcon.tintColor = blueColor
        channelLabel.text = subChannel
        channelLabel.textColor = blueColor
        channelPlaceholderLabel.isHidden = true
    }

    // MARK: 编辑笔记 - 更新地点UI
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


    //MARK: -
extension NoteEditVC{
    // MARK: 右上角加弹框按钮
    private func addPopup(){
        let icon = largeIcon("info.circle")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(showPopup))
        
        //内容UI属性
        let pv = PopupDialogDefaultView.appearance()
        pv.titleColor = .label
        pv.messageFont = .systemFont(ofSize: 13)
        pv.messageColor = .secondaryLabel
        pv.messageTextAlignment = .natural
        
        //按钮UI属性
        let cb = CancelButton.appearance()
        cb.titleColor = .label
        cb.separatorColor = mainColor
        
        //整个popup UI属性
        let pcv = PopupDialogContainerView.appearance()
        pcv.backgroundColor = .secondarySystemBackground
        pcv.cornerRadius = 10
    }

    // MARK: 监听弹框按钮 - 展示popup弹框
    @objc private func showPopup(){
        let title = "发布小贴士"
        let message =
            """
            小粉书鼓励向上、真实、原创的内容，含以下内容的笔记将不会被推荐：
            1.含有不文明语言、过度性感图片；
            2.含有网址链接、联系方式、二维码或售卖语言；
            3.冒充他人身份或搬运他人作品；
            4.通过有奖方式诱导他人点赞、评论、收藏、转发、关注；
            5.为刻意博取眼球，在标题、封面等处使用夸张表达。
            """
        let popup = PopupDialog(title: title, message: message, transitionStyle: .zoomIn)           //创建popup弹框
        let btn = CancelButton(title: "知道了", action: nil)
        popup.addButton(btn)                    //添加popup弹框按钮
        present(popup, animated: true)          //展示popup弹框
    }
    
}

