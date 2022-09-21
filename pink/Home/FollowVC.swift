//
//  FollowVC.swift
//  LittlePinkBook
//
//  Created by isdt on 2022/9/15.
//
/*
    视图控制器 HomeVC buttonBarView 的“关注”子视图控制器
 
 */

import UIKit
import XLPagerTabStrip

class FollowVC: UIViewController, IndicatorInfoProvider {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .blue
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        IndicatorInfo(title: NSLocalizedString("Follow", comment: "首页上方的关注标签"))
    }

}
