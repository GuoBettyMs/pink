//
//  NoteDetailVC-UI.swift
//  pink
//
//  Created by isdt on 2022/10/13.
//
/*
    详细笔记页面 - UI
 */
import Kingfisher
import LeanCloud
import ImageSlideshow

extension NoteDetailVC{
    
    // MARK: UI
    func setUI(){
     
//        //详细笔记界面上方bar的收藏按钮, 注意在故事版上勾选 clips to bounds,不然可能圆角不明显
//        followBtn.layer.borderWidth = 1
//        followBtn.layer.borderColor = mainColor.cgColor
        followBtn.makeCapsule(mainColor) //详细笔记界面上方bar的收藏按钮,设置成胶囊形状
        
        //判断是否是用户自己的笔记
        if isReadMyDraft{
            followBtn.isHidden = true
            shareOrMoreBtn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        }
        
        showNote()          //关联云端笔记信息
        showLike()          //关联笔记详情页面与首页笔记的点赞状态
    }
    
    // MARK: UI - 关联云端笔记信息
    func showNote(_ isUpdatingNote: Bool = false){
        //笔记和笔记作者是多对一关系,更新笔记时并没有重新上传笔记作者信息,因此在NoteDetailVC.swift 中的author计算属性,获取到的作者信息是空值
        //为防止更新笔记后,作者信息为空,增加判断值: 如果不是在更新编辑过的笔记,再来获取作者信息
        if !isUpdatingNote{
            //上方bar作者信息
            let authorAvatarURL = author?.getImageURL(from: kAvatarCol, .avatar)
            authorAvatarBtn.kf.setImage(with: authorAvatarURL, for: .normal)
            authorNickNameBtn.setTitle(author?.getExactStringVal(kNickNameCol), for: .normal)
        }

        
        //note图片
        //1.图片高度
        let coverPhotoHeight = CGFloat(note.getExactDoubelVal(kCoverPhotoRatioCol)) * screenRect.width
        imageViewSlideshowH.constant = coverPhotoHeight         //跟屏幕宽度等宽比地修改图片的高度约束,constant 相当于故事版设置的高度约束
        
        //2.加载图片
        //第一次转场动画过来后,因加载网络图片需要时间,故会有空白一闪而过.后面再操作因为Kingfisher已经缓存了图片,故没有
        //可把第一张图替换为已经加载并缓存好的封面图,此时需让:存封面图和普通图片时,压缩率调成一样,这样可保持所有图片清晰度一样
        let coverPhoto = KingfisherSource(url: note.getImageURL(from: kCoverPhotoCol, .coverPhoto))          //[“https://1.jpg”, nil, "https://2.jpg"]
        if let photoPaths = note.get(kPhotosCol)?.arrayValue as? [String]{
            var photoArr = photoPaths.compactMap{ KingfisherSource(urlString: $0) }         //若实例化失败,不返回nil
            photoArr[0] = coverPhoto                    //解决第一次加载时的白屏:把封面图作为photoArr第0个元素
            imageViewSlideshow.setImageInputs(photoArr)
        }else{
            imageViewSlideshow.setImageInputs([coverPhoto])
        }
        
        //note标题
        let noteTitle = note.getExactStringVal(kTitleCol)
//        print("noteTitle: \(noteTitle)")
        if noteTitle.isEmpty{
            titleL.isHidden = true
        }else{
            titleL.text = noteTitle
        }
        
        //note正文
        let noteText = note.getExactStringVal(kTextCol)
        textLabel.attributedText = noteText.attributedString(font: .systemFont(ofSize: 14), textColor: .secondaryLabel, lineSpaceing: 10, wordSpaceing: 0)
        if noteText.isEmpty{
            textLabel.isHidden = true
        }else{
            textLabel.text = noteText
        }
        
        //note话题
        let noteChannel = note.getExactStringVal(kChannelCol)
        let noteSubChannel = note.getExactStringVal(kSubChannelCol)
        channelBtn.setTitle(noteSubChannel.isEmpty ? noteChannel : noteSubChannel, for: .normal)
        
        //note发表或编辑时间
        if let updatedAt = note.updatedAt?.value{
            dateLabel.text = "\(note.getExactBoolValDefaultF(kHasEditCol) ? "编辑于 " : "")\(updatedAt.formattedData)"
        }
        
        //当前用户头像
        if let user = LCApplication.default.currentUser{
            let avatarURL = user.getImageURL(from: kAvatarCol, .avatar)
            avatarImageView.kf.setImage(with: avatarURL)
        }
        
        //底部bar点赞数
        likeCount = note.getExactIntVal(kLikeCountCol)
        currentLikeCount = likeCount
        
        //底部bar收藏数
        favCount = note.getExactIntVal(kFavCountCol)
        currentFavCount = favCount
        
        //底部bar评论数
        commentCount = note.getExactIntVal(kCommentCountCol)
        
    }
    
    // MARK: UI - 关联笔记详情页面与首页笔记的点赞状态
    private func showLike(){
        //因点赞包点赞后有默认动画,故为了体验不使用此方法
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.likeBtn.isSelected = self.isLikeFromWaterfallCell
//        }
        likeBtn.setSelected(selected: isLikeFromWaterfallCell, animated: false)         //点赞包的方法,可实现无动画
    }
    
}
