//
//  PhotoFooter.swift
//  LittlePinkBook
//
//  Created by isdt on 2022/9/20.
//
/*
 
    发布笔记编辑页面 的相片cell 的footer
 
 */

import UIKit

class PhotoFooter: UICollectionReusableView {
    
    @IBOutlet weak var addPhotoBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addPhotoBtn.layer.borderWidth = 1
        addPhotoBtn.layer.borderColor = UIColor.tertiaryLabel.cgColor
    }
    
}
