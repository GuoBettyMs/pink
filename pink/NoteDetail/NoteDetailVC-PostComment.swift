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
            let commentText = textView.unwrappedText
            let comment = LCObject(className: kCommentTable)
            try comment.set(kTextCol, value: commentText)
            try comment.set(kUserCol, value: user)
            try comment.set(kNoteCol, value: note)
            comment.save { [self] res in //闭包里面增加[self],下面代码不用添加前缀 self
                
                if case .success = res{
                    sendPush(commentText) //用户发表成功后,传值评论内容,给笔记作者发送推动
                }
                
            }
            /* 发表评论后,即时显示,故无需再添加弹窗提示
            comment.save { res in
                if case .success = res{
                    self.showTextHUD("评论已发布")
                }
            }
             */

            //2.note表
            self.updateCommentCount(by: 1)//包含页面上的评论数变化的UI
//            try? self.note.increase(kCommentCountCol, by: 1)
//
//            //UI
//            self.commentCount += 1
            
            //内存数据
            comments.insert(comment, at: 0)         //最新评论放在第一条
            replies.insert(ExpandableReplies(replies: []), at: 0) //首次添加评论时没有回复信息,需要添加一个空的回复信息数组,否则会报错“replies[section].replies.count 为空”或者‘index of range’

            //UI
            noteTableView.performBatchUpdates {
                noteTableView.insertSections(IndexSet(integer: 0), with: .automatic)//将最新评论插入第一个section
            }
        } catch {
            print("给Comment表的字段赋值失败: \(error)")
        }
    }
    
    // MARK: 当有用户发布评论时给笔记作者发送推送
    private func sendPush(_ commentText: String){
        guard let author = author, let noteID = note.objectId?.stringValue else { return }
        
        let query = LCQuery(className: "_Installation")
        query.whereKey(kUserCol, .equalTo(author))//找到当前笔记的作者
        
        
        let alertDic = [
            "title": "\(author.getExactStringVal(kNickNameCol))对您的笔记发表了评论:",
            "body": commentText
        ]
        let payload: [String: Any] = [
            "alert": alertDic,//推送消息的文本内容
            "badge": "Increment",//应用图标右上角的数字。可以设置一个值或者递增当前值。
            "noteID": noteID //跳转到推送内容所在的笔记详情页
        ]

        //根据查询来推送消息,data 推送内容,query 查询条件
        LCPush.send(data: payload, query: query) { (result) in
            switch result {
            case .success:
                break
            case .failure(error: let error):
                print(error)
            }
        }
        
        
    }

}

