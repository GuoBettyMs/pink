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
        query.whereKey(kCreatedAtCol, .descending)//排序
        query.limit = kCommentsOffset
        
        query.find { res in
            self.hideLoadHUD()
            switch res {
            case .success(objects: let comments):
//                print("查询评论表成功, 存在comments: \(comments)")
                self.comments = comments
                self.getReplies()                //拿到所有的评论后再去取所有评论下的回复

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
    
    // MARK: 获取评论下的回复
    //1.定义一个字典型的回复数据 repliesDic: [Int: [LCObject]] = [:]
    //2.遍历评论数据,得到评论下的回复数据,整合成一个无序的回复数据字典 repliesDic[index] = replies
    //3.排序回复数据字典 sorted、 map
    func getReplies(){
        //希望最后得到的顺序: [["回复对象","回复对象"], [], ["回复对象"]]
        var repliesDic: [Int: [LCObject]] = [:]//无序的回复数据,类型为字典
        let group = DispatchGroup()
        
        //循环查询评论数据
        for (index, comment) in comments.enumerated(){
            /*
            情况1,查询不到云端评论表的hasReply字段,不知道这条评论下究竟有没有回复,需去云端继续查询回复 ->  LCQuery
            情况2,查询到hasReply字段,并且hasReply字段为true(true说明有回复),需去云端继续查询回复 ->   LCQuery
            情况3,查询到hasReply字段,并且hasReply字段为false(false说明没有回复),无需去云端继续查询 ->  回复数组为空
            comment.get(kHasReplyCol)?.boolValue == nil || (comment.get(kHasReplyCol)?.boolValue != nil && comment.get(kHasReplyCol)?.boolValue == true)
            */
            //getExactBoolValDefaultT(kHasReplyCol),kHasReplyCol值决定进不进入LCQuery(符合情况2和情况3),若查询不到kHasReplyCol字段则返回true,进入LCQuery(className: kReplyTable)(符合情况1)
            if comment.getExactBoolValDefaultT(kHasReplyCol){
//                print("情况1或者2,没有字段或者有回复")
                group.enter()
                let query = LCQuery(className: kReplyTable)
                query.whereKey(kCommentCol, .equalTo(comment))
                query.whereKey(kUserCol, .included)//查询用户字段
                query.whereKey(kReplyToUserCol, .included)//查询被回复人字段
                query.whereKey(kCreatedAtCol, .ascending)//排序
                
                query.find { res in
                    if case let .success(objects: replies) = res{
//                        print("云端查询回复内容成功,repliesDic 赋值")
                        //若这条评论下的回复都被删光时(情况较少),需重置hasReply,把这条评论的hasReply字段设为false,方便下一次回复的查询
                        if replies.isEmpty{
                            try? comment.set(kHasReplyCol, value: false)
                            comment.save{ _ in }
                        }
                        repliesDic[index] = replies
                    }else{
//                        print("云端查询回复内容失败,repliesDic 置空")
                        repliesDic[index] = []//使comments数量和repliesDic数量保持一致
                    }
                    group.leave()
                }
            }else{
//                print("情况3:查询到字段,没有回复,repliesDic 置空")
                repliesDic[index] = []
            }
        }
        
        //对回复数据进行排序
        group.notify(queue: .main) {
            //因这次的字典里面的value是数组类型,数组并为遵循Comparable协议,故不能直接用'by: <'这种用法
            //repliesDic:  [3: ["回复对象"], 2: [], 1: ["回复对象","回复对象"]]
            //sorted时:  [(key: 3, value: ["回复对象"]), (key: 2, value: []), (key: 1, value: ["回复对象","回复对象"])]
            //sorted后:  [(key: 1, value: ["回复对象","回复对象"]), (key: 2, value: []), (key: 3, value: ["回复对象"]),]
//            self.replies = repliesDic.sorted{ $0.key < $1.key }.map{ $0.value }//map后:  [["回复对象","回复对象"], [], ["回复对象"]]

            self.replies = repliesDic.sorted{ $0.key < $1.key }.map{ ExpandableReplies(replies: $0.value) }//map后:  ["可展开回复对象", "可展开回复对象", "可展开回复对象"]

            //刷新列表
            DispatchQueue.main.async {
                self.noteTableView.reloadData()
            }
        }
    }
    
    // MARK: 获取收藏笔记
    func getFav(){
        if let user = LCApplication.default.currentUser{
            let query = LCQuery(className: kUserFavTable)
            query.whereKey(kUserCol, .equalTo(user))
            query.whereKey(kNoteCol, .equalTo(note))
            query.getFirst { res in
                if case .success = res{
                    DispatchQueue.main.async {
                        self.favBtn.setSelected(selected: true, animated: false)
                    }
                }
            }
        }
    }
    
}
