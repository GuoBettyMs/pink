//
//  MeVC-EditOrFollow.swift
//  pink
//
//  Created by gbt on 2022/11/11.
//
/*
 编辑资料/关注
 */
import LeanCloud

extension MeVC{
    
    // MARK: 监听 - 编辑资料/关注
    @objc func editOrFollow(){
        if isMySelf{
            //编辑资料
            let navi = storyboard!.instantiateViewController(identifier: kEditProfileNaviID) as! UINavigationController
            navi.modalPresentationStyle = .fullScreen

            //把系统自带的转场动画改成push和pop动画
//            navi.heroModalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .pull(direction: .right))
//            let editProfileTableVC = navi.topViewController as! EditProfileTableVC
//            editProfileTableVC.user = user
//            editProfileTableVC.delegate = self
//            present(navi, animated: true)
        }else{
            if let _ = LCApplication.default.currentUser{
                print("关注和取消关注功能")
            }else{
                showTextHUD("请先登录哦")
            }
        }
    }
}
