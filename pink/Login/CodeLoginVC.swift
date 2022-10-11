//
//  CodeLoginVC.swift
//  pink
//
//  Created by isdt on 2022/10/9.
//
/*
    验证码登录,使用后端云服务SDK
    若要上线应用,需要
    1.申请API 独立 IP
    2.备案域名和绑定域名 https://leancloud.cn/docs/custom-api-domain-guide.html
 */
import Alamofire
import LeanCloud

private let totalTime = 15
class CodeLoginVC: UIViewController {

    @IBOutlet weak var phoneNumTF: UITextField!
    @IBOutlet weak var autoCodeTF: UITextField!
    @IBOutlet weak var getAuthCodeBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    private var timeRemain = totalTime
    private var phoneNumStr: String { phoneNumTF.unwrappedText }
    private var authCodeStr: String { autoCodeTF.unwrappedText }
    
    lazy private var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()              //点击空白处收起键盘
        loginBtn.setToDisabled()                    //设置登录按钮为不可点击状态
    }

    //因密码登录页面pop回来的时候也需要弹出软键盘,这里简单处理
    //也可手动performsegue(push)进下一个页面,然后用闭包或代理的方式,不再赘述
    //放在viewDidAppear的话会等页面完全展示后再弹出,衔接不太顺畅
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        phoneNumTF.becomeFirstResponder()               //弹出软键盘
    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        phoneNumTF.becomeFirstResponder()
//    }
    
    // MARK: 退出验证码登录
    @IBAction func dismiss(_ sender: Any) { dismiss(animated: true) }
  
    // MARK: 判断输入的手机号码、验证码是否合法
    //在故事版点击验证码UITextField,选择connections inspectors,将editing changed 连接到该方法中,实现手机号码UITextField、验证码UITextField都能执行该方法
    //在故事版将验证码UITextField的content type 选为one time code,手机收到短信验证码后会自动将验证码显示在软键盘上方的框,点击软键盘上方的框验证码会自动填充到UITextField
    @IBAction func TFEditingChanged(_ sender: UITextField) {
        if sender == phoneNumTF{
            //判断用户输入的手机号是否合法,来决定‘获取验证码’按钮展示与否
            //若按钮进入倒计时状态（disable）时也不隐藏
            getAuthCodeBtn.isHidden = !phoneNumStr.isPhoneNum && getAuthCodeBtn.isEnabled
        }
        if phoneNumStr.isPhoneNum && authCodeStr.isAuthCode{
            loginBtn.setToEnabled()
        }else{
            loginBtn.setToDisabled()
        }
    }
    
    // MARK: 获取验证码
    //设计1:按钮一直显示，用户按下时判断
    //设计2(本案):按钮先隐藏，用户输完11位手机号后判断，若合法则显示--体验好
    @IBAction func getAuthCode(_ sender: Any) {
        getAuthCodeBtn.isEnabled = false
        setAuthCodeBtnDisabledText()                //验证码按钮显示倒计时
        autoCodeTF.becomeFirstResponder()           //点击获取验证码按钮,自动弹出软键盘,光标自动聚焦到验证码UITextField
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(changeAuthCodeBtnText), userInfo: nil, repeats: true)
        
        //需要在LeanCloud开通短信服务、添加短信签名和短信模板,否则无法发送短信(因为该应用不准备上线,所以没有添加签名)
        //短信服务 详情见 https://leancloud.cn/docs/sms-guide.html
        
        //使用审核通过的签名签名模板
        //name:不指定的话为在LeanCloud上创建的应用名
        //ttl:失效时间.0-30分钟，官方说默认10分钟，实测为30，故这里重新指定
        let variables: LCDictionary = ["name": LCString("小粉书"), "ttl": LCNumber(5)]
        //启用通用的短信验证码服务（开放 requestSmsCode 接口和verifySmsCode 接口）
        LCSMSClient.requestShortMessage(
            mobilePhoneNumber: phoneNumStr,
            templateName: "login",
            signatureName: "小粉书",
            variables: variables)
        { result in
            if case let .failure(error: error) = result{
                print(error.reason ?? "短信验证码未知错误")
            }
            /* 等同于
             switch result {
             case .success:
                 break
             case .failure(error: let error):
                 print(error)
             }
             */
        }
    }
    
    // MARK: 验证码登录
    //测试手机号:13202161631 测试验证码:464744(使用测试手机号不需要点击获取验证码按钮)
    @IBAction func login(_ sender: UIButton) {
        view.endEditing(true)
        
        showLoadHUD()

        //使用手机号注册并登录,用户第一次填入验证码后，完成注册,提供随机昵称和头像;用户第二次填入验证码后，直接登录
        LCUser.signUpOrLogIn(mobilePhoneNumber: phoneNumStr, verificationCode: authCodeStr){ result in
            switch result {
            case let .success(object: user):
                let randomNickName = "小粉薯\(String.randomString(6))"
                self.configAfterLogin(user, randomNickName)             //LeanCloud数据存储
                DispatchQueue.main.async {
                    self.showTextHUD("验证码登录成功")
                }
//                print(user, randomNickName)
            case let .failure(error: error):
                self.hideLoadHUD()
                DispatchQueue.main.async {
                    self.showTextHUD("验证码登录失败", true, error.reason)
                }
            }
        }
    }
    
}

extension CodeLoginVC: UITextFieldDelegate{
    
    // MARK: 限制手机号码\验证码数量
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //range.location--当前输入的字符或粘贴文本的第一个字符的索引
        //string--当前输入的字符或粘贴的文本
        let limit = textField == phoneNumTF ? 11 : 6
        let isExceed = range.location >= 11 || (textField.unwrappedText.count + string.count) > limit
        if isExceed{
            showTextHUD("最多只能输入\(limit)位哦")
        }
        return !isExceed
    }
    
    // MARK: 当软键盘为默认键盘时,对returnKey的处理
    //点击returnKey后对UITextField的字母简单判断
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == phoneNumTF{
            autoCodeTF.becomeFirstResponder()           //点击returnKey,光标自动聚焦到验证码UITextField
        }else{
            if loginBtn.isEnabled{ login(loginBtn) }
        }
        return true
    }
}
// MARK: -
extension CodeLoginVC{
    
    // MARK: 监听 - 验证码获取按钮UI
    @objc private func changeAuthCodeBtnText(){
        timeRemain -= 1
        setAuthCodeBtnDisabledText()
        
        if timeRemain <= 0{
            timer.invalidate()              //使用Timer之后一定要在某个时候销毁掉
            
            //reset处理
            timeRemain = totalTime
            getAuthCodeBtn.isEnabled = true
            getAuthCodeBtn.setTitle("发送验证码", for: .normal)
            
            //倒计时的时候若用户将原来的手机号修改成了非法手机号,倒计时结束后获取验证码按钮不显示
            getAuthCodeBtn.isHidden = !phoneNumStr.isPhoneNum
        }
    }
}
// MARK: -
extension CodeLoginVC{
    
    // MARK: 一般函数 - 获得验证码后倒计时
    //为防止按钮的title一闪一闪的,需要在故事版把按钮的type改为custom、并设置state config为normal、disabled时的textcolor
    private func setAuthCodeBtnDisabledText(){
        getAuthCodeBtn.setTitle("重新发送(\(timeRemain)s)", for: .disabled)
    }
}
