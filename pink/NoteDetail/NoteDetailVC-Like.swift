//
//  NoteDetailVC-Like.swift
//  pink
//
//  Created by isdt on 2022/10/18.
//
/*
    详细笔记页面的点赞Like事件
 
 */
import LeanCloud

extension NoteDetailVC{
    
    // MARK: 监听 - 点赞事件
    func like(){
        //判断用户是否登录
        if let _ = LCApplication.default.currentUser{

            //UI,点击点赞按钮,点赞数量递增1,再次点击,点赞数量递减1
            isLike ? (likeCount += 1) : (likeCount -= 1)
            
            //数据
            //优化1:防暴力点击
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(likeBtnTappedWhenLogin), object: nil)
            perform(#selector(likeBtnTappedWhenLogin), with: nil, afterDelay: 1)
        }else{
            showTextHUD("请先登录哦")
        }
    }
    
    @objc private func likeBtnTappedWhenLogin(){
        //优化2:暴力点击时间内仅奇数次生效
        //只有当前点赞数量和最早时不一样时才进行云端操作(点偶数次不触发,奇数次才触发)
        //likedCount-负责UI的变化--点击后立刻变化
        //currentLikedCount-存储当前真正的值--隔1秒后经过判断才变化(偶数次不变化,奇数次才变)
        if likeCount != currentLikeCount{
            let user = LCApplication.default.currentUser!
            let authorObjectId = author?.objectId?.stringValue ?? ""
            
            //currentLikeCount在实际点赞/取消点赞后也需要更新,为下一轮操作做准备,形成一个'闭环'(保持数据的统一性)
            //如(只讨论非暴力点击时):
            //likedCount和currentLikedCount初始为0-用户点赞-likedCount和currentLikedCount变为1-隔几秒取消点赞-likedCount变为0-触发这里-currentLikedCount也变为0--都正确的回到了原点
            //等同于 isLike ? (likeCount += 1) : (likeCount -= 1)
            let offset = isLike ? 1 : -1
            currentLikeCount += offset
            
            //用户点击了点赞按钮,点赞数量保存到中间表(即点赞笔记云端表kUserLikeTable)
            if isLike{
                let userLike = LCObject(className: kUserLikeTable)      //userLike中间表
                try? userLike.set(kUserCol, value: user)                //将当前用户赋给点赞笔记云端表kUserLikeTable的用户字段
                try? userLike.set(kNoteCol, value: note)                //将当前用户赋给点赞笔记云端表kUserLikeTable的笔记字段
                userLike.save{ _ in }
                
                //点赞数量递增1
                try? note.increase(kLikeCountCol)
                //不能修改别人的user表字段,故里面不能放xxxCount这种,因为非这个用户本人是存不进去的(下同)
                //https://leancloud.cn/docs/leanstorage_guide-swift.html#hash1736273740
                LCObject.userInfoIncrease(where: authorObjectId, increase: kLikeCountCol)
                
            }else{
                let query = LCQuery(className: kUserLikeTable)
                query.whereKey(kUserCol, .equalTo(user))                //对比当前用户与云端的用户字段是否相等
                query.whereKey(kNoteCol, .equalTo(note))                //对比当前笔记与云端的笔记字段是否相等
                query.getFirst { res in
                    if case let .success(object: UserLike) = res {
                        UserLike.delete { _ in
                        }
                    }
                }
                
                //点赞数量递减1
                try? note.set(kLikeCountCol, value: likeCount)
                note.save{ _ in }
                //不能修改别人的user表字段,故里面不能放xxxCount这种,因为非这个用户本人是存不进去的(下同)
                //https://leancloud.cn/docs/leanstorage_guide-swift.html#hash1736273740
                LCObject.userInfoDecrease(where: authorObjectId, decrease: kLikeCountCol, to: likeCount)
            }
        }

    }
    
}
