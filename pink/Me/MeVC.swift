//
//  MeVC.swift

//  pink
//
//  Created by isdt on 2022/9/29.
//
/*
     小粉书的底部导航栏的“个人”功能
     <#在WaterfallVC 故事版 选中hidesBottomBarWhenPushed,可隐藏本地草稿界面的底部Bar#>
 */

import UIKit
import LeanCloud

class MeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //iOS14之前去掉返回按钮文本的话需:
        //1.sb上:上一个vc(MeVC)的navigationitem中修改为空格字符串串
        //2.代码:上一个vc(此页)navigationItem.backButtonTitle = ""
        navigationItem.backButtonDisplayMode = .minimal
    }

    @IBAction func logoutTest(_ sender: Any) {
        LCUser.logOut()
        
        let loginVC = storyboard!.instantiateViewController(withIdentifier: kLoginVCID)
        loginAndMeParentVC.removeAllChildren()             //移除所有子视图控制器
        loginAndMeParentVC.add(child: loginVC)             //添加登录页面
        
    }
    
    @IBAction func showDraftNotes(_ sender: Any) {
        let navi = storyboard!.instantiateViewController(withIdentifier: kDraftNotesNaviID)
        navi.modalPresentationStyle = .fullScreen
        present(navi, animated: true)
    }
    
}

