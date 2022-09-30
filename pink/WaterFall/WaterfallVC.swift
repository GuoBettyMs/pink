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


class WaterfallVC: UICollectionViewController {
    
    var channel = ""    
    var isMyDraft = true
    var draftNotes: [DraftNote] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        getDraftNotes()
    }

}

// MARK: - 遵守 CHTCollectionViewDelegateWaterfallLayout
extension WaterfallVC: CHTCollectionViewDelegateWaterfallLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        /*
        let cellW = (screenRect.width - kWaterfallPadding * 3) / 2
        var cellH: CGFloat = 0
        
        // MARK: 瀑布流布局 - 草稿瀑布流
        if isMyDraft{
            //cell 高度 = 图片高度 + StackView(TitleLabel+DateLabel)高度50 + StackView上间距15 + StackView下间距15
            let draftNote = draftNotes[indexPath.item]
            let imageSize = UIImage(draftNote.coverPhoto)?.size ?? imagePH.size
            let imageH = imageSize.height
            let imageW = imageSize.width
            let imageRatio = imageH / imageW            //取图片的高宽比
            cellH = cellW * imageRatio + kDraftNoteWaterfallCellBottomViewH
        }else{
            // MARK: 瀑布流布局 - HomeVC 瀑布流
            cellH = UIImage(named: "Discovery-\(indexPath.item + 1)")!.size.height
        }
        return CGSize(width: cellW, height: cellH)
        */
        
        if isMyDraft{
            let cellW = (screenRect.width - kWaterfallPadding * 3) / 2
            var cellH: CGFloat = 0
            let draftNote = draftNotes[indexPath.item]
            let imageSize = UIImage(draftNote.coverPhoto)?.size ?? imagePH.size
            let imageH = imageSize.height
            let imageW = imageSize.width
            let imageRatio = imageH / imageW            //取图片的高宽比
            cellH = cellW * imageRatio + kDraftNoteWaterfallCellBottomViewH
            
            return CGSize(width: cellW, height: cellH)
        }else{
            return UIImage(named: "Discovery-\(indexPath.item + 1)")!.size
        }
        
    }
}

extension WaterfallVC: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        IndicatorInfo(title: channel)
    }
}
