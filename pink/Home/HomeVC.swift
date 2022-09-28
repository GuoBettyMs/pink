//
//  ShoppingVC.swift
//  LittlePinkBook
//
//  Created by isdt on 2022/9/15.
//
/*
    小粉书的底部导航栏的“主页”功能 -> buttonBarView:
 1.“关注”
 2."发现"
 3.“附近”
 
 */
/*
    共有四种横屏Tab 控制器,
 TwitterPagerTabStripViewController,
 ButtonBarPagerTabStripViewController,
 SegmentedPagerTabStripViewController,
 BarPagerTabStripViewController.
 
 1.视图控制器 HomeVC 选择继承 ButtonBarPagerTabStripViewContr
 oller
 2.ButtonBarPagerTabStripViewController 需要连接 PagerTabStripViewController containerView outlet(extends from UIscrollView.)
    ➤在HomeVC故事版中,添加 UIscrollView -> 选中 UIscrollView 右键 -> 选择 Referencing Outlets 连接 -> 选择 Container View
 3.ButtonBarPagerTabStripViewController 需要连接 buttonBarView outlet(extends from UICollectionView.)
    ➤在HomeVC故事版中,添加 UICollectionView -> 选择 View -> 修改Class 为ButtonBarView  -> 选中 UICollectionView 右键 -> 选择 Referencing Outlets 连接 -> 选择 buttonBarView

 具体操作见:
 https://github.com/xmartlabs/XLPagerTabStrip
 
 */

import UIKit
import XLPagerTabStrip

class HomeVC: ButtonBarPagerTabStripViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: 设置上方的bar,按钮,条的UI
        
        //1.整体bar--在sb上设
        
        //2.selectedBar--按钮下方的条
        settings.style.selectedBarBackgroundColor = mainColor
        settings.style.selectedBarHeight = 3
        
        //3.buttonBarItem--文本或图片的按钮
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.buttonBarItemFont = .systemFont(ofSize: 16)
        settings.style.buttonBarItemLeftRightMargin = 0

        super.viewDidLoad()
        
        containerView.bounces = false
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }

            oldCell?.label.textColor = .secondaryLabel
            newCell?.label.textColor = .label
        
        }
    }

    //主页导航栏 buttonBarView 有:关注、发现、附近,对应三个子视图控制器
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let followVC = storyboard!.instantiateViewController(identifier: kFollowVCID)
        let nearByVC = storyboard!.instantiateViewController(identifier: kNearByVCID)
        let discoveryVC = storyboard!.instantiateViewController(identifier: kDisCoveryVCID)
        
        return [followVC, discoveryVC, nearByVC]
    }
    
}
