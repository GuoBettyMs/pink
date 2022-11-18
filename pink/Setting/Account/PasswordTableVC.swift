//
//  PasswordTableVC.swift
//  pink
//
//  Created by gbt on 2022/11/17.
//
/*
    个人页面的‘设置’页面 - ‘账号与安全’功能 -> 修改密码
 */
import UIKit
import LeanCloud

class PasswordTableVC: UITableViewController {

    var user: LCUser!      //接收‘账号与安全’页面的数据
    var setPasswordfinished: (() -> ())?    //反向传值到‘账号与安全’页面,密码栏显示‘已设置’
    
    private var passwordStr: String{ passwordTF.unwrappedText}
    private var confirmPasswordStr: String {confirmPasswordTF.unwrappedText}
    
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordTF.becomeFirstResponder() //聚焦到‘修改密码’文本框
    }

    @IBAction func done(_ sender: UIButton) {
        if passwordStr.isPassword && confirmPasswordStr.isPassword{
            //满足密码的规范性
            if passwordStr == confirmPasswordStr{//两次密码一致
                //保存密码到云端
                user.password = LCString(passwordStr)
                try? user.set(kIsSetPasswordCol, value: true)
                user.save{ _ in }
                
                //UI
                dismiss(animated: true)
                setPasswordfinished?()
            }else{
                showTextHUD("两次密码不一致")
            }
        }else{
            showTextHUD("密码必须为6-16位的数字或字母")
        }
    }
    
    // MARK: ‘完成’按钮UI
    @IBAction func TFEditChanged(_ sender: Any) {
        if passwordTF.isBlank || confirmPasswordTF.isBlank{
            doneBtn.isEnabled = false
        }else{
            doneBtn.isEnabled = true
        }
    }
    
    
}

extension PasswordTableVC: UITextFieldDelegate{
    // MARK: 点下’完成‘按钮后的处理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case passwordTF:
            confirmPasswordTF.becomeFirstResponder()
        default:
            if doneBtn.isEnabled{
                done(doneBtn)
            }
        }
        return true
    }
}

