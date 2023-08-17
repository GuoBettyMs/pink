//
//  MeVC-Delegate.swift
//  pink
//
//  Created by gbt on 2022/11/16.
//
/*
    遵守'编辑资料'->个人页面的反向传值协议
 */
import LeanCloud

extension MeVC: EditProfileTableVCDelegate{
    // MARK: 遵守协议,反向传值到个人页面
    func updateUser(_ avatar: UIImage?, _ nickName: String, _ gender: Bool, _ birth: Date?, _ intro: String) {
        if let avatar = avatar, let data = avatar.jpeg(.medium){
            let avatarFile = LCFile(payload: .data(data: data))
            avatarFile.save(to: user, as: kAvatarCol)       //将新头像保存到云端
            meHeaderView.avatarImgView.image = avatar
        }
        
        try? user.set(kNickNameCol, value: nickName)
        meHeaderView.nickNameL.text = nickName
        
        try? user.set(kGenderCol, value: gender)
        meHeaderView.genderL.text = gender ? "♂︎" : "♀︎"
        meHeaderView.genderL.textColor = gender ? blueColor : mainColor
        
        try? user.set(kBirthCol, value: birth)
        
        try? user.set(kIntroCol, value: intro)
        meHeaderView.introL.text = intro.isEmpty ? kIntroPH : intro
        
        user.save { _ in  }
        
    }
}
