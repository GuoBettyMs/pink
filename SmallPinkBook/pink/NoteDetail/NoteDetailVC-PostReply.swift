//
//  NoteDetailVC-PostReply.swift
//  pink
//
//  Created by gbt on 2022/11/8.
//
/*
    详细笔记页面 - 发送回复
 */

import LeanCloud

extension NoteDetailVC{
    // MARK: 发送回复
    func postReply(){
        let user = LCApplication.default.currentUser!
        do{
            //用户点击的评论索引是commentSection,在评论对象属性数组中对应的评论是comments[commentSection]
            let comment = comments[commentSection]
            
            //云端数据
            //1.reply表
            let reply = LCObject(className: kReplyTable)
            try reply.set(kTextCol, value: textView.unwrappedText)
            try reply.set(kUserCol, value: user)
            try reply.set(kCommentCol, value: comment)//将点击的评论存到“回复”云端表字段
            
            //表明自己是子回复,发送按钮按下后进行判断
            //评论view->回复view->再回复view,给再回复view(子回复)中的被回复人字段赋值
            if let replyToUser = replyToUser{
                try reply.set(kReplyToUserCol, value: replyToUser)
            }

            reply.save { res in
                if case .success = res{
                    
                    //hasReply字段为false,表明这条评论下没有回复,再进入云端保存字段; hasReply若已为true则不重复写入,即:hasReply查询成功但为false时才写入
                    if let hasReply = comment.get(kHasReplyCol)?.boolValue, hasReply != true{
//                        print("reply表HasReplyCol字段-云端保存成功")
                        try? comment.set(kHasReplyCol, value: true)
                        comment.save{ _ in }
                    }
                }else{
                    print("reply表HasReplyCol字段-云端保存失败")
                }
            }
            //2.note表
            self.updateCommentCount(by: 1)//包含页面上的评论数变化的UI
            
            //内存数据
            //当用户点击某条评论,准备回复的时候,会给全局变量commentSection赋一个当前的section值,利用这个值找到对应的内层数组
            replies[commentSection].replies.append(reply)

            //append前 [["回复对象",“回复对象”],[],[“回复对象”]]
            //append后 [["回复对象",“回复对象”,“回复对象“],[],[“回复对象”]]
            //append后第0个section有3个回复,索引是[0,1,2],插入的新row的索引是2,索引数值=总回复数-1
            if replies[commentSection].isExpanded{
                noteTableView.performBatchUpdates {
                    //row:先利用commentSection找到当前section中一共就几个回复,减去1之后就得出插入的新row的索引
                    noteTableView.insertRows(
                        at: [IndexPath(row: replies[commentSection].replies.count - 1, section: commentSection)],
                        with: .automatic
                    )
                }
            }else{
                
                if replies[commentSection].replies.count > 1 {
                    //下拉刷新才会更新
                    let cell = noteTableView.cellForRow(at: IndexPath(row: 0, section: commentSection)) as! ReplyCell
                    cell.showAllReplyBtn.setTitle("展示 \(replies[commentSection].replies.count - 1) 条回复", for: .normal)
                }else{
                    noteTableView.insertRows(
                        at: [IndexPath(row: 0, section: commentSection)],
                        with: .automatic
                    )
                }
                
//                self.noteTableView.reloadData()
            }
        }catch{
            print("给Reply表的字段赋值失败: \(error)")
        }
    }
}

