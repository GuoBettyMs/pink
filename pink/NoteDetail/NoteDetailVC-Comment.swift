//
//  NoteDetailVC-Comment.swift
//  pink
//
//  Created by isdt on 2022/10/18.
//
/*
    详细笔记页面的评论事件以及辅助函数
 */

import LeanCloud

extension NoteDetailVC{
    // MARK: 监听评论事件
    //用户按下评论按钮(共三处)后,弹出评论用的textView
    func comment(){
        if let _ = LCApplication.default.currentUser{
            showTextView()//用户已登陆,可直接评论
        }else{
            showTextHUD("请先登录哦")
        }
    }
    
    // MARK: 监听评论回复事件 - 弹出回复用的textView
    //用户按下某个评论或某个评论的回复时,弹出回复用的textView
    func prepareForReply(_ nickName: String, _ section: Int, _ replyToUser: LCUser? = nil){
        //参数1:全局变量isReply(flag)--因共用textview,故在textview后面的'发送'按钮按下时判断究竟是发评论还是回复
        //参数2:textView的placeholder
        //参数3:全局变量replyToUser(flag),replyToUser = replyAuthor 表明自己是子回复,发送按钮按下后进行判断,写入云端回复表时追加被回复人这一字段
        //都传参进去,每次都处理(reset)   LCUser = nil
        showTextView(true, "回复 \(nickName)", replyToUser)
        commentSection = section//用户按下某个评论,获取到该评论的索引
    }

    // MARK: 评论事件 - 弹出评论textView
    //弹出textView,可用作评论/回复/子回复
    func showTextView(_ isReply: Bool = false, _ textViewPH: String = kNoteCommentPH, _ replyToUser: LCUser? = nil){
        //reset
        self.isReply = isReply //isReply默认为false,用户只能评论
        textView.placeholder = textViewPH
        self.replyToUser = replyToUser//重置子回复被回复人字段
        
        //UI
        textView.becomeFirstResponder()
        textViewBarView.isHidden = false
    }
    
    // MARK: 辅助函数 - 用户发布评论或者回复后
    func hideAndResetTextView(){
        textView.resignFirstResponder()
        //reset
        textView.text = ""
    }
    
}
