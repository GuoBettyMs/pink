//
//  VC-Extensions.swift
//  pink
//
//  Created by gbt on 2022/11/23.
//
/*
    UIViewController扩展
 */
import Foundation

extension UIViewController{

    // MARK: 添加&删除指定子控制器
    func add(child vc: UIViewController){
        addChild(vc)
        vc.view.frame = view.bounds         //若vc是代码创建的需加这句(后面的view即为某个containerview),若都是sb上创建的可不加.建议加
        view.addSubview(vc.view)            //展示子视图控制器视图
        vc.didMove(toParent: self)
    }
    func remove(child vc: UIViewController){
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()       //移除子视图控制器的根视图
        vc.removeFromParent()               //移除子视图控制器
    }

    //移除所有子视图控制器
    func removeAllChildren(){
        if !children.isEmpty{
            for vc in children{
                remove(child: vc)
            }
        }
    }

    // MARK: 加载框--手动隐藏
    func showLoadHUD(_ title: String? = nil){
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = title
    }
    func hideLoadHUD(){
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }

    //静态方法 - 全局加载框
    static func showGlobalLoadHUD(_ title: String? = nil){
        let hud = MBProgressHUD.showAdded(to: UIApplication.shared.windows.last!, animated: true)
        hud.label.text = title
    }
    static func hideGlobalHUD(){
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: UIApplication.shared.windows.last!, animated: true)
        }
    }
    
    
    // MARK:  提示框--自动隐藏
    func showTextHUD(_ title: String, _ inCurrentView: Bool = true, _ subTitle: String? = nil){
        var viewToShow = view!
        
        //若不在当前View,将View锁定为当前最上层的View(即使用当前最上层的View来显示提示框)
        //若界面需要发生跳转,选false
        if !inCurrentView{
            viewToShow = UIApplication.shared.windows.last!
        }
        
        let hud = MBProgressHUD.showAdded(to: viewToShow, animated: true)
        hud.mode = .text        //不指定的话显示菊花和下面配置的文本
        hud.label.text = title
        hud.detailsLabel.text = subTitle
        hud.hide(animated: true, afterDelay: 2)         //2秒后自动隐藏
    }
    
    //用于在本vc调用,让他显示到别的vc(如父vc)里去
    func showTextHUD(_ title: String, in view: UIView, _ subTitle: String? = nil){
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .text        //不指定的话显示菊花和下面配置的文本
        hud.label.text = title
        hud.detailsLabel.text = subTitle
        hud.hide(animated: true, afterDelay: 2)
    }

    // MARK: 点击空白处收起键盘
    func hideKeyboardWhenTappedAround(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        //保证tap手势不会影响到其他touch类控件的手势
        //若不设，则本页面有tableview时，点击cell不会触发didSelectRowAtIndex（除非长按）
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard(){
        view.endEditing(true) //让view中的所有textfield失去焦点--即关闭小键盘
    }
        
}
