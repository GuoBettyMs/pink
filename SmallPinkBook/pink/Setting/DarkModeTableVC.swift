//
//  DarkModeTableVC.swift
//  pink
//
//  Created by gbt on 2022/11/17.
//
/*
    个人页面的‘设置’页面 - ‘深色模式’功能
 */
import UIKit

class DarkModeTableVC: UITableViewController {

    //当前App的深浅色模式
    var userInterfaceStyle: UIUserInterfaceStyle{ traitCollection.userInterfaceStyle }
    
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var followSystemSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        darkModeSwitch.isOn = userInterfaceStyle == .dark
        //kUserInterfaceStyle 枚举0、1、2,0指跟随系统
        followSystemSwitch.isOn = UserDefaults.standard.integer(forKey: kUserInterfaceStyle) == 0
    }


    @IBAction func toggle(_ sender: Any) {
        followSystemSwitch.setOn(false, animated: true)
        //设置App的深浅色模式
        setUserInterfaceStyle()
        
    }
    
    // MARK: 跟随系统设置
    @IBAction func followSystem(_ sender: Any) {
        if followSystemSwitch.isOn{
            view.window?.overrideUserInterfaceStyle = .unspecified //跟随系统设置
            darkModeSwitch.setOn(userInterfaceStyle == .dark, animated: true)
        }else{
            setUserInterfaceStyle()
        }
    }
    
    //若直接关闭整个app,再次打开时app仍是遵循 ‘跟随系统设置’,需要在SceneDelegate.swift得到之前设置的模式数据
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //模仿UIUserInterfaceStyle枚举的rawvalue来设012进本地,用于跟随系统switch初始UI的判断和App打开后深浅色模式的判断
        if followSystemSwitch.isOn{
            //跟随系统
            UserDefaults.standard.set(0, forKey: kUserInterfaceStyle)
        }else{
            //得到当前模式存到字段kUserInterfaceStyle
            UserDefaults.standard.set(darkModeSwitch.isOn ? 2 : 1, forKey: kUserInterfaceStyle)
        }
    }
    
    // MARK: 设置App的深浅色模式
    private func setUserInterfaceStyle(){
        //        view.overrideUserInterfaceStyle == .dark//该view及该view的所有子视图都会强制改为深色模式
        //        self.overrideUserInterfaceStyle == .dark //DarkModeTableVC 下面的所有view都会强制改为深色模式
        //        view.window?.overrideUserInterfaceStyle == .dark//整个app强制改为深色模式
        view.window?.overrideUserInterfaceStyle = darkModeSwitch.isOn ? .dark : .light
    }

}
