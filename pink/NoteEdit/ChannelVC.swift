//
//  ChannelVC.swift
//  pink
//
//  Created by isdt on 2022/9/26.
//
/*
    小粉书的底部导航栏的“发布”功能 -> 参与话题功能
 */

import UIKit
import XLPagerTabStrip

class ChannelVC: ButtonBarPagerTabStripViewController {

    var PVDelegate: ChannelVCDelegate?          //定义 ChannelVC 协议
    var subChannel = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settings.style.selectedBarHeight = 2
        settings.style.selectedBarBackgroundColor = mainColor
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.buttonBarItemFont = .systemFont(ofSize: 15)
        
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
        
        //kChannels.indices 返回channel索引
        for i in kChannels.indices {
            let vc = storyboard!.instantiateViewController(withIdentifier: kChannelTableVCID) as! ChannelTableVC
            vc.channel = kChannels[i]
            vc.subChannels = kAllSubChannels[i]
            vcs.append(vc)
        }
        return vcs
    }

}

