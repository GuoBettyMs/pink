//
//  NoteDetailVC-TVDataSource.swift
//  pink
//
//  Created by gbt on 2022/11/8.
//
/*
    详细笔记页面中,tableViewcell(对评论的回复view) 数据源
 */
import LeanCloud

extension NoteDetailVC: UITableViewDataSource{
    
    // MARK: 评论个数,相当于Sections个数
    func numberOfSections(in tableView: UITableView) -> Int {
        comments.count
    }
    
    // MARK: 显示回复个数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //可展开回复对象=ExpandableReplies,内置两个属性,1:回复是否已展开-isExpanded;2.这段里的所有回复-replies
        //这个可展开回复对象代表的就是每一段里的回复信息(包括isExpanded的flag和这段的所有回复),可通过replies[section]找到
        //默认isExpanded为false,即replies[section].isExpanded为false(也就是到详情页时回复为不展开状态)
        let replyCount = replies[section].replies.count
        if replyCount > 1 && !replies[section].isExpanded{
            //评论回复数大于1,并且展开按钮为false
            return 1
        }else{
            //评论回复数小于等于1,或者展开按钮为true
            return replyCount
        }

    }
    
    // MARK: 回复cell 的UI处理和手势事件
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kReplyCellID, for: indexPath) as! ReplyCell
        
        //单个回复对象
        let reply = replies[indexPath.section].replies[indexPath.row]
        
        //回复人对象
        let replyAuthor = reply.get(kUserCol) as? LCUser
        
        cell.reply = reply  //传到回复cell里去,用于展示评论下面的回复
        
        //判断回复人是否是笔记作者
        if let replyAuthor = replyAuthor, let noteAuthor = author, replyAuthor == noteAuthor{
            cell.authorL.isHidden = false
        }else{
            cell.authorL.isHidden = true
        }
        
        //轻触回复人头像或昵称,跳转到个人页面
        //1.子视图手势优先执行(故事版打开回复人头像或昵称的user interaction enabled)
        //2.手势的#selector函数传值:搞一个手势的子类,在子类中加个属性即可
        //3.<#注#> 一个手势识别器只可用于一个视图--文档不全,可以从他的view属性得以窥见.(而一个视图可以添加多个手势)
        let avatarTap = UIPassableTapGestureRecognizer(target: self, action: #selector(goToMeVC))
        avatarTap.passObj = replyAuthor   //传值:作者属性
        cell.avatarImgView.addGestureRecognizer(avatarTap)
        
        let nickNameTap = UIPassableTapGestureRecognizer(target: self, action: #selector(goToMeVC))
        nickNameTap.passObj = replyAuthor  //传值 作者属性
        cell.nickNameL.addGestureRecognizer(nickNameTap)
        
        
        //展开x条回复按钮
        let replyCount = replies[indexPath.section].replies.count
        if replyCount > 1, !replies[indexPath.section].isExpanded{
            cell.showAllReplyBtn.isHidden = false
            cell.showAllReplyBtn.setTitle("展示 \(replyCount - 1) 条回复", for: .normal)
            cell.showAllReplyBtn.tag = indexPath.section    //传递当前section 的索引
            cell.showAllReplyBtn.addTarget(self, action: #selector(showAllReply), for: .touchUpInside)
        }else{
            cell.showAllReplyBtn.isHidden = true
        }
        
        return cell
    }
    
    
}

extension NoteDetailVC{
    // MARK: 监听回复cell button - 展开详细回复
    @objc private func showAllReply(sender: UIButton){

        let section = sender.tag    //获取当前section 的索引
        //把这一段里的回复信息的isExpanded变为true,表明这些回复已展开
        replies[section].isExpanded = true
        //reloadSections后进numberOfRowsInSection判断,返回真正的行数,从而展示这段的所有回复
        noteTableView.performBatchUpdates {
            noteTableView.reloadSections(IndexSet(integer: section), with: .automatic)
        }

    }
}
