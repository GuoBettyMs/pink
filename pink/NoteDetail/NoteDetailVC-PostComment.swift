//
//  NoteDetailVC-PostComment.swift
//  pink
//
//  Created by gbt on 2022/11/9.
//
/*
    详细笔记页面 - 发送评论
 */
import LeanCloud

extension NoteDetailVC{
    
    // MARK: 发送评论
    func postComment(){
        let user = LCApplication.default.currentUser!
        do {
            //云端数据
            //1.comment表
            let comment = LCObject(className: kCommentTable)
            try comment.set(kTextCol, value: textView.unwrappedText)
            try comment.set(kUserCol, value: user)
            try comment.set(kNoteCol, value: note)
            comment.save { _ in }
            /* 发表评论后,即时显示,故无需再添加弹窗提示
            comment.save { res in
                if case .success = res{
                    self.showTextHUD("评论已发布")
                }
            }
             */

            //2.note表
            self.updateCommentCount(by: 1)//包含页面上的评论数变化的UI

            //内存数据
            comments.insert(comment, at: 0)         //最新评论放在第一条

            //UI
            tableView.performBatchUpdates {
                tableView.insertSections(IndexSet(integer: 0), with: .automatic)//将最新评论插入第一个section
            }
        } catch {
            print("给Comment表的字段赋值失败: \(error)")
        }
    }
    

}

