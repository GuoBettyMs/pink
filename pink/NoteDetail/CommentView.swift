//
//  CommentView.swift
//  pink
//
//  Created by gbt on 2022/11/8.
//
/*
    详细笔记页面的评论View cell
 
 // MARK: xib中的注意事项
 //类似于cell中默认都有个contentview一样,这里也需要在xib中先加个uiview在底层(用来设置底色),再在上面放东西,不然会出现如下错误
 //[TableView] Setting the background color on UITableViewHeaderFooterView has been deprecated. Please set a custom UIView with your desired background color to the backgroundView property instead

 // MARK: storyboard中的设置
 //在xib文件中定好上下左右的约束,并把tableview的sectionHeaderHeight改成auto,即可自动调节高度
 //此时需填写他下面的estimatedSectionHeaderHeight属性-写一个大概的值,主要用于提高性能.此属性在header高度调成auto时必须设,见文档:
 //https://developer.apple.com/documentation/uikit/uitableview/1614957-estimatedsectionheaderheight
 */
import UIKit
import LeanCloud
import Kingfisher

class CommentView: UITableViewHeaderFooterView {

    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var nickNameL: UILabel!
    @IBOutlet weak var authorL: UILabel!
    @IBOutlet weak var commentTextL: UILabel!
    
    
    var comment: LCObject?{
        didSet{
            guard let comment = comment else { return }
            
            //评论人的头像和昵称
            if let user = comment.get(kUserCol) as? LCUser{
                avatarImgView.kf.setImage(with: user.getImageURL(from: kAvatarCol, .avatar))
                nickNameL.text = user.getExactStringVal(kNickNameCol)
            }
            
            //评论内容和评论时间
            let commentText = comment.getExactStringVal(kTextCol)
            let createdAt = comment.createdAt?.value.formattedData
            let dateText = createdAt == nil ? "刚刚" : createdAt!
            commentTextL.attributedText = commentText.spliceAttrStr(dateText)//评论内容和评论时间类型不同,使用富文本将评论内容和评论时间拼接起来
        }
    }
    
}
