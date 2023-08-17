//
//  SocialLoginVC.swift
//  pink
//
//  Created by isdt on 2022/10/9.
//
/*
     <#注:使用第三方登录时只能使用应用的真实ID,不能使用沙箱的虚拟ID#>
        <#登录时要用到privateKey 放客户端风险很大,故实际开发需在服务端sign(加签),然后传回客户端#>
     第三方登录界面: 支付宝登录 或者 苹果登录

 */
import UIKit
import AuthenticationServices       //身体验证服务
import LeanCloud

class SocialLoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: 支付宝登录
    @IBAction func signInWithAlipay(_ sender: Any) {
        signInWithAlipay()
    }
    
    // MARK: 苹果登录
    // <#只有收费的苹果账号才能使用 sign in with apple 能力#>
    @IBAction func signInWithApple(_ sender: Any) {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.email, .fullName]               //AppleID登录时显示姓名和电子邮箱
        
        let controller = ASAuthorizationController(authorizationRequests: [request])        //登录页面
        controller.delegate = self                      //获取用户信息
        controller.presentationContextProvider = self   //获取UI
        controller.performRequests()                    //执行请求
    }
    
}
