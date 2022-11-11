//
//  DiscoveryVC.swift
//  LittlePinkBook
//
//  Created by isdt on 2022/9/15.
//
/*
    视图控制器 HomeVC buttonBarView 的“发现”子视图控制器:
 1."推荐"
 2."旅行"
 3."娱乐"
 4."才艺"
 5."美妆"
 6."白富美"
 7."美食"
 8."萌宠"

    该视图控制器有横屏Tab 控制器,因此再次调用 ButtonBarPagerTabStripViewController
    横屏Tab 控制器联动的视图控制器 WaterfallVC 符合瀑布流布局,使用 CHTCollectionViewWaterfallLayout
 */


import UIKit
import XLPagerTabStrip

class DiscoveryVC: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        
        settings.style.selectedBarHeight = 0
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.buttonBarItemFont = .systemFont(ofSize: 14)

        super.viewDidLoad()

        containerView.bounces = false
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }

            oldCell?.label.textColor = .secondaryLabel
            newCell?.label.textColor = .label
        }

    }
    
    // MARK: 横屏Tab 控制器联动的视图控制器
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        var vcs: [UIViewController] = []
        for channel in kChannels {
            let vc = storyboard!.instantiateViewController(identifier: kWaterfallVCID) as! WaterfallVC
            vc.channel = channel
            vcs.append(vc)
        }
        return vcs
    }

}

// MARK: 遵守 IndicatorInfoProvider
extension DiscoveryVC: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        IndicatorInfo(title: NSLocalizedString("Discovery", comment: "首页上方的发现标签"))
    }
    
}
