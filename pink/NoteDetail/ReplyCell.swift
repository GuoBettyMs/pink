//
//  ReplyCell.swift
//  pink
//
//  Created by gbt on 2022/11/8.
//
/*
    笔记详情页的评论回复 cell
 */
import LeanCloud
import Kingfisher

class ReplyCell: UITableViewCell {
    
    @IBOutlet weak var nickNameL: UILabel!
    @IBOutlet weak var authorL: UILabel!
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var replyTextL: UILabel!
    @IBOutlet weak var showAllReplyBtn: UIButton!
    
    var reply: LCObject?{
        didSet{
            guard let reply = reply else {return}
            
            //回复人的头像和昵称
            if let user = reply.get(kUserCol) as? LCUser{
                avatarImgView.kf.setImage(with: user.getImageURL(from: kAvatarCol, .avatar))
                nickNameL.text = user.getExactStringVal(kNickNameCol)
            }
            
            //回复内容和回复时间
            let createdAt = reply.createdAt?.value
            let dateText = createdAt == nil ? "刚刚" : createdAt!.formattedData//普通回复时的时间
            let replyText = reply.getExactStringVal(kTextCol).spliceAttrStr(dateText)//普通回复时的内容拼接时间
            
            //子回复时追加一些文本
            if let replyToUser = reply.get(kReplyToUserCol) as? LCUser{
                //前面的'回复 xxx: '先拼接起来
                let replyToText = "回复 ".toAttrStr()
                let nickName = replyToUser.getExactStringVal(kNickNameCol).toAttrStr(14, .secondaryLabel)
                let colon = ": ".toAttrStr()
                replyToText.append(nickName)
                replyToText.append(colon)
                //插入到回复内容前面去
                replyText.insert(replyToText, at: 0)
            }
            
            replyTextL.attributedText = replyText//富文本拼接
            
        }
    }

}
