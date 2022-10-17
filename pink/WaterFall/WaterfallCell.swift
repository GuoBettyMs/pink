//
//  WaterfallCell.swift
//  pink
//
//  Created by isdt on 2022/9/21.
//
/*
    视图控制器 HomeVC Container View 的子视图控制器 瀑布流布局Cell
 
 */

import UIKit
import LeanCloud
import Kingfisher

class WaterfallCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nickNameL: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    
    var isMyselfLike = false                //是否自己个人页面的点赞
    
    //点赞数量初始化
    var likeCount = 0{
        didSet{
            likeBtn.setTitle(likeCount.formattedStr, for: .normal)
        }
    }
    var currentLikeCount = 0                        //用于判断用户在规定时间内,对点赞按钮奇数次点击还是偶数次点击
    var isLike: Bool{ likeBtn.isSelected }          //点赞按钮是否被点击
    
    //定义云程笔记
    var note: LCObject?{
        didSet{
            //取出笔记作者note.get(kAuthorCol)
            guard let note = note, let author = note.get(kAuthorCol) as? LCUser else { return }
            
            //加载远程图片(笔记封面), https://www.jianshu.com/p/e025cec4197a
            let coverPhotoURL = note.getImageURL(from: kCoverPhotoCol, .coverPhoto)
            imageView.kf.setImage(with: coverPhotoURL, options: [.transition(.fade(0.2))])            //将云端笔记封面图片url 加载出来
//            print("coverPhotoURL: \(coverPhotoURL)")
            
            //加载远程图片(作者头像), https://www.jianshu.com/p/e025cec4197a
            let avatarURL = author.getImageURL(from: kAvatarCol, .avatar)
            avatarImageView.kf.setImage(with: avatarURL)    //将云端作者头像图片url 加载出来
//            print("avatarURL: \(avatarURL)")
            
            //笔记标题
            titleL.text = note.getExactStringVal(kTitleCol)
            
            //作者昵称
            nickNameL.text = author.getExactStringVal(kNickNameCol)
            
            //笔记被赞数
            likeCount = note.getExactIntVal(kLikeCountCol)
            currentLikeCount = likeCount
            
            //判断是否已点赞
            if isMyselfLike{                    //若已登录用户正在看自己个人页面的点赞时,无需云端查询,直接设图标为选中状态即可
                likeBtn.isSelected = true
            }else{
                if let user = LCApplication.default.currentUser{
                    let query = LCQuery(className: kUserLikeTable)
                    query.whereKey(kUserCol, .equalTo(user))
                    query.whereKey(kNoteCol, .equalTo(note))
                    query.getFirst { res in
                        if case .success = res{
                            DispatchQueue.main.async {
                                self.likeBtn.isSelected = true
                            }
                        }
                    }
                }
            }
        }
    }
    
    
}
