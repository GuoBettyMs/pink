//
//  POICell.swift
//  pink
//
//  Created by isdt on 2022/9/26.
//
/*
    小粉书的底部导航栏的“发布”功能 -> 查询地点功能 -> 地点cell
 */

import UIKit

class POICell: UITableViewCell {

    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var addressL: UILabel!
    
    var poi = ["", ""]{
        didSet{
            nameL.text = poi[0]
            addressL.text = poi[1]
        }
    }
    

}
