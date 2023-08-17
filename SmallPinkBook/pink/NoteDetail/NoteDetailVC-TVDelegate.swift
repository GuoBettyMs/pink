//
//  NoteDetailVC-TVDelegate.swift
//  pink
//
//  Created by gbt on 2022/11/8.
//
/*
    详细笔记页面中,tableViewCell(对评论的回复view) 协议
   
 */
import LeanCloud

extension NoteDetailVC: UITableViewDelegate{
    
    // MARK: sectionHeader(评论View)- 删除评论不会自动
    //<#注#>tableViewCell是对评论的回复view,评论view是回复view的header
    // <#注#> 删除评论后不会再更新viewForHeaderInSection 里的section,故删除后再去回复会报错
    //而回复和添加评论会实时更新viewForHeaderInSection 里的section
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let commentView = tableView.dequeueReusableHeaderFooterView(withIdentifier: kCommentViewID) as! CommentView
        
        //单个的评论对象
        let comment = comments[section]

        //评论人对象
        let commentAuthor = comment.get(kUserCol) as? LCUser

        //传到评论view里去,用于展示评论
        commentView.comment = comment

        //作者标签-判断评论人commentAuthor是否是笔记作者commentAuthor
        if let commentAuthor = commentAuthor, let noteAuthor = author, commentAuthor == noteAuthor{
            commentView.authorL.isHidden = false
        }else{
            commentView.authorL.isHidden = true
        }
        
        //轻触评论,评论View增加轻触手势
        let commentTap = UITapGestureRecognizer(target: self, action: #selector(commentTapped))
        commentView.tag = section//传递section值
        commentView.addGestureRecognizer(commentTap)
        
        //轻触评论人头像或昵称,跳转到个人页面
        //1.子视图手势优先执行(故事版打开评论人头像或昵称的user interaction enabled)
        //2.手势的#selector函数传值:搞一个手势的子类,在子类中加个属性即可
        //3.<#注#> 一个手势识别器只可用于一个视图--文档不全,可以从他的view属性得以窥见.(而一个视图可以添加多个手势)
        let avatarTap = UIPassableTapGestureRecognizer(target: self, action: #selector(goToMeVC))
        avatarTap.passObj = commentAuthor   //传值:作者属性
        commentView.avatarImgView.addGestureRecognizer(avatarTap)
        
        let nickNameTap = UIPassableTapGestureRecognizer(target: self, action: #selector(goToMeVC))
        nickNameTap.passObj = commentAuthor  //传值 作者属性
        commentView.nickNameL.addGestureRecognizer(nickNameTap)
        
        return commentView
    }
    
    // MARK: sectionFooter
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let separatorLine = tableView.dequeueReusableHeaderFooterView(withIdentifier: kCommentSectionFooterViewID)
        return separatorLine
    }
    
    // MARK: 监听回复cell - 复制或删除或回复
    //用户按下评论的回复cell后,对这个回复进行复制或删除或再回复
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //点击cell时,取消高亮效果,可在故事版修改
//            tableView.deselectRow(at: indexPath, animated: true)
        
        if let user = LCApplication.default.currentUser{
            let reply = replies[indexPath.section].replies[indexPath.row]
            
            guard let replyAuthor = reply.get(kUserCol) as? LCUser else { return }
            let replyAuthorNickName = replyAuthor.getExactStringVal(kNickNameCol)
            
            //当前登录用户点击自己发布的回复
            if user == replyAuthor {
                let replyText = reply.getExactStringVal(kTextCol)
                
                let alert = UIAlertController(title: nil, message: "你的回复: \(replyText)", preferredStyle: .actionSheet)
                let subReplyAction = UIAlertAction(title: "回复", style: .default) { _ in
                    self.prepareForReply(replyAuthorNickName, indexPath.section, replyAuthor)
                }
                let copyAction = UIAlertAction(title: "复制", style: .default) { _ in
                    UIPasteboard.general.string = replyText
                }
                let deleteAction = UIAlertAction(title: "删除", style: .destructive) { _ in
                    self.delReply(reply, indexPath)
                }
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                
                alert.addAction(subReplyAction)
                alert.addAction(copyAction)
                alert.addAction(deleteAction)
                alert.addAction(cancelAction)
                
                present(alert, animated: true)
            }else{//当前登录用户点击别人发布的回复--回复这个回复
                self.prepareForReply(replyAuthorNickName, indexPath.section, replyAuthor)
            }
     
        }else{
            showTextHUD("请先登录哦")
        }
    }

    
}


extension NoteDetailVC{
    
    // MARK: 监听评论cell - 复制或删除或回复
    //用户按下笔记的评论后,对这个评论进行复制或删除或回复
    @objc private func commentTapped(_ tap: UITapGestureRecognizer){
        if let user = LCApplication.default.currentUser{

            guard let section = tap.view?.tag else { return }//获取section值-当前点击的View所对应的tag
            let comment = comments[section]
            //获取到评论人
            guard let commentAuthor = comment.get(kUserCol) as? LCUser else { return }
            let commentAuthorNickName = commentAuthor.getExactStringVal(kNickNameCol)
            
            //当前登录用户点击自己发布的评论
            if user == commentAuthor{
                let commentText = comment.getExactStringVal(kTextCol)
                let alert = UIAlertController(title: nil, message: "你的评论: \(commentText)", preferredStyle: .actionSheet)
                let replyAction = UIAlertAction(title: "回复", style: .default) { _ in
                    self.prepareForReply(commentAuthorNickName, section)
                }
                
                //修改replyAction文本颜色
//                replyAction.setTitleColor(.yellow)
//                replyAction.titleTextColor = .yellow
                
                let copyAction = UIAlertAction(title: "复制", style: .default) { _ in
                    UIPasteboard.general.string = commentText//将评论放在粘贴板UIPasteboard.general.string
                }
                
               // <#注#> 删除评论后不会再更新viewForHeaderInSection 里的section,故删除后再去回复会报错
                //而回复和添加评论会实时更新viewForHeaderInSection 里的section
                let deleteAction = UIAlertAction(title: "删除", style: .destructive) { _ in
                    self.delComment(comment, section)
                }
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                alert.addAction(replyAction)
                alert.addAction(copyAction)
                alert.addAction(deleteAction)
                alert.addAction(cancelAction)
                present(alert, animated: true)
            }else{//当前登录用户点击别人发布的评论--回复评论
                prepareForReply(commentAuthorNickName, section)
            }
        }else{
            showTextHUD("请先登录哦")
        }
    }
}
