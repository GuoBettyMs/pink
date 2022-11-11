//
//  WaterfallVCCell-Like.swift
//  pink
//
//  Created by isdt on 2022/10/18.
//
/*
    笔记详情页瀑布流布局Cell - 首页点赞事件
 */

import LeanCloud
extension WaterfallCell{
    
    // MARK: 首页点赞事件
    @objc func likeBtnTappedWhenLogin(){
        //优化2:暴力点击时间内仅奇数次生效
        //只有当前点赞数量和最早时不一样时才进行云端操作(点偶数次不触发,奇数次才触发)
        //likedCount-负责UI的变化--点击后立刻变化
        //currentLikedCount-存储当前真正的值--隔1秒后经过判断才变化(偶数次不变化,奇数次才变)
        if likeCount != currentLikeCount{

            //authorObjectId 获取云端笔记作者的id标识符
            guard let note = note, let authorObjectId = (note.get(kAuthorCol) as? LCUser)?.objectId?.stringValue else { return }
            let user = LCApplication.default.currentUser!
            
            //currentLikeCount在实际点赞/取消点赞后也需要更新,为下一轮操作做准备,形成一个'闭环'(保持数据的统一性)
            //如(只讨论非暴力点击时):
            //likedCount和currentLikedCount初始为0-用户点赞-likedCount和currentLikedCount变为1-隔几秒取消点赞-likedCount变为0-触发这里-currentLikedCount也变为0--都正确的回到了原点
            //等同于 isLike ? (likeCount += 1) : (likeCount -= 1)
            let offset = isLike ? 1 : -1
            currentLikeCount += offset       
            
            if isLike{
                //userLike中间表
                let userLike = LCObject(className: kUserLikeTable)
                try? userLike.set(kUserCol, value: user)
                try? userLike.set(kNoteCol, value: note)
                userLike.save { _ in }
                //点赞数
                try? note.increase(kLikeCountCol)
                note.save{ _ in }
                
                //不能修改别人的user表字段,故里面不能放xxxCount这种,因为非这个用户本人是存不进去的(下同)
                //https://leancloud.cn/docs/leanstorage_guide-swift.html#hash1736273740
                LCObject.userInfoIncrease(where: authorObjectId, increase: kLikeCountCol)   //为userInfo表里面某个字段递增1
                
            }else{
                //userLike中间表
                let query = LCQuery(className: kUserLikeTable)
                query.whereKey(kUserCol, .equalTo(user))
                query.whereKey(kNoteCol, .equalTo(note))
                query.getFirst { res in
                    if case let .success(object: userLike) = res{
                        userLike.delete { _ in }
                    }
                }
                
                //点赞数
                try? note.set(kLikeCountCol, value: likeCount)
                note.save{ _ in }
                
                //不能修改别人的user表字段,故里面不能放xxxCount这种,因为非这个用户本人是存不进去的(下同)
                //https://leancloud.cn/docs/leanstorage_guide-swift.html#hash1736273740
                LCObject.userInfoDecrease(where: authorObjectId, decrease: kLikeCountCol, to: likeCount)    //为userInfo表里面某个字段递减1
            }
        }
        
    }
}
