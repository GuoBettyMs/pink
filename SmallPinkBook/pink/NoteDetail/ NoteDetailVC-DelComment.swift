//
//   NoteDetailVC-DelComment.swift
//  pink
//
//  Created by gbt on 2022/11/9.
//
/*
    详细笔记页面 - 删除评论
 */
import LeanCloud

extension NoteDetailVC{
    
    // MARK: 删除评论
    func delComment(_ comment: LCObject, _ section: Int){
        self.showDelAlert(for: "评论") { _ in
            //云端数据
            comment.delete { _ in }
            self.updateCommentCount(by: -1)//包含页面上的评论数变化的UI
    
            //内存数据
            self.comments.remove(at: section)

            // 用deleteSections会出现'index out of range'的错误,因为DataSource里面的index没有更新过来,故直接使用reloadData
        //                        self.tableView.performBatchUpdates {
        //                            self.tableView.deleteSections(IndexSet(integer: section), with: .automatic)
        //                        }
            self.noteTableView.reloadData()
        }
    }
}




