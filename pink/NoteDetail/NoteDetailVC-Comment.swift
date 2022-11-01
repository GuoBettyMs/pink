//
//  NoteDetailVC-Comment.swift
//  pink
//
//  Created by isdt on 2022/10/18.
//
/*
    详细笔记页面的评论事件 //
 */

import LeanCloud

extension NoteDetailVC{
    
    //用户按下评论按钮(共三处)后,弹出评论用的textView
    func comment(){
        if let _ = LCApplication.default.currentUser{
            showTextView()
        }else{
            showTextHUD("请先登录哦")
        }
    }
    
    //弹出textView,可用作评论/回复/子回复
    func showTextView(_ isReply: Bool = false, _ textViewPH: String = kNoteCommentPH, _ replyToUser: LCUser? = nil){
        //reset
        self.isReply = isReply
        textView.placeholder = textViewPH
        self.replyToUser = replyToUser
        
        //UI
        textView.becomeFirstResponder()
        textViewBarView.isHidden = false
    }
}
