//
//  CommentSectionFooterView.swift
//  pink
//
//  Created by gbt on 2022/11/9.
//
/*
 笔记详情页的评论section View  段与段之间的分隔线
 评论view与评论view之间的分隔线
 */
import UIKit

class CommentSectionFooterView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?){
        super.init(reuseIdentifier: reuseIdentifier)
        
        //改变section的headerfooter的底色,除了可以像之前做header一样弄一个根视图,也可以修改tintColor
        //这里不想弄一个和footer一样大小的根视图再添加分隔线视图,故直接修改tintColor
        tintColor = .systemBackground
        
        //分隔线
        let separatorLine = UIView(frame: CGRect(x: 62, y: 0, width: screenRect.width - 62, height: 1))
        separatorLine.backgroundColor = .quaternaryLabel
        
        addSubview(separatorLine)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}
