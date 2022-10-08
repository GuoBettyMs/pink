//
//  LoginVC.swift
//  pink
//
//  Created by isdt on 2022/10/8.
//
/*
     打开小粉书后,优先出现的登录界面
   
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
//        presentCodeLoginVC()
        #else
        localLogin()
        #endif
    }

}
