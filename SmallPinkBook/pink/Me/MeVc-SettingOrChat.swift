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
            let settingTableVC = storyboard!.instantiateViewController(identifier: kSettingTableVCID) as! SettingTableVC
            settingTableVC.user = user //个人页面的数据传值给‘设置’页面
            present(settingTableVC, animated: true)
        }else{
            if let _ = LCApplication.default.currentUser{
                //用户已登录
                showTextHUD("私信功能")
            }else{
                showTextHUD("请先登录哦")
            }
        }
    }
}

