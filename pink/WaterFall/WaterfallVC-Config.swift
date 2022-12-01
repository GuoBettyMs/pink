//
//  WaterfallVC-Config.swift
//  pink
//
//  Created by isdt on 2022/9/29.
//
/*
    瀑布流布局的 viewDidLoad 内容
 */
import CHTCollectionViewWaterfallLayout

extension WaterfallVC{
    func config(){
        let layout = collectionView.collectionViewLayout as! CHTCollectionViewWaterfallLayout
        layout.columnCount = 2
        layout.minimumColumnSpacing = kWaterfallPadding
        layout.minimumInteritemSpacing = kWaterfallPadding
       
        var inset: UIEdgeInsets = .zero
        if let _ = user{
            //个人页面横滑scollview的headerview 和 contenView 的间距
            inset = UIEdgeInsets(top: 10, left: kWaterfallPadding, bottom: kWaterfallPadding, right: kWaterfallPadding)
        }else{
            inset = UIEdgeInsets(top: 0, left: kWaterfallPadding, bottom: kWaterfallPadding, right: kWaterfallPadding)
        }
        layout.sectionInset = inset

        if isDraft{
            navigationItem.title = "本地草稿"
        }
        
        //注册个人界面的tab子控制器'笔记'中表示草稿笔记的cell
        collectionView.register(UINib(nibName: "MyDraftNoteWaterfallCell", bundle: nil), forCellWithReuseIdentifier: kMyDraftNoteWaterfallCellID)
    }
    
}
