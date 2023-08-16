//
//  SocialLoginVC-Alipay.swift
//  pink
//
//  Created by isdt on 2022/10/9.
//
/*
     支付宝登录
 1.支付宝开放平台,详情见https://open.alipay.com/
   在支付宝开放平台创建应用+配置RSA2密钥+添加产品绑定
 2.支付宝开放平台开发助手,详情见https://opendocs.alipay.com/common/02kipk
   生成所需的RSA2密钥,保存为 “应用公钥2048.txt” 和 “应用私钥2048.txt”
 3.支付宝商家平台
   登录商家中心绑定应用id,获取完整产品开通状态 https://b.alipay.com/page/account-manage-oc/bind/appIdBindList
 
 //集成或使用时遇到问题可点右边的智能在线,若无答案,之后可请求人工. 注:直接搜问题基本搜不到
 
 // MARK: 1.支付宝登录大体流程:
 //https://opendocs.alipay.com/open/218/105329
 //跳至支付宝App或H5页面--用户点同意--我们获得authCode--用authCode跟支付宝换token--获取后可直接登录或继续获取其他信息并登录
 //可获取支付宝用户的基本开放信息（用户ID、用户头像、昵称、性别、省份、城市等六个字段）
 
 // MARK: 2.接入准备
 //https://opendocs.alipay.com/open/218/105326
 
 // MARK: 3.集成并配置完整版SDK
 //https://opendocs.alipay.com/open/204/105295
 
 // MARK: 4.调用接口
 //https://opendocs.alipay.com/open/218/105325
 
 //4-1.运行demo--仅需着眼于授权部分
 //下载地址:https://opendocs.alipay.com/open/54/104509
 //参照https://opendocs.alipay.com/open/204/105295/中'针对demo的运行'配置demo(APViewController.m中doAPAuth里放入appID,pid,私钥)
 //运行--收到result={...}和授权结果authcode=...的成功字样
 //注1.上述打印触发的是APViewController中的auth_V2WithInfo函数的闭包,appdelegate中的是支付时的回调
 //注2.若已授权此appid对应的app,不会在支付宝app中出现同意授权或拒绝授权的按钮,会出现'您已授权xxxx'的浮框
 
 */
import Alamofire
import LeanCloud

extension SocialLoginVC{

    //4-2.准备请求
    //auth_V2方法,带两个大参数(在4-3和4-4中分别准备)
    // MARK: 支付宝登录
    //<#实际开发需在服务端sign(加签)(因privateKey放客户端风险很大),然后传回客户端--这里是为了演示而在客户端搞#>
    func signInWithAlipay(){
        
        //4-3.大参数1:authInfoStr,由两部分组成:infoStr和signedStr,infoStr是常规key-value参数,signedStr是把infoStr加签后的参数
        //https://opendocs.alipay.com/open/218/105325
        //https://opendocs.alipay.com/open/218/105327  --根据上面链接中的'授权参数'及此链接准备大参数1
        
        //4-3-1.大参数1的前半部分
        //除AppID,PID,target_id之外都为固定值(只需要登录功能时其实无需这么多参数--参考极简版SDK)
        let infoStr = "apiname=com.alipay.account.auth&app_id=\(kAliPayAppID)&app_name=mc&auth_type=AUTHACCOUNT&biz_type=openservice&method=alipay.open.auth.sdk.code.get&pid=\(kAliPayPID)&product_id=APP_FAST_LOGIN&scope=kuaijie&sign_type=RSA2&target_id=20211009"
        
        //4-3-2.大参数1的后半部分
        //参照https://opendocs.alipay.com/open/204/105295/#%E9%92%88%E5%AF%B9Demo%E7%9A%84%E8%BF%90%E8%A1%8C%E6%B3%A8%E6%84%8F
        //需拖入官方demo中的：
        //1.Util和openssl两个文件夹
        //2.libcrypto.a和libssl.a两个静态库
        //防踩坑：可在项目根目录创建一个文件夹，如AliSDKDemo，然后拖进去，并在target中的“Header Search Paths”增加头文件路径
        guard let signer = APRSASigner(privateKey: kAlipayPrivateKey), let signedStr = signer.sign(infoStr, withRSA2: true) else {return}
        
        //4-3-3.拼接成大参数1
        let authInfoStr = "\(infoStr)&sign=\(signedStr)"
        print("参数1 authInfoStr: \(authInfoStr)")
        
        //4-4.大参数2:appScheme--授权完可自动跳转回本app
        
        //4-5.发起支付宝登录请求
        AlipaySDK.defaultService()?.auth_V2(withInfo: authInfoStr, fromScheme: kAppScheme, callback: { res in
            print("登录请求 res: \(String(describing: res))")     //返回字典类型resultStatus、memo、result
            guard let res = res else {return}
            
            //4-6.解析并获取到authCode(授权码)
            let resStatus = res["resultStatus"] as! String               //状态返回值
            if resStatus == "9000" {
                //请求处理成功
                //"success=true&result_code=200&app_id=2021003156621524&auth_code=e0f9ee3fc8fa4fb68042420aa03cSX35&scope=kuaijie&alipay_open_id=20880004690117562736785150313535&user_id=2088612154791354&target_id=20211009"
                let resStr = res["result"] as! String                    //返回的结果数据
                
                //["success=true","result_code=200","auth_code=xxx",...]
                let resArr = resStr.components(separatedBy: "&")         //components 根据"&"进行分割
                
                for subRes in resArr{
                    //subRes长这样:"result_code=200","auth_code=xxx",等等
                    //此处也可用上面的components方法,根据"="分离成数组,这里使用区间运算符方法
                    let equalIndex = subRes.firstIndex(of: "=")!            //等于号的index
                    let equalEndIndex = subRes.index(after: equalIndex)     //等于号后面一个字符的index
                    let prefix = subRes[..<equalIndex]                      //半开区间-取出等于号前面的内容
                    let suffix = subRes[equalEndIndex...]                   //闭区间-取出等于号后面的内容
                    print("subRes -- \(prefix): \(suffix)")
                    
                    //hasPrefix 看当前字符串是否有auth_code前缀,若有则取出当前字符串等于号后面的内容,即为authCode
                    //大家可用此法同样取出result_code,并处理登录失败时候的情况
                    if subRes.hasPrefix("auth_code"){
                        print("authCode = \(suffix)")
                        //4-7和4-8需在服务端进行,此处仅演示在客户端
                        
                        //4-7.拿authCode去和支付宝换token(访问令牌和更新令牌)
//                        self.getToken(String(suffix))
                    }
                }
            }
            
        })
        
    }
    
}
// MARK: -
extension SocialLoginVC{
    
    // MARK: 客户端操作演示(不安全) - 拿authCode去和支付宝换token
    private func getToken(_ authCode: String){
        //https://opendocs.alipay.com/apis/api_9/alipay.system.oauth.token
       
//        var parameters = [
//            "timestamp": Date().format(with: "yyyy-MM-dd HH:mm:ss"),
//            "method": "alipay.system.oauth.token",
//            "app_id": kAliPayAppID,
//            "sign_type": "RSA2",
//            "version": "1.0",
//            "charset": "utf-8",
//            "grant_type": "authorization_code",         //授权方式,使用用户授权码code换取授权令牌access_token
//            "code": authCode
//        ]
//
//        //map+sorted后变成按照首字母顺序排序的数组:["sign_type=RSA2","version=1.0"]
//        //joined后变成字符串:"sign_type=RSA2&version=1.0"
//        //$0代表每个key,$1代表每个value,"\($0)=\($1)" 形成一个数组
//        //sorted 表示一个数组按照首字母顺序排序
//        //joined 表示将一个数组转为字符串; joined(separator: "&") 表示用“&”将数组拼接成一个字符串
//        let urlParameters = parameters.map{ "\($0)=\($1)" }.sorted().joined(separator: "&")
//        guard let signer = APRSASigner(privateKey: kAlipayPrivateKey),
//              let signedStr = signer.sign(urlParameters, withRSA2: true) else { return }
//
//        //给字典signedParameters增加一个新的元素sign,removingPercentEncoding 进行url解码
//        parameters["sign"] = signedStr.removingPercentEncoding ?? signedStr
//
//        print("parameters: \(parameters)")
//
//        //手动添加签名,需对所有参数parameters进行排序
//        AF.request("https://openapi.alipay.com/gateway.do", parameters:parameters).responseJSON { response in
//            print("response: \(response)")
//        }
      
        
        let parameters = [
            "timestamp": Date().format(with: "yyyy-MM-dd HH:mm:ss"),
            "method": "alipay.system.oauth.token",     //接口名称 alipay.system.oauth.token(换取授权访问令牌)
            "app_id": kAliPayAppID,
            "sign_type": "RSA2",
            "version": "1.0",
            "charset": "utf-8",
            "grant_type": "authorization_code",        //授权方式,使用用户授权码code换取授权令牌access_token
            "code": authCode
        ]


        //手动添加签名,需对所有参数parameters进行排序
        //对access_token进行解码
        AF.request("https://openapi.alipay.com/gateway.do", parameters: self.signedParameters(parameters)).responseDecodable(of: TokenResponse.self) { response in

            print("getToken response: \(response)")

            if let tokenResponse = response.value{
                let accessToken = tokenResponse.alipay_system_oauth_token_response.access_token         //alipay_system_oauth_token_response 授权访问令牌model

                //4-8.拿accessToken去和支付宝换用户信息
                self.getInfo(accessToken)
            }
        }
    }
    
    // MARK: 客户端操作演示(不安全) - 拿accessToken去和支付宝换用户信息
    private func getInfo(_ accessToken: String){
        //https://opendocs.alipay.com/apis/api_2/alipay.user.info.share

        let parameters = [
            "timestamp": Date().format(with: "yyyy-MM-dd HH:mm:ss"),
            "method": "alipay.user.info.share",    //调用了支付宝会员授权信息查询接口 alipay.user.info.share,配合支付宝会员授权接口，查询授权信息
            "app_id": kAliPayAppID,
            "sign_type": "RSA2",
            "version": "1.0",
            "charset": "utf-8",
            "auth_token": accessToken
        ]
        
        AF.request("https://openapi.alipay.com/gateway.do", parameters: self.signedParameters(parameters)).responseDecodable(of: InfoShareResponse.self){ response in
            
//            print("getInfo response: \(response)")
            
            if let infoShareResponse = response.value{
                let info = infoShareResponse.alipay_user_info_share_response            //alipay_user_info_share_response 用户信息model
                print("成功获取支付宝用户信息: \n -- \(info.nick_name),\(info.avatar)")
                
//                //UI操作,在主线程执行,若不在主线程完成,后台执行showTextHUD时会出现卡顿
//                DispatchQueue.main.async {
//                    self.showTextHUD("支付宝登录成功", in: self.parent!.view)   //在父视图居中展示提示框
//                }
            }
        }
        
        do {
            // 创建实例
            let user = LCUser()

            // 等同于 user.set("username", value: "Tom")
            user.username = LCString("Alipay")
            user.password = LCString("cat123123")

            // 可选
            let letters = "0123456789"
            let randomPhonenum = String((0..<10).map{ _ in letters.randomElement()! })

            user.email = LCString("alipay@xd.com")
            user.mobilePhoneNumber = LCString("1"+randomPhonenum)
//            print("randomPhonenum", "1"+randomPhonenum)

            // 设置其他属性的方法跟 LCObject 一样
            try user.set(kGenderCol, value: true)
            try user.set(kIsSetPasswordCol, value: true)
            

            _ = user.signUp { (result) in
                switch result {
                case .success:
                    print("注册成功")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2, execute: {
                        LCUser.logIn(mobilePhoneNumber: "1"+randomPhonenum, password: "cat123123"){ result in
                            switch result {
                            case let .success(object: user):
                                
                                let randomNickName = "小粉薯\(String.randomString(6))"
                                self.configAfterLogin(user, randomNickName, "alipay@xd.com")//LeanCloud数据存储,退出登录界面,显示个人页面
                                
                            case let .failure(error: error):
                                self.hideLoadHUD()
                                print("密码登录失败", error.reason as Any)
                            }
                        }
                    })

                case .failure(error: let error):
                    print("注册失败",error)
                }
            }
        } catch {
            print("set LCObject 失败",error)
        }
        
        
    }
}
// MARK: -
extension SocialLoginVC{
    
    // MARK: 客户端操作演示(不安全) - 辅助函数,返回签名参数字典
    //手动添加签名,需对所有参数parameters进行排序
    private func signedParameters(_ parameters: [String: String]) -> [String: String]{
        var signedParameters = parameters
        
        //map+sorted后变成按照首字母顺序排序的数组:["sign_type=RSA2","version=1.0"]
        //joined后变成字符串:"sign_type=RSA2&version=1.0"
        //$0代表每个key,$1代表每个value,"\($0)=\($1)" 形成一个数组
        //sorted 表示一个数组按照首字母顺序排序
        //joined 表示将一个数组转为字符串; joined(separator: "&") 表示用“&”将数组拼接成一个字符串
        let urlParameters = parameters.map{ "\($0)=\($1)" }.sorted().joined(separator: "&")
        guard let signer = APRSASigner(privateKey: kAlipayPrivateKey),
              let signedStr = signer.sign(urlParameters, withRSA2: true) else {
            fatalError("加签失败")
        }
        
        //给字典signedParameters增加一个新的元素sign,removingPercentEncoding 进行url解码
        signedParameters["sign"] = signedStr.removingPercentEncoding ?? signedStr
        
        print("signedParameters: \(signedParameters)")          //打印含有sign的参数字典
        
        return signedParameters
    }
}
// MARK: -

extension SocialLoginVC{

    // MARK: 客户端操作演示(不安全) - DataModel,TokenResponse
    //授权访问令牌 access_token model
    struct TokenResponse: Decodable {
        let alipay_system_oauth_token_response: TokenResponseInfo

        struct TokenResponseInfo: Decodable{
            let access_token: String
        }
    }


    // MARK: 客户端操作演示(不安全) - DataModel,InfoShareResponse
    //用户信息model
    struct InfoShareResponse: Decodable {
        let alipay_user_info_share_response: InfoShareResponseInfo
        struct InfoShareResponseInfo: Decodable {
            let avatar: String
            let nick_name: String
            
            //若无法使用api获取用户信息,可设置静态数据
//            let avatar: String = "https://pixabay.com/zh/photos/dog-corgi-cute-animal-4988985/"                 //用户头像
//            let nick_name: String = "大黄"              //用户昵称
//            let gender: String = "W"               //用户性别
//            let province: String = "广东省"                //用户省份
//            let city: String = "深圳市"                   //用户城市
        }
    }
}

