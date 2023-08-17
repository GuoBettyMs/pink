//
//  MeVC-EditIntro.swift
//  pink
//
//  Created by gbt on 2022/11/11.
//
/*
    编辑个人简介
 */
import Foundation

extension MeVC{
    // MARK: 监听 - 编辑个人简介
    @objc func editIntro(){
        let vc = storyboard!.instantiateViewController(withIdentifier: kIntroVCID) as! IntroVC
        vc.intro = user.getExactStringVal(kIntroCol)        //从云端获取个人简介字段内容,传值给子视图控制器
        vc.delegate = self
        present(vc, animated: true)
    }
}

// MARK: 遵守IntroVCDelegate
extension MeVC: IntroVCDelegate{
    func updateIntro(_ intro: String) {
        //UI
        meHeaderView.introL.text = intro.isEmpty ? kIntroPH : intro
        
        //云端
        try? user.set(kIntroCol, value: intro)
        user.save { _ in }
        
    }
}
