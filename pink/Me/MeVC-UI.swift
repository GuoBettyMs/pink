//
//  MeVC-UI.swift
//  pink
//
//  Created by gbt on 2022/11/11.
//

/*
    个人主页的 UI 属性
 */
import SegementSlide

extension MeVC{
    func setUI(){
        //改变基类属性-适配深色模式
        scrollView.backgroundColor = .systemBackground      //外层scrollView 背景色
        contentView.backgroundColor = .systemBackground     //内层scrollView背景色
        switcherView.backgroundColor = .systemBackground    //横滑tab switcherView 背景色

        /*
         获取当前机型状态栏的高度,
         1.方法一
         let statusBarH = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height
         2.方法二
         见 SceneDelegate.swift
         */
        let statusBarOverlayView = UIView(frame: CGRect(x: 0, y: 0, width: screenRect.width, height: kStatusBarH))
        statusBarOverlayView.backgroundColor = .systemBackground
        view.addSubview(statusBarOverlayView)

        defaultSelectedIndex = 0
        reloadData()
    }
}
