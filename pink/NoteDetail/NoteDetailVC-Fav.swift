//
//  NoteDetailVC-Fav.swift
//  pink
//
//  Created by isdt on 2022/10/18.
//
/*
    详细笔记页面的收藏Fav事件
 */
import LeanCloud

extension NoteDetailVC{
    // MARK: 获取详情页收藏数量
    func fav(){
        //判断用户是否登录
        if let _ = LCApplication.default.currentUser{
            //UI
            isFav ? (favCount += 1) : (favCount -= 1)
            
            //数据
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(favBtnTappedWhenLogin), object: nil)
            perform(#selector(favBtnTappedWhenLogin), with: nil, afterDelay: 1)
            
        }else{
            showTextHUD("请先登录哦")
        }
    }
    
    // MARK: 监听 - 收藏点击事件
    @objc private func favBtnTappedWhenLogin(){
        //优化2:暴力点击时间内仅奇数次生效
        //只有当前点赞数量和最早时不一样时才进行云端操作(点偶数次不触发,奇数次才触发)
        //favCount-负责UI的变化--点击后立刻变化
        //currentFavCount-存储当前真正的值--隔1秒后经过判断才变化(偶数次不变化,奇数次才变)
        if favCount != currentFavCount{
            let user = LCApplication.default.currentUser!
            let authorObjectId = author?.objectId?.stringValue ?? ""          //获取云端笔记作者的id标识符
            
            //currentFavCount在实际点赞/取消点赞后也需要更新,为下一轮操作做准备,形成一个'闭环'(保持数据的统一性)
            //如(只讨论非暴力点击时):
            //favCount和currentFavCount初始为0-用户点赞-favCount和currentFavCount变为1-隔几秒取消点赞-favCount变为0-触发这里-currentFavCount也变为0--都正确的回到了原点
            //等同于 isFav ? (favCount += 1) : (favCount -= 1)
            let offset = isFav ? 1 : -1
            currentFavCount += offset
            
            //用户点击了点赞按钮,点赞数量保存到中间表(即点赞笔记云端表kUserFavTable)
            if isFav{
                let userFav = LCObject(className: kUserFavTable)      //userFav中间表
                try? userFav.set(kUserCol, value: user)                //将当前用户赋给点赞笔记云端表kUserFavTable的用户字段
                try? userFav.set(kNoteCol, value: note)                //将当前用户赋给点赞笔记云端表kUserFavTable的笔记字段
                userFav.save{ _ in }
                
                //点赞数量递增1
                try? note.increase(kFavCountCol)
                note.save { _ in }
                
                //不能修改别人的user表字段,故里面不能放xxxCount这种,因为非这个用户本人是存不进去的(下同)
                //https://leancloud.cn/docs/leanstorage_guide-swift.html#hash1736273740
                LCObject.userInfoIncrease(where: authorObjectId, increase: kFavCountCol)    //为userInfo表里面某个字段递增1
                
            }else{
                let query = LCQuery(className: kUserFavTable)
                query.whereKey(kUserCol, .equalTo(user))                //对比当前用户与云端的用户字段是否相等
                query.whereKey(kNoteCol, .equalTo(note))                //对比当前笔记与云端的笔记字段是否相等
                query.getFirst { res in
                    if case let .success(object: userFav) = res {
                        userFav.delete { _ in
                        }
                    }
                }
                
                //点赞数量递减1
                try? note.set(kFavCountCol, value: favCount)
                note.save{ _ in }
                
                //不能修改别人的user表字段,故里面不能放xxxCount这种,因为非这个用户本人是存不进去的(下同)
                //https://leancloud.cn/docs/leanstorage_guide-swift.html#hash1736273740
                LCObject.userInfoDecrease(where: authorObjectId, decrease: kFavCountCol, to: favCount)  //为userInfo表里面某个字段递减1
            }
        }

    }
}
