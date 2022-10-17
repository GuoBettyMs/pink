//
//  WaterfallVC.swift
//  LittlePinkBook
//
//  Created by isdt on 2022/9/15.
//
/*
    视图控制器 HomeVC Container View 的子视图控制器 符合瀑布流布局,使用 CHTCollectionViewWaterfallLayout
    故事版中,collectionView的 Layout 填写为  CHTCollectionViewWaterfallLayout
    UICollectionViewLayout 填写为  CHTCollectionViewWaterfallLayout
    <# 在故事版 选中hidesBottomBarWhenPushed,可隐藏本地草稿界面的底部Bar#>
 
 */

import UIKit
import CHTCollectionViewWaterfallLayout
import XLPagerTabStrip
import LeanCloud

class WaterfallVC: UICollectionViewController {
    //笔记话题
    var channel = ""
    
    //草稿页相关数据
    var isMyDraft = false
    var draftNotes: [DraftNote] = []
    
    //首页相关数据
    var notes: [LCObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        getNotes()
        getDraftNotes()
    }

    @IBAction func dismissDraftNotesVC(_ sender: Any) {
        dismiss(animated: true)
    }
}


extension WaterfallVC: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        IndicatorInfo(title: channel)
    }
}
