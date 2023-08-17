//
//  NoteDetailVC-MeVC.swift
//  pink
//
//  Created by gbt on 2022/11/11.
//
/*
    笔记详情页 跳转到 个人页面
 */
import LeanCloud
import Hero

extension NoteDetailVC{
    
    // MARK: 笔记详情页 跳转到 个人页面
    func noteToMeVC(_ user: LCUser?){
        guard let user = user else { return }
        
        //从个人页面的cell跳转到笔记详情页后,若作者相同,从笔记详情页跳转到个人页面时,应dismiss笔记详情页
        if isFromMeVC, let fromMeVCUser = fromMeVCUser, fromMeVCUser == user{
            dismiss(animated: true)
        }else{
            let meVC = storyboard!.instantiateViewController(identifier: kMeVCID) { coder in
                MeVC(coder: coder, user: user)
            }
            meVC.isFromNote = true  //实现左上角按钮的新UI和新action

           //更新个人信息的‘获赞与收藏’
            guard let userObjectId =  user.objectId?.stringValue else { return }
            let query = LCQuery(className: kUserInfoTable)
            query.whereKey(kUserObjectIdCol, .equalTo(userObjectId))        //查询云端上的用户标记符kUserObjectIdCol是否与userObjectId相等
            query.getFirst { res in
                if case let .success(object: userInfo) = res{
                    let likeCount = userInfo.getExactIntVal(kLikeCountCol)      //获取云端个人信息表的点赞数
                    let favCount = userInfo.getExactIntVal(kFavCountCol)        //获取云端个人信息表的收藏数
                    DispatchQueue.main.async {
                        meVC.meHeaderView.likedAndFavedL.text = "\(likeCount + favCount)"
                    }
                }
            }
            
            
            meVC.modalPresentationStyle = .fullScreen
            
            //把系统转场动画present、dismiss转换为push\pop动画
            //在故事版的MeVC ‘is hero enable’改为true,或者 meVC.isHeroEnabled = true
            meVC.heroModalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .pull(direction: .right))
            present(meVC, animated: true)
            
        }
    }
    
    // MARK: 子视图手势事件
    @objc func goToMeVC(_ tap: UIPassableTapGestureRecognizer){
        let user = tap.passObj  //获取到手势传过来的对象属性
        noteToMeVC(user)        //将对象属性传到跳转函数noteToMeVC()
    }
}
