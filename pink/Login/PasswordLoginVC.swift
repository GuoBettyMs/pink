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
import LeanCloud

class PasswordLoginVC: UIViewController {

    //转为string类型
    private var phoneNumStr: String { phoneNumTF.unwrappedText }
    private var passwordStr: String { passwordTF.unwrappedText }
    
    @IBOutlet weak var phoneNumTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()              //点击空白处收起键盘
        loginBtn.setToDisabled()                    //设置登录按钮为不可点击状态
    }

    // MARK: 退出手机密码界面
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        phoneNumTF.becomeFirstResponder()               //弹出软键盘
    }

    
    // MARK: 退出登录
    @IBAction func back(_ sender: Any) { dismiss(animated: true)}
    
    // MARK: 跳转到验证码界面
    @IBAction func backToCodeLoginVC(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func TFEditChanged(_ sender: UITextField) {

        if phoneNumStr.isPhoneNum && passwordStr.isPassword{
            loginBtn.setToEnabled()
        }else{
            loginBtn.setToDisabled()
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
        view.endEditing(true)
        
        showLoadHUD()
        //账户锁定
        LCUser.logIn(mobilePhoneNumber: phoneNumStr, password: passwordStr){ result in
            switch result {
            case let .success(object: user):
                self.dismissAndShowMeVC(user)
            case let .failure(error: error):
                self.hideLoadHUD()
                //UI操作,在主线程执行,若不在主线程完成,后台执行showTextHUD时会出现卡顿
                DispatchQueue.main.async {
                    self.showTextHUD("密码登录失败", true, error.reason)     //若界面不需要发生跳转,选true
                }
            }
        }
    }
}

extension PasswordLoginVC: UITextFieldDelegate{
    
    // MARK: 遵守UITextFieldDelegate  - 限制手机号码\密码数量
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //range.location--当前输入的字符或粘贴文本的第一个字符的索引
        //string--当前输入的字符或粘贴的文本
        let limit = textField == phoneNumTF ? 11 : 16
        let isExceed = range.location >= 11 || (textField.unwrappedText.count + string.count) > limit
        if isExceed{
            showTextHUD("最多只能输入\(limit)位哦")
        }
        return !isExceed
    }
    
    
    // MARK: 遵守UITextFieldDelegate - 当软键盘为默认键盘时,对returnKey的处理
    //点击returnKey后对UITextField的字母简单判断
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        switch textField{
            case phoneNumTF:
                passwordTF.becomeFirstResponder()
            default:
                if loginBtn.isEnabled{ login(loginBtn)}
        }
        
        return true
    }
}
