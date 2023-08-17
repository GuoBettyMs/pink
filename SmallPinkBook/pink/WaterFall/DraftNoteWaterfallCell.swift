//
//  DraftNoteWaterfallCell.swift
//  pink
//
//  Created by isdt on 2022/9/29.
//
/*
    视图控制器 HomeVC Container View 的子视图控制器 瀑布流布局Cell
 
 */

import UIKit

class DraftNoteWaterfallCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var isVideoImageView: UIImageView!
    
    var draftNote: DraftNote?{
        didSet{
            guard let draftNote = draftNote else{
                return
            }
            
            //使用便利构造器,获取数据库的封面图片
            imageView.image = UIImage(draftNote.coverPhoto) ?? imagePH
            
            let title = draftNote.title!
            titleLabel.text = title.isEmpty ? "无题" : title
            
            isVideoImageView.isHidden = !draftNote.isVideo
            
            dateLabel.text = draftNote.updatedAt?.formattedData
        }
    }
    
}
