//
//  NoteDetailVC-ShareOrMore.swift
//  pink
//
//  Created by gbt on 2022/11/7.
//
/*
    笔记右上角的分享或者其他功能
    1.笔记是用户自己的笔记 -> 分享、编辑、删除、取消功能
    2.笔记不是用户自己的笔记 -> 分享功能
 */
import Foundation

extension NoteDetailVC{
    // MARK: 监听 - 分享或者分享、编辑、删除、取消事件
    func shareOrMore(){
        if isReadMyDraft{
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let shareAction = UIAlertAction(title: "分享", style: .default){_ in
                
            }
            let editAction = UIAlertAction(title: "编辑", style: .default){_ in  self.editNote()}
            let deleteAction = UIAlertAction(title: "删除", style: .destructive){_ in self.delNote() }
            let cancelAction = UIAlertAction(title: "取消", style: .cancel){_ in }
            
            alert.addAction(shareAction)
            alert.addAction(editAction)
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }else{
            
        }
    }
}
