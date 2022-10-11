//
//  LoginVC.swift
//  pink
//
//  Created by isdt on 2022/10/8.
//
/*
     <#注:一键登录时可以使用应用的真实ID,也可以使用沙箱的虚拟ID#>
     个人本地登录界面: 手机密码登录 或者 验证码登录
     1.创建极光账号,详情见https://docs.jiguang.cn/jverification/guideline/intro
       在极光认证平台创建应用+开发者认证+开通一键登录功能
     2.支付宝开放平台开发助手,详情见https://opendocs.alipay.com/common/02kipk
       生成极光认证平台所需的RSA密钥,保存为 “应用公钥1024.txt” 和 “应用私钥1024.txt”
 */
import UIKit

class LoginVC: UIViewController {

    lazy private var loginButton: UIButton = {
       let btn = UIButton()
        btn.setTitle("登录", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = mainColor
        btn.layer.cornerRadius = 22
        btn.addTarget(self, action: #selector(login), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(loginButton)
        setUI()
    }
    
    // MARK: UI - 设置约束
    private func setUI(){
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    // MARK: 监听 - 登录事件
    @objc private func login(){
        #if targetEnvironment(simulator)
        presentCodeLoginVC()                //模拟器运行
        #else
        localLogin()                        //真机运行
        #endif
    }

}
