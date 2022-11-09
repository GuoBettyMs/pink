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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isMyDraft{
            // MARK: 遵守UICollectionViewDelegate - 跳转-编辑笔记界面
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
                
                //编辑或取消编辑后需删除,防止temp文件夹容量过大
                let videoURL = FileManager.default.save(draftNote.video, to: "video", as: "\(UUID().uuidString).mp4")
                
                let noteEditVC = storyboard!.instantiateViewController(identifier: kNoteEditVCID) as! NoteEditVC
                noteEditVC.draftNote = draftNote
                noteEditVC.photos = photos
                noteEditVC.videoURL = videoURL
                
                //闭包: 更新草稿后获取新的草稿数据
                noteEditVC.updateDraftNoteFinished = {
                    self.getDraftNotes()
                }
                
                //闭包: 发布草稿后获取新的草稿数据
                noteEditVC.postDraftNoteFinished = {
                    self.getDraftNotes()
                }

                navigationController?.pushViewController(noteEditVC, animated: true)
            }else{
                showTextHUD("加载草稿失败")           //不跳转界面,默认选true
            }
        }else{
            // MARK: 遵守UICollectionViewDelegate - 跳转-笔记详情页面
            
            let offset = isMyDraft ? 1 : 0
            let item = indexPath.item - offset
            
            //依赖注入(Dependency Injection)
            let detailVC = storyboard!.instantiateViewController(identifier: kNoteDetailVCID){ coder in
                NoteDetailVC(coder: coder, note: self.notes[item])
            }
            
            //通过isLikeFromWaterfallCell 将笔记首页的点赞状态传值到笔记详情页面,判断详情页的当前用户是否点赞
            if let cell = collectionView.cellForItem(at: indexPath) as? WaterfallCell{
                detailVC.isLikeFromWaterfallCell = cell.isLike          //isLikeFromWaterfallCell 详情页的点赞状态;isLike 笔记首页的点赞状态
            }

            //删除笔记后回到首页后刷新首页(此处为节省资源,用删除指定cell的方法)
            detailVC.delNoteFinished = {
                self.notes.remove(at: item)
                collectionView.performBatchUpdates {
                    collectionView.deleteItems(at: [indexPath])
                }
            }
//            detailVC.isFromMeVC = isFromMeVC
//            detailVC.fromMeVCUser = fromMeVCUser
            
            
            detailVC.modalPresentationStyle = .fullScreen
            present(detailVC, animated: true)
//            print("kTitleCol:  \(note.getExactStringVal(kTitleCol))")
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
