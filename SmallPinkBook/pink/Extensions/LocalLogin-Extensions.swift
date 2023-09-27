//
//  LocalLogin-Extensions.swift
//  pink
//
//  Created by isdt on 2022/10/8.
//
/*
     扩展 - 本地个人登录界面: 手机密码登录 或者 验证码登录界面.只能用于真机调试
 */

import Foundation
import Alamofire
import LeanCloud

extension UIViewController{
    
    /// - Returns:
    /// 手机号码登录或者验证码登录
    func localLogin(){
        
        showLoadHUD()
        let config = JVAuthConfig()         //JVAuthConfig类，应用配置信息类
        config.appKey = kJAppKey
        config.authBlock = { _ in

            //获取初始化状态
            if JVERIFICATIONService.isSetupClient(){

                //预取号（只能用于真机调试,可验证当前运营商网络是否可以进行一键登录操作）preLogin 方法缓存取号信息 5s后超时
                JVERIFICATIONService.preLogin(10000) { (result) in
//                    print(result)  //字典result 有两个Key: Code、content
                    self.hideLoadHUD()

                    //当code = 7000时表示当前网络环境可以发起认证,当前设备可使用一键登录
                    if let result = result, let code = result["code"] as? Int, code == 7000 {
                        self.setLocalLoginUI()
                        self.presentLocalLoginVC()      //预取手机号码一键登录
                    }else{
                        print("预取号失败,当前设备不可使用一键登录")
                        self.presentCodeLoginVC()      //验证码登录
                    }
                }
            }else{
                self.hideLoadHUD()
                print("初始化状态失败,无法一键登录")
                self.presentCodeLoginVC()              //验证码登录
            }
        }

        /* isSetupClient()等同于
        config.authBlock = { (result) -> Void in
                if let result = result {
                 if let code = result["code"], let content = result["content"] {
                    print("初始化结果 result: code = \(code), content = \(content)")
                    }
                }
            }
         */

        JVERIFICATIONService.setup(with: config)        //初始化JVAuthConfig类接口
        
    }

}


// MARK: - 一键登录
extension UIViewController{
 
    //1.loginToken发送到服务端,Master Secret存到服务端
    //2.服务端进行HTTP 基本认证
    //3.若loginToken与调用运营商一键登录接口查询到的号码一致,返回被公钥加密后的用户手机号
    //4.在服务端继续解密,得出明文手机号
    //5.向客户端返回登录成功的信息,供客户端查询明文手机号
    func getEncryptedPhoneNum_ServiceSlide(_ loginToken: String){
        
        let requestAddressUrl = kServer_LoginReqAddUrl_Jiguang
        let parameters = ["loginToken": loginToken]
        
        AF.request(requestAddressUrl,
                   method: .post,
                   parameters: parameters).response { response in
            
            debugPrint(response)//固定写法,不能debugPrint("response: "+response)
            
            if let data = response.data {
                let decoder = JSONDecoder()
                if let phone = try? decoder.decode(LocalLoginRes.self, from: data){
                    print("解密后的用户手机号: ",phone.phone)

                }
            }
        }

    }

    struct LocalLoginRes: Codable {
        let phone: String
    }
    
    /// - Returns:
    /// 弹出一键登录授权页+用户点击登录后
    private func presentLocalLoginVC(){
        
        //getAuthorizationWith 请求授权一键登录,获取登录token
        JVERIFICATIONService.getAuthorizationWith(self, hide: true, animated: true, timeout: 5*1000, completion: { (result) in
            
            //由官方文档得知,当code=6000时获取loginToken成功,code=6001时获取loginToken失败
            if let result = result, let loginToken = result["loginToken"] as? String {
                
                print("获取一键登录loginToken成功")
                JVERIFICATIONService.clearPreLoginCache()                //清除预取号缓存
                
                //发送token到我们自己的服务器,调用运营商一键登录的接口换取手机号码
                //1.服务器收到后携带此token并调用运营商接口（参考极光REST API）--可用postman模拟发送（注意鉴权和body中发参数）
                //2.成功则返回被公钥加密后的用户手机号，需在服务端解密（可在公私钥网站解密）得出明文手机号
                //3.手机号存入数据库等操作后向客户端返回登录成功的信息
//                self.getEncryptedPhoneNum(loginToken)
                
                self.getEncryptedPhoneNum_ServiceSlide(loginToken)
                
            }else{
                print("一键登录失败")                   //可提示用户UI并指引用户接下来的操作
                self.otherLogin()
            }
        }) { (type, content) in
            
            //授权页事件触发回调，根据type事件类型来判断页面上的事件
            if let content = content {
                print("一键登录状态 actionBlock :type = \(type), content = \(content)")
            }
        }
    }
    
    /// - Returns:
    /// UI - 预取手机号码一键登录界面
    private func setLocalLoginUI(){
        let config = JVUIConfig()               //JVUIConfig 登录界面UI配置基类
        
        //状态栏
        config.prefersStatusBarHidden = true         //竖屏情况下隐藏,注意：弹窗模式下无效，是否隐藏由外部控制器控制
        
        //导航栏
        config.navTransparent = true            //设为透明,此参数和navBarBackGroundImage冲突，应避免同时使用
        config.navText = NSAttributedString(string: " ")
        //因默认的关闭按钮在浅色模式下和底色融为一体了,故先隐藏掉他,再重新做一个按钮
        config.navReturnHidden = true
//        config.navControl = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(dismissLocalLoginVC))
        config.navControl = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissLocalLoginVC))
        
        //统一的水平居中约束
        //attribute 约束类型;relation 与参照视图之间的约束关系;to 参照item; multiplier 乘数;constant 常量
        //constraintX 指centerX 参照super的centerX 是(1倍)的约束关系
        let constraintX = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)!
        
        //logo 约束
        //logoConstraintY 指top 参照super的bottom 是 (1/7倍)的约束关系
        let logoConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1/7, constant: 0)!
        config.logoConstraints = [constraintX, logoConstraintY]
        
        //手机号码
        //numberConstraintY 指centerY 参照super的centerY 是 (1倍+35) 的约束关系
        let numberConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 35)!
        config.numberConstraints = [constraintX,numberConstraintY]
        
        //slogan-xx运营商提供认证服务的标语
        //sloganConstraintY 指centerY 参照number的centerY 是 (1倍+35) 的约束关系
        let sloganConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.number, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 35)!
        config.sloganConstraints = [constraintX, sloganConstraintY]
        
        //一键登录按钮
        config.logBtnText = "同意协议并一键登录"
        config.logBtnImgs = [
            UIImage(named: "localLoginBtn-nor")!,
            UIImage(named: "localLoginBtn-nor")!,
            UIImage(named: "localLoginBtn-hig")!
        ]               //正常情况下、高亮情况下按钮的背景图片,(数组顺序如: @[激活状态的图片,失效状态的图片,高亮状态的图片])
        //logBtnConstraintY 指centerY 参照slogan的centerY 是 (1倍+50) 的约束关系
        let logBtnConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.slogan, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 50)!
        config.logBtnConstraints = [constraintX, logBtnConstraintY]
        
        //隐私协议勾选框
        config.privacyState = true          //隐私条款check框默认状态
        config.checkViewHidden = true       //checkBox是否隐藏
        
        //用户协议和隐私政策
        config.appPrivacyOne = ["用户协议","https://www.cctalk.com/m/group/86306378"]       //数组（务必按顺序）@[条款名称,条款链接]
        config.appPrivacyTwo = ["隐私政策","https://www.cctalk.com/m/group/86308246"]   //数组（务必按顺序）@[条款名称,条款链接]
        config.privacyComponents = ["登录注册代表你已同意","以及","和"," "]      //隐私条款拼接文本数组,限制4个NSString对象
        config.appPrivacyColor = [UIColor.secondaryLabel, blueColor]        //隐私条款名称颜色 @[基础文字颜色,条款颜色]
        config.privacyTextAlignment = .center
        //privacyConstraintY 指top 参照slogan的bottom 是 (1倍-70) 的约束关系;privacyConstraintW 指width 参照none的width 是 (1倍+260) 的约束关系,即宽为260;
        let privacyConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: -70)!
        let privacyConstraintW = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 260)!
        config.privacyConstraints = [constraintX,privacyConstraintY,privacyConstraintW]
        
        //隐私协议详情页面
        config.agreementNavBackgroundColor = mainColor          //协议页导航栏背景颜色
        config.agreementNavReturnImage = UIImage(systemName: "chevron.left")        //协议页导航栏返回按钮图片
        
        //customUI 运行自定义的UI,在闭包中自定义一个button加到customView上
        JVERIFICATIONService.customUI(with: config){ customView in
            guard let customView = customView else { return }
            
            let otherLoginBtn = UIButton()
            otherLoginBtn.setTitle("其他方式登录", for: .normal)
            otherLoginBtn.setTitleColor(.secondaryLabel, for: .normal)
            otherLoginBtn.titleLabel?.font = .systemFont(ofSize: 15)
            otherLoginBtn.translatesAutoresizingMaskIntoConstraints = false
            otherLoginBtn.addTarget(self, action: #selector(self.otherLogin), for: .touchUpInside)
            customView.addSubview(otherLoginBtn)
            
            NSLayoutConstraint.activate([
                otherLoginBtn.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
                otherLoginBtn.centerYAnchor.constraint(equalTo: customView.centerYAnchor, constant: 170),
                otherLoginBtn.widthAnchor.constraint(equalToConstant: 279)
            ])
        }
    }

    /// - Returns:
    ///监听 - 退出预取手机号码一键登录
    @objc private func dismissLocalLoginVC(){
        JVERIFICATIONService.dismissLoginController(animated: true, completion: nil)
    }
    
    //1.接收token
    //2.客户端收到此token,调用运营商一键登录接口(不建议)
    //3.成功则返回被公钥加密后的用户手机号
    private func getEncryptedPhoneNum_ClientSlide(_ loginToken: String){
        
        //测试时需把Master Secret改成自己的
        let headers: HTTPHeaders = [
            .authorization(username: kJAppKey, password: "kJGMasterSecretKey")
        ]
        
        let parameters = ["loginToken": loginToken]
        
        //responseDecodable 响应,把jason字段一一解码为规定的字段phone
        AF.request(
            kServer_LoginReqAddUrl_Jiguang,
            method: .post,
            parameters: parameters,
            encoder: JSONParameterEncoder.default,
            headers: headers
        ).responseDecodable(of: LocalLoginRes.self) { response in

            if let localLoginRes = response.value{
                print("localLoginRes.phone: \(localLoginRes.phone) \n \(response)")//返回被公钥加密后的用户手机号
            }else{
                print("response.error: \(String(describing: response.error))")
            }
        }
        
    }
    
}

// MARK: - 除一键登录外的其他方式登录
extension UIViewController{
    
    /// - Returns:
    /// 监听 - 除一键登录外的其他方式登录
    @objc private func otherLogin(){
        JVERIFICATIONService.dismissLoginController(animated: true) {
            self.presentCodeLoginVC()
        }
    }
    
    /// - Returns:
    ///验证码登录
   func presentCodeLoginVC(){
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        let loginNaviC = mainSB.instantiateViewController(identifier: kLoginNaviID)
        loginNaviC.modalPresentationStyle = .fullScreen
        present(loginNaviC, animated: true)
    }

}
