//
//  PasswordLoginVC.swift
//  pink
//
//  Created by isdt on 2022/10/9.
//
/*
    手机密码登录
 */
import UIKit

class PasswordLoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: 退出手机密码界面
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: 跳转到验证码界面
    @IBAction func backToCodeLoginVC(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
