//
//  WaterfallCell.swift
//  pink
//
//  Created by isdt on 2022/9/21.
//
/*
    视图控制器 HomeVC Container View 的子视图控制器 瀑布流布局Cell
    1.首页笔记页面cell,WaterfallCell
    2.本地草稿页面cell,DraftNoteWaterfallCell
 
 */

import UIKit
import LeanCloud
import Kingfisher

class WaterfallCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nickNameL: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    
    var isMyselfLike = false                     //是否自己个人页面的点赞
    var isLikeFromNoteDetail = false             //笔记详情页面的点赞状态传值到笔记首页,判断笔记首页的当前用户是否点赞
    
    //点赞数量初始化
    var likeCount = 0{
        didSet{
            likeBtn.setTitle(likeCount.formattedStr, for: .normal)
        }
    }
    var currentLikeCount = 0                        //用于判断用户在规定时间内,对点赞按钮奇数次点击还是偶数次点击
    var isLike: Bool{ likeBtn.isSelected }          //判断首页笔记页面的点赞按钮是否被点击
    
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
            title.text =  note.getExactStringVal(kTitleCol)
            
            //作者昵称
            nickNameL.text = author.getExactStringVal(kNickNameCol)
            
            //笔记被赞数
            likeCount = note.getExactIntVal(kLikeCountCol)
            currentLikeCount = likeCount
            
            /*
                 若‘if isMyselfLike{ likeBtn.isSelected = true } 放在awakeFromNib()中, 根据cell的执行顺序,
                 UICollectionViewCell执行顺序:
                 1. 加载出cell: let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kWaterfallCellID, for: indexPath) as! WaterfallCell
                 2.配置cell的属性: override func awakeFromNib()
                 3.传值: cell... return cell
                 4.override func awakeFromNib()
                 5.传值...
             likeBtn.isSelected默认为false,尽管跳转到个人页面传值isMyselfLike 为true,但是cell已经加载完毕,likeBtn.isSelected 不会更改
             */
            
            //若已登录用户正在看自己个人页面的点赞时,无需云端查询,直接设图标为选中状态即可
            if isMyselfLike{
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //当点击了点赞按钮,改变填充颜色
        //likeBtn的默认渲染模式是以模版为准,会随着父视图的变化而变化;为了点赞按钮被点击时渲染模式不会变化,设置renderingMode为 alwaysOriginal
        let icon = UIImage(systemName: "heart.fill")?.withTintColor(mainColor, renderingMode: .alwaysOriginal)
        likeBtn.setImage(icon, for: .selected)

    }
    
    
    // MARK: 监听 - 首页点赞
    @IBAction func like(_ sender: Any) {
        if let _ = LCApplication.default.currentUser{
            //UI
            //首页点赞,或者取消点赞,相当于 likeBtn.isSelected = !likeBtn.isSelected
            likeBtn.isSelected.toggle()
            isLike ? (likeCount += 1) : (likeCount -= 1)
            
            //数据
            //优化1:防暴力点击
            //首次点击cancelPreviousPerformRequests,若1秒内再次点击,取消上一次请求likeBtnTappedWhenLogin;1秒后再次点击,执行请求likeBtnTappedWhenLogin
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(likeBtnTappedWhenLogin), object: nil)
            perform(#selector(likeBtnTappedWhenLogin), with: nil, afterDelay: 1)
            
            //优化3:简化业务逻辑,如点赞后不可取消等(将else 的代码删除)--个人开发者初版推荐
            
        }else{
            showGlobalTextHUD("请先登录")
        }
    }
    
}
