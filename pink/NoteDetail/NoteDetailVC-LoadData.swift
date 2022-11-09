//
//  NoteDetailVC-LoadData.swift
//  pink
//
//  Created by gbt on 2022/11/9.
//
/*
    查询笔记详情页的所有评论和回复
 */
import LeanCloud

extension NoteDetailVC{
    
    // MARK: 获取所有评论和对应的回复
    func getCommentsAndReplies(){
        showLoadHUD()
        let query = LCQuery(className: kCommentTable)
        
        /*
        //获取指定字段的数据:第一个参数为指定的字段名,第二个参数为.selected,.selected 指定需要返回的属性
        query.whereKey(kTextCol, .selected)
        query.whereKey("\(kUserCol).\(kNickNameCol)", .selected)//一对多数据的链式调用(需included)
        query.whereKey("\(kUserCol).\(kAvatarCol)", .selected)//.selected 指定需要返回的属性
        query.whereKey(kUserCol, .included)
        query.find { res in
            self.hideLoadHUD()
            if case let .success(objects: comments) = res{
                print((comments[0].get(kUserCol) as! LCUser).get(kNickNameCol)?.stringValue)
                print((comments[0].get(kUserCol) as! LCUser).get(kAvatarCol) as! LCFile)
            }
        }
         */

        query.whereKey(kNoteCol, .equalTo(note))
        query.whereKey(kUserCol, .included)
        query.whereKey(kCreatedAtCol, .descending)
        query.limit = kCommentsOffset
        
        query.find { res in
            self.hideLoadHUD()
            switch res {
            case .success(objects: let comments):
                print("查询评论表成功, 存在comments: \(comments)")
                self.comments = comments
//                    self.getReplies()                //拿到所有的评论后再去取所有评论下的回复
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
//                if !comments.isEmpty {
//                    self.comments = comments
////                    self.getReplies()                //拿到所有的评论后再去取所有评论下的回复
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
//                }else{
//                    print("该笔记下的评论为空")
//                }
                
            case .failure(error: let error):
                print("查询评论表失败: \(error)")
            }
        }
    }
    
    
    
}
