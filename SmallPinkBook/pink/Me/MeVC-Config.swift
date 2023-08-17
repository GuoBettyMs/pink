//
//  MeVC-Config.swift
//  pink
//
//  Created by gbt on 2022/11/11.
//
/*
    个人主页的属性
 */
import LeanCloud

extension MeVC{
    func config(){
        //iOS14之前去掉返回按钮文本的话需:
        //1.sb上:上一个vc(MeVC)的navigationitem中修改为空格字符串串
        //2.代码:上一个vc(此页)navigationItem.backButtonTitle = ""
        navigationItem.backButtonDisplayMode = .minimal

        //判断:1.用户是否已登录 2.当前用户currentUser是笔记作者user
        if let user = LCApplication.default.currentUser, user == self.user{
            isMySelf = true
        }
        
        
    }
}
