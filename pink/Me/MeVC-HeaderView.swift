//
//  MeVC-HeaderView.swift
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
        
        //头部视图rootStackView 约束
        meHeaderView.translatesAutoresizingMaskIntoConstraints = false
        //此处有小bug:页面往上推的时候会先折叠掉一部分(横滑tab会将“编辑按钮、设置按钮等”那行遮挡住)--可能是包的问题,待解决
        meHeaderView.heightAnchor.constraint(equalToConstant: meHeaderView.rootStackView.frame.height + 26).isActive = true     //rootStackView能够根据里面的 “个人简介”内容自动增加高度
        
        //传值
        meHeaderView.user = user

        //个人简介的左上角按钮的UI和action
        if isFromNote{
            meHeaderView.backOrDrawerBtn.setImage(largeIcon("chevron.left"), for: .normal)    //从笔记详情页跳转到个人页面时,更改左上角按钮原图标
        }
        meHeaderView.backOrDrawerBtn.addTarget(self, action: #selector(backOrDrawer), for: .touchUpInside)

        //个人简介的右下角按钮UI
        //情况1.登录用户查看自己的个人页面:编辑资料-设置 情况2.登录用户查看别人的个人页面:关注-聊天 情况3.未登录,看别的用户或自己的个人页面:关注-聊天
        if isMySelf{//登录后自己看自己(情况1)
            meHeaderView.introL.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editIntro)))//增加手势
        }else{//已登录看别人,未登录看自己或别人(情况2 & 情况3)
            //个人简介label--若空则不显示placeholder,直接隐藏
            if user.getExactStringVal(kIntroCol).isEmpty{
                meHeaderView.introL.isHidden = true
            }

            //关注按钮
            if let _ = LCApplication.default.currentUser{
                //情况2,若已登录需要判断是否已经关注此人--此处省略,仍显示关注字样
                meHeaderView.editOrFollowBtn.setTitle("关注", for: .normal)
                meHeaderView.editOrFollowBtn.backgroundColor = mainColor
            }else{
                //情况3
                meHeaderView.editOrFollowBtn.setTitle("关注", for: .normal)
                meHeaderView.editOrFollowBtn.backgroundColor = mainColor
            }

            //聊天按钮
            meHeaderView.settingOrChatBtn.setImage(fontIcon("ellipsis.bubble", fontSize: 13), for: .normal)
        }

        meHeaderView.editOrFollowBtn.addTarget(self, action: #selector(editOrFollow), for: .touchUpInside)//编辑资料按钮增加手势
        meHeaderView.settingOrChatBtn.addTarget(self, action: #selector(settingOrChat), for: .touchUpInside)//设置按钮增加手势

        return meHeaderView
    }
}


