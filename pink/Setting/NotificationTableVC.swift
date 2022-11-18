//
//  NotificationTableVC.swift
//  pink
//
//  Created by gbt on 2022/11/17.
//
/*
    个人页面的‘设置’页面 - ‘通知设置’功能
 */
import UIKit

class NotificationTableVC: UITableViewController {

    var isNotDetermined = false     //判断用户是否已授权接收通知

    @IBOutlet weak var toggleAllowNotificationSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()     //初始化Switch
        
        //从设置app跳转回来后刷新UI
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
      
    }

    @IBAction func toggleAllowNotification(_ sender: UISwitch) {
        if sender.isOn, isNotDetermined{
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                if !granted{//若用户拒绝授权,则关闭开关
                    self.setSwitch(false)
                }
            }
            //reset处理.
            //防止用户在系统弹框时拒绝授权后再次打开开关(sender.isOn = true,isNotDetermined = false),此时已无法弹出系统授权弹框,执行jumpToSetting()弹出设置app窗口进行系统授权
            isNotDetermined = false
        }else{
            jumpToSetting()
        }
    }
    

}

extension NotificationTableVC{
    private func setUI(){
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus{
            case .notDetermined:
                self.setSwitch(false)
                self.isNotDetermined = true//设为true表明从未请求授权
            case .denied:
                self.setSwitch(false)
            default:
                self.setSwitch(true)
            }
        }
    }
    
    //switch 按键UI状态
    private func setSwitch(_ on: Bool){
        DispatchQueue.main.async {
            self.toggleAllowNotificationSwitch.setOn(on, animated: true)
        }
    }
    
    @objc private func willEnterForeground(){
        setUI()
    }
}
