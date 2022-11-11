//
//  NoteDetailVC-Helper.swift
//  pink
//
//  Created by gbt on 2022/11/7.
//
/*
    封装-”删除“弹框提示
 */
import Foundation
extension NoteDetailVC{
    // MARK: 封装 - ”删除“弹框提示
    //删除某个东西之前给用户的alert提示框
    func showDelAlert(for name: String, confirmHandler: ((UIAlertAction) -> ())?){
        let alert = UIAlertController(title: "提示", message: "确认删除\(name)", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "取消", style: .cancel)
        let confirm = UIAlertAction(title: "确认", style: .default, handler: confirmHandler)//闭包confirmHandler
        alert.addAction(cancel)
        alert.addAction(confirm)
        present(alert, animated: true)
    }
    
    // MARK: 封装 - commentCount字段增减
    //1.note表的commentCount字段增减,2.commentCount增减--自动反映到UI
    func updateCommentCount(by offset: Int){
        //云端数据
        //目前LC的increase用法注意(均为自己实践,非官方说明)
        //1.评论数的增减这边,递增递减均需save;2.点赞收藏那边的递增不能save,不然会变成递增2
        try? self.note.increase(kCommentCountCol, by: offset)
        note.save { _ in }
        //UI
        self.commentCount += offset
    }
    
}
