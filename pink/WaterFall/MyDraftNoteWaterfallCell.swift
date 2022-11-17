//
//  MyDraftNoteWaterfallCell.swift
//  pink
//
//  Created by gbt on 2022/11/14.
//
/*
    个人界面的tab子控制器 '笔记' 中表示草稿笔记的cell
 */

import UIKit

class MyDraftNoteWaterfallCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var countL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        countL.text = "\(UserDefaults.standard.integer(forKey: kDraftNoteCount))"
    }

}
