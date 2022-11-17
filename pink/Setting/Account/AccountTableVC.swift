//
//  AccountTableVC.swift
//  pink
//
//  Created by gbt on 2022/11/17.
//
/*
    个人页面的‘设置’页面 - ‘账号与安全’功能
    1.手机号登录判断
    2.第三方账号登录判断
 */
import UIKit
import LeanCloud

class AccountTableVC: UITableViewController {
    
    var user: LCUser!       //接收‘设置’页面的数据
    var phoneNumStr: String? { user.mobilePhoneNumber?.value }//mobilePhoneNumber是LC的内置属性
    var isSetPassword: Bool? { user.get(KIsSetPasswordCol)?.boolValue }
    
    @IBOutlet weak var phoneNumberL: UILabel!
    @IBOutlet weak var passwordL: UILabel!
    @IBOutlet weak var appleIDL: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let phoneNumStr = phoneNumStr{
            phoneNumberL.setToLight(phoneNumStr)
        }
        //获取云端密码,判断用户有没有设置过密码,有值就行
        if let _ = isSetPassword{
            passwordL.setToLight("已设置")
        }
        
        //第三方账号绑定
        if let authData = user.authData?.value{
            //判断字典中是否有某个key的两种方法:
            //1.authData["lc_apple"] != nil
            //2.如下
            let keys = authData.keys
            if keys.contains("lc_apple"){
                appleIDL.setToLight(user.getExactStringVal(kNickNameCol))
            }
            
            //其余第三方登录绑定的判断
            //https://leancloud.cn/docs/leanstorage_guide-swift.html#hash-1112893820
        }
    }

    // MARK: 给‘设置密码’传值
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let passwordTableVC = segue.destination as? PasswordTableVC{
            passwordTableVC.user = user
            if isSetPassword == nil{//用户未设置过密码,进入‘设置密码’,设置完毕返回时密码栏显示‘已设置’
                passwordTableVC.setPasswordfinished = { //获取到‘修改密码’页面的值,密码栏显示‘已设置’
                    self.passwordL.setToLight("已设置")
                }
            }
        }
    }
   
}
