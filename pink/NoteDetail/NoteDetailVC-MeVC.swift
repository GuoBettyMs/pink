//
//  NoteDetailVC-MeVC.swift
//  pink
//
//  Created by gbt on 2022/11/11.
//
/*
    笔记详情页 跳转到 个人页面
 */
import LeanCloud
extension NoteDetailVC{
    
    // MARK: 笔记详情页 跳转到 个人页面
    func noteToMeVC(_ user: LCUser?){
        guard let user = user else { return }
        
        //从个人页面的cell跳转到笔记详情页后,若作者相同,从笔记详情页跳转到个人页面时,应dismiss笔记详情页
        if isFromMeVC, let fromMeVCUser = fromMeVCUser, fromMeVCUser == user{
            dismiss(animated: true)
        }else{
            let meVC = storyboard!.instantiateViewController(identifier: kMeVCID) { coder in
                MeVC(coder: coder, user: user)
            }
            meVC.isFromNote = true  //实现左上角按钮的新UI和新action
            meVC.modalPresentationStyle = .fullScreen
            present(meVC, animated: true)
        }
    }
    
    // MARK: 子视图手势事件
    @objc func goToMeVC(_ tap: UIPassableTapGestureRecognizer){
        let user = tap.passObj  //获取到手势传过来的对象属性
        noteToMeVC(user)        //将对象属性传到跳转函数noteToMeVC()
    }
}
