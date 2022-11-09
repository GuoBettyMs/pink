//
//  NoteDetailVC-Helper.swift
//  pink
//
//  Created by gbt on 2022/11/7.
//
/*
    封装-”删除“弹框提示
 */
import Foundation
extension NoteDetailVC{
    // MARK: 封装 - ”删除“弹框提示
    //删除某个东西之前给用户的alert提示框
    func showDelAlert(for name: String, confirmHandler: ((UIAlertAction) -> ())?){
        let alert = UIAlertController(title: "提示", message: "确认删除\(name)", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "取消", style: .cancel)
        let confirm = UIAlertAction(title: "确认", style: .default, handler: confirmHandler)//闭包confirmHandler
        alert.addAction(cancel)
        alert.addAction(confirm)
        present(alert, animated: true)
    }
    
    
}
