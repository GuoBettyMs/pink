//
//   MeVC-HeaderView.swift
//  pink
//
//  Created by gbt on 2022/11/11.
//

/*
    个人主页的头部视图
 */

import LeanCloud

extension MeVC{
    
 //MARK: 设置头部视图
    func setHeaderView() -> UIView{
        let headerView = Bundle.loadView(fromNib: "MeHeaderView", with: MeHeaderView.self)
        //头部视图rootStackView 约束
        headerView.translatesAutoresizingMaskIntoConstraints = false
        //此处有小bug:页面往上推的时候会先折叠掉一部分(横滑tab会将“编辑按钮、设置按钮等”那行遮挡住)--可能是包的问题,待解决
        headerView.heightAnchor.constraint(equalToConstant: headerView.rootStackView.frame.height + 26).isActive = true     //rootStackView能够根据里面的 “个人简介”内容自动增加高度
        
        //传值
        headerView.user = user

        //左上角按钮的UI和action
        if isFromNote{
            headerView.backOrDrawerBtn.setImage(largeIcon("chevron.left"), for: .normal)    //从笔记详情页跳转到个人页面时,更改左上角按钮原图标
        }
        headerView.backOrDrawerBtn.addTarget(self, action: #selector(backOrDrawer), for: .touchUpInside)
//
//        //个人简介,编辑资料/关注,设置/聊天
//        if isMySelf{//登录后自己看自己
//            headerView.introL.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editIntro)))
//        }else{//已登录看别人,未登录看自己或别人
//            //个人简介label--若空则不显示placeholder,直接隐藏
//            if user.getExactStringVal(kIntroCol).isEmpty{
//                headerView.introL.isHidden = true
//            }
//
//            //关注按钮
//            if let _ = LCApplication.default.currentUser{
//                //若已登录需要判断是否已经关注此人--此处省略,仍显示关注字样
//                headerView.editOrFollowBtn.setTitle("关注", for: .normal)
//                headerView.editOrFollowBtn.backgroundColor = mainColor
//            }else{
//                headerView.editOrFollowBtn.setTitle("关注", for: .normal)
//                headerView.editOrFollowBtn.backgroundColor = mainColor
//            }
//
//            //聊天按钮
//            headerView.settingOrChatBtn.setImage(fontIcon("ellipsis.bubble", fontSize: 13), for: .normal)
//        }
//
//        headerView.editOrFollowBtn.addTarget(self, action: #selector(editOrFollow), for: .touchUpInside)
//        headerView.settingOrChatBtn.addTarget(self, action: #selector(settingOrChat), for: .touchUpInside)

        return headerView
    }
}


extension MeVC: IntroVCDelegate{
    // MARK: 遵守IntroVCDelegate - 更新个人简介
    func updateIntro(_ intro: String) {
        //UI
        meHeaderView.introL.text = intro.isEmpty ? kIntroPH : intro
        //云端
        try? user.set(kIntroCol, value: intro)
        user.save{ _ in }
    }
}

