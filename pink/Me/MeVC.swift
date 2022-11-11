//
//  MeVC.swift

//  pink
//
//  Created by isdt on 2022/9/29.
//
/*
     小粉书的底部导航栏的“个人”功能
     <#在WaterfallVC 故事版 选中hidesBottomBarWhenPushed,可隐藏本地草稿界面的底部Bar#>
 
 跳转至此页面的三种情况:
 1.登录后切换childvc进入
 2.登录后点tabbar'我'进来
 3.点用户头像或昵称进入

 看此页面的两种情况(决定UI及action):
 1.本人已登录,看自己的个人页面 --点击个人简介可修改;显示'编辑资料','设置'按钮
 2.[本人已登录,看别的用户的个人页面]或[本人未登录,看别的用户或自己的个人页面] --点击个人简介不可修改;显示'关注','聊天'按钮
 
  SegementSlide 多层 UIScrollView 嵌套滚动(每层UIScrollView包含HeaderView、ContentView)
 1.SegementSlide - HeaderView: 个人资料页面
 2.SegementSlide - ContentView: 三个tab子控制器 '笔记','收藏','赞过'(结构为collectionView)

 */

import UIKit
import LeanCloud
import SegementSlide

class MeVC: SegementSlideDefaultViewController {
    
    lazy var meHeaderView = Bundle.loadView(fromNib: "MeHeaderView", with: MeHeaderView.self)          //个人主页的头部视图cell
    
    var isFromNote = false          //判断是否从笔记跳转至此页面,跳转至此页面的情况3时要改为true
    var isMySelf = false            //判断是否登录用户本身
    
    var user: LCUser                //自定义user对象属性

    //初始化自定义的user
    init?(coder: NSCoder, user: LCUser) {
        self.user = user
        super.init(coder: coder)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        setUI()

    }

    //默认是外层大scrollview刷新(小红书是这样,同时刷新'笔记','收藏','赞过'),但本项目如果这样的话需要传值过去,不太方便,还是希望在瀑布collectionview中统一搞,故改成里面的每个瀑布collectionview单独可刷新
    override var bouncesType: BouncesType { .child }
    
    // MARK: UIScrollView 嵌套的headerView
    override func segementSlideHeaderView() -> UIView? { setHeaderView() }
    
    // MARK: 横滑tab - 标题label
    override var titlesInSwitcher: [String] { ["笔记", "收藏", "赞过"] }

    // MARK: 重写父类属性,tab 类型、标题颜色、下横线颜色
    override var switcherConfig: SegementSlideDefaultSwitcherConfig{
        var config = super.switcherConfig   //重写父类属性,
        config.type = .tab                  //使标题居中对齐
        config.selectedTitleColor = .label
        config.indicatorColor = mainColor   //横滑tab底部bar颜色
        return config
    }
    
    override func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        let vc = storyboard!.instantiateViewController(withIdentifier: kWaterfallVCID)  as! WaterfallVC
        return vc
    }
    

    
}

