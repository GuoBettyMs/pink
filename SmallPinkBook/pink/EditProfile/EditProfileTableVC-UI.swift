//
//  EditProfileTableVC-UI.swift
//  pink
//
//  Created by gbt on 2022/11/16.
//
/*
    从云端获取个人信息,从个人页面正向传值到‘编辑资料’,作为‘编辑资料’的初始信息
 */
import Kingfisher

extension EditProfileTableVC{
    
    // MARK: 个人页面信息作为‘编辑资料’的初始信息
    func setUI(){
        avatarImgView.kf.setImage(with: user.getImageURL(from: kAvatarCol, .avatar))//加载云端照片
        
        nickName = user.getExactStringVal(kNickNameCol)
        
        gender = user.getExactBoolValDefaultF(kGenderCol)
        
        birth = user.get(kBirthCol)?.dateValue

        intro = user.getExactStringVal(kIntroCol)
    }
}
