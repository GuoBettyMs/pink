//
//  MeHeaderView.swift
//  pink
//
//  Created by gbt on 2022/11/11.
//

import LeanCloud

class MeHeaderView: UIView {

    @IBOutlet weak var rootStackView: UIStackView!
    
    @IBOutlet weak var backOrDrawerBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var nickNameL: UILabel!
    @IBOutlet weak var genderL: UILabel!
    @IBOutlet weak var idL: UILabel!
    @IBOutlet weak var introL: UILabel!
    @IBOutlet weak var likedAndFavedL: UILabel!
    @IBOutlet weak var editOrFollowBtn: UIButton!
    @IBOutlet weak var settingOrChatBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        editOrFollowBtn.makeCapsule()       //按钮设置成胶囊形状
        settingOrChatBtn.makeCapsule()      //按钮设置成胶囊形状
    }
    
    var user: LCUser!{
        didSet{
            //头像和昵称
            avatarImgView.kf.setImage(with: user.getImageURL(from: kAvatarCol, .avatar))
            nickNameL.text = user.getExactStringVal(kNickNameCol)
            
            //性别
            let gender = user.getExactBoolValDefaultF(kGenderCol)
            genderL.text = gender ? "♂︎" : "♀︎"
            genderL.textColor = gender ? blueColor : mainColor
            
            //小粉书号
            idL.text = "\(user.getExactIntVal(kIDCol))"
            
            //个人简介
            let intro = user.getExactStringVal(kIntroCol)
            introL.text = intro.isEmpty ? "填写个人简介更容易获得关注哦,点击此处填写" : intro
            
            //获赞和收藏数
            guard let userObjectId =  user.objectId?.stringValue else { return }    //  解包
            let query = LCQuery(className: kUserInfoTable)
            query.whereKey(kUserObjectIdCol, .equalTo(userObjectId))        //查询云端上的用户标记符kUserObjectIdCol是否与userObjectId相等
            query.getFirst { res in
                if case let .success(object: userInfo) = res{
                    let likeCount = userInfo.getExactIntVal(kLikeCountCol)      //获取云端个人信息表的点赞数
                    let favCount = userInfo.getExactIntVal(kFavCountCol)        //获取云端个人信息表的收藏数
//                    print("\(likeCount) + \(favCount)")
                    DispatchQueue.main.async {
                        self.likedAndFavedL.text = "\(likeCount + favCount)"
                    }
                }
            }
        }
    }
 
    
    
    
}
