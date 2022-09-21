//
//  NearByVC.swift
//  LittlePinkBook
//
//  Created by isdt on 2022/9/15.
//
/*
    视图控制器 HomeVC buttonBarView 的“附近”子视图控制器
 
 */
import UIKit
import XLPagerTabStrip

class NearByVC: UIViewController, IndicatorInfoProvider {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .orange
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        IndicatorInfo(title: NSLocalizedString("NearBy", comment: "首页上方的附近标签"))
    }

}
