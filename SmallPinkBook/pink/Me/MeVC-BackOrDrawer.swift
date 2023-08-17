//
//  MeVC-BackOrDrawer.swift
//  pink
//
//  Created by gbt on 2022/11/11.
//
/*
    左上角按钮
 */
import Foundation

extension MeVC{
    // MARK: 监听 - 左上角按钮
    @objc func backOrDrawer(_ sender: UIButton){
        if isFromNote{
            dismiss(animated: true)
        }else{
            //抽屉菜单
            print("抽屉菜单")
        }
    }
}
