//
//  MeVC-EditOrFollow.swift
//  pink
//
//  Created by gbt on 2022/11/11.
//
/*
    个人页面的编辑资料/关注按钮
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
            //在故事版的navi ‘is hero enable’改为true,或者 meVC.isHeroEnabled = true
            navi.heroModalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .pull(direction: .right))
            let editProfileTableVC = navi.topViewController as! EditProfileTableVC
            editProfileTableVC.user = user      //当前用户user传值给个人页面的‘编辑资料’-编辑页面
            editProfileTableVC.delegate = self  //遵守协议,反向传值到个人页面
            present(navi, animated: true)
        }else{
            if let _ = LCApplication.default.currentUser{
                //用户已登录
                showTextHUD("关注和取消关注功能")
            }else{
                showTextHUD("请先登录哦")
            }
        }
    }
}
