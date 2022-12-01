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
        
        // MARK: 遵守UICollectionViewDelegate - 跳转-个人页面的草稿
        if isMyDraft, indexPath.item == 0{

            let navi = storyboard!.instantiateViewController(identifier: kDraftNotesNaviID) as! UINavigationController
            navi.modalPresentationStyle = .fullScreen
            ((navi.topViewController) as! WaterfallVC).isDraft = true
            present(navi, animated: true)

        }else if isDraft{
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

            detailVC.modalPresentationStyle = .fullScreen
            detailVC.delegate = self //遵守自定义NoteDetailVCDelegate,正向传值likeBtn状态和likeCount、currentLikeCount
            
            //删除笔记后回到首页后刷新首页(此处为节省资源,用删除指定cell的方法)
            detailVC.delNoteFinished = {
                self.notes.remove(at: item)
                collectionView.performBatchUpdates {
                    collectionView.deleteItems(at: [indexPath])
                }
            }
            
            detailVC.isFromMeVC = isFromMeVC          //从个人页面跳转到笔记详情页,传值bool状态
            detailVC.fromMeVCUser = fromMeVCUser      //从个人页面跳转到笔记详情页,传值用户对象
            detailVC.cellItem = indexPath.item
            detailVC.noteHeroID = "noteHeroID\(indexPath.item)"  //配置cell的heroID,与首页瀑布流cell的heroID一样
            
            present(detailVC, animated: true)
//            print("kTitleCol:  \(note.getExactStringVal(kTitleCol))")
        }
    }
}


extension WaterfallVC: NoteDetailVCDelegate{
    // MARK: 遵守NoteDetailVCDelegate - 更新主页瀑布流cell
    //获取笔记详情页的likeBtn状态和likeCount、currentLikeCount,更新到主页瀑布流cell
    func updateLikeBtn(cellItem: Int, isLike: Bool, likeCount: Int) {
        if let cell = collectionView.cellForItem(at: IndexPath(item: cellItem, section: 0)) as? WaterfallCell{
            cell.likeBtn.isSelected = isLike
            cell.likeCount = likeCount
            cell.currentLikeCount = likeCount
        }
    }

}
