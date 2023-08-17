//
//  NoteDetailVC-DelReply.swift
//  pink
//
//  Created by gbt on 2022/11/9.
//
/*
    详细笔记页面 - 删除回复
 */
import LeanCloud

extension NoteDetailVC{
    // MARK: 删除回复
    func delReply(_ reply: LCObject, _ indexPath: IndexPath){
        showDelAlert(for: "回复") { _ in
            //云端数据
            reply.delete { _ in }
            self.updateCommentCount(by: -1)//包含页面上的评论数变化的UI
            
            //内存数据
            self.replies[indexPath.section].replies.remove(at: indexPath.row)
            
            //UI
            self.noteTableView.reloadData()
        }
    }
}
