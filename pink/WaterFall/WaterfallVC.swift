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
 
    <#注#> 在故事版中,将 collectionView 的 boundce Vertically 选中,可以实现:即使collectionView 内容没有超出界面,也可以有上下拉动画效果,有利于添加上下拉刷新加载功能
 
 */

import UIKit
import CHTCollectionViewWaterfallLayout
import XLPagerTabStrip
import LeanCloud
import SegementSlide


//遵守SegementSlideContentScrollViewDelegate, 使个人页面可以使用多层 UIScrollView 嵌套滚动
class WaterfallVC: UICollectionViewController, SegementSlideContentScrollViewDelegate {
    //笔记话题
    var channel = ""
    
    lazy var header = MJRefreshNormalHeader()
    
    //遵守SegementSlideContentScrollViewDelegate,需要设置属性
    /*
    @objc var scrollView: UIScrollView {
     return tableView //返回根视图
    }
     */
    @objc var scrollView: UIScrollView { collectionView } //瀑布流根视图为collectionView
    
    //笔记草稿页相关数据
    var isDraft = false
    var draftNotes: [DraftNote] = []
    
    //首页相关数据
    var notes: [LCObject] = []
    
    //个人页相关数据
    var isMyDraft = false//用于判断是否显示我的草稿cell
    var user: LCUser?//可用于判断当前是否在个人页面
    var isMyNote = false//在上面user的基础上,用于判断是否是'笔记'tab页
    var isMyFav = false//在上面user的基础上,用于判断是否是'收藏'tab页
    var isMyselfLike = false//在上面user的基础上,用于判断已登录用户是否在看自己的'赞过'tab页
    var isFromMeVC = false
    var fromMeVCUser: LCUser?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()

        if let _ = user{//个人页面
            if isMyNote{
//                header.setRefreshingTarget(self, refreshingAction: #selector(getMyNotes))
            }else if isMyFav{
//                header.setRefreshingTarget(self, refreshingAction: #selector(getMyFavNotes))
            }else{
//                header.setRefreshingTarget(self, refreshingAction: #selector(getMyLikeNotes))
            }
            header.beginRefreshing()
        }else if isDraft{//草稿总页面
            getDraftNotes()
        }else{//首页
//            header.setRefreshingTarget(self, refreshingAction: #selector(getNotes))
//            header.beginRefreshing()
            getNotes()
            
        }
        
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
