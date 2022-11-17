//
//  WaterfallVC-Layout.swift
//  pink
//
//  Created by isdt on 2022/10/14.
//
/*
    第三方库瀑布流布局 CHTCollectionViewWaterfallLayout
 */

import CHTCollectionViewWaterfallLayout

// MARK: - 遵守 CHTCollectionViewDelegateWaterfallLayout
extension WaterfallVC: CHTCollectionViewDelegateWaterfallLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let cellW = (screenRect.width - kWaterfallPadding * 3) / 2
        var cellH: CGFloat = 0
        
        // MARK: 瀑布流布局 - 个人页面‘笔记’瀑布流
        //个人页面‘笔记’中草稿cell显示条件: isMyDraft 为true并且横滑tab为第一个
        if isMyDraft, indexPath.item == 0{
            cellH = 100
        }else if isDraft{
            // MARK: 瀑布流布局 - 草稿笔记瀑布流
            //cell 高度 = 图片高度 + StackView(TitleLabel+DateLabel)高度50 + StackView上间距15 + StackView下间距15
            let draftNote = draftNotes[indexPath.item]
            let imageSize = UIImage(draftNote.coverPhoto)?.size ?? imagePH.size
            let imageH = imageSize.height
            let imageW = imageSize.width
            let imageRatio = imageH / imageW            //图片的高宽比
            cellH = cellW * imageRatio + kDraftNoteWaterfallCellBottomViewH
        }else{
            // MARK: 瀑布流布局 - HomeVC 瀑布流
            
            //情况1: 个人页面'笔记'中没有草稿cell, 首页的笔记数 = 个人页面'笔记'数量;
            //情况2: 个人页面'笔记'中有草稿cell, 首页的笔记数 = 个人页面'笔记'数量 - 1
             let offset = isMyDraft ? 1 : 0
             let note = notes[indexPath.item - offset]
            
            //封面图宽高比
             let coverPhotoRatio = CGFloat(note.getExactDoubelVal(kCoverPhotoRatioCol))
             cellH = cellW * coverPhotoRatio + kWaterfallCellBottomViewH
        }

        
        return CGSize(width: cellW, height: cellH)
    }
}
