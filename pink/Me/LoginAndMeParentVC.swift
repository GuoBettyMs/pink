//
//  LoginAndMeParentVC.swift
//  pink
//
//  Created by isdt on 2022/10/8.
//
/*
    选择“个人”界面或者“登录”界面
 */
import UIKit
import LeanCloud

var loginAndMeParentVC = UIViewController()

class LoginAndMeParentVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //检查用户是否已经本地登录过
        if LCApplication.default.currentUser != nil {
            let meVC = storyboard!.instantiateViewController(identifier: kMeVCID)
            add(child: meVC)                //跳转到“个人”界面
        } else {
            let loginVC = storyboard!.instantiateViewController(identifier: kLoginVCID)
            add(child: loginVC)             //跳转到“登录”界面
        }
        
        loginAndMeParentVC = self           //用一个强引用保存当前这个父vc,方便在登录和退出时找到正确的父vc
    }


}
