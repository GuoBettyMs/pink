//
//  AccountTableVC-Delegate.swift
//  pink
//
//  Created by gbt on 2022/11/17.
//
/*
    个人页面的‘设置’页面 - ‘账号与安全’功能 - Delegate协议
     1.手机号登录
     2.苹果账号登录
 */
import Foundation

extension AccountTableVC{
    // MARK: 设置账号
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0{
            
            if row == 0{
                showTextHUD("绑定、解绑、换绑手机号")
            }else{
                //设置密码
                if let _ = phoneNumStr{
                    //只有当前uiviewcontroller(AccountTableVC) 由storyboard创建时才能使用performSegue,不然会抛异常
                    //storyboard和代码混用实现动态跳转,跳转到’修改密码‘页面
                    performSegue(withIdentifier: "showPasswordTableVC", sender: nil)
                }else{
                    showTextHUD("需先绑定手机号哦")
                }
            }
        }else if section == 1{
            //第三方绑定
            switch row {
            case 0:
                showTextHUD("绑定或解绑微信账号")
            case 1:
                showTextHUD("绑定或解绑微博账号")
            case 2:
                showTextHUD("绑定或解绑QQ账号")
            case 3:
                showTextHUD("绑定或解绑Apple账号")
            default:
                break
            }
        }
        
    }
}
