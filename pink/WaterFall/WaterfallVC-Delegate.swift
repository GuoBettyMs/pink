//
//  WaterfallVC-Delegate.swift
//  pink
//
//  Created by isdt on 2022/9/29.
//
/*
    瀑布流布局的 UICollectionViewDelegate 内容
 */
import Foundation


extension WaterfallVC{
    
    // MARK: 遵守UICollectionViewDelegate - 跳转到编辑笔记界面
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isMyDraft{
            let draftNote = draftNotes[indexPath.item]
            
            //将图片Data数组 转为 image数组
            if let photosData = draftNote.photos,
               let photosDataArr = try? JSONDecoder().decode([Data].self, from: photosData){
               
                let photos = photosDataArr.map { data -> UIImage in
                    UIImage(data) ?? imagePH
                }
                /* 等同于
                 let photos = photosDataArr.map {
                 UIImage($0) ?? imagePH
                 }
                 */
                
                let videoURL = FileManager.default.save(draftNote.video, to: "video", as: "\(UUID().uuidString).mp4")
                let noteEditVC = storyboard!.instantiateViewController(identifier: kNoteEditVCID) as!NoteEditVC
                noteEditVC.draftNote = draftNote
                noteEditVC.photos = photos
                noteEditVC.videoURL = videoURL
                
                //闭包: 更新草稿后获取新的草稿数据
                noteEditVC.updateDraftNoteFinished = {
                    self.getDraftNotes()
                }
                navigationController?.pushViewController(noteEditVC, animated: true)
                
            }else{
                showTextHUD("加载草稿失败")
            }


        }else{
            
        }
    }
}
/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
    return true
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    return true
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
    return false
}

override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
    return false
}

override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {

}
*/
