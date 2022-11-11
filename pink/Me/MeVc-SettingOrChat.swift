//
//  MeVc-SettingOrChat.swift
//  pink
//
//  Created by gbt on 2022/11/11.
//
/*
    设置/聊天
 */
import LeanCloud

extension MeVC{
    // MARK: 监听 - 设置/聊天
    @objc func settingOrChat(){
        if isMySelf{//设置
//            let settingTableVC = storyboard!.instantiateViewController(identifier: kSettingTableVCID) as! SettingTableVC
//            settingTableVC.user = user
//            present(settingTableVC, animated: true)
        }else{
            if let _ = LCApplication.default.currentUser{
                print("私信功能")
            }else{
                showTextHUD("请先登录哦")
            }
        }
    }
}

