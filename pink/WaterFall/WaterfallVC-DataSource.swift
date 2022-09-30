//
//  WaterfallVC-DataSource.swift
//  pink
//
//  Created by isdt on 2022/9/29.
//
/*
    瀑布流布局的 UICollectionViewDataSource 内容
 */

import Foundation

    // MARK: - 遵守UICollectionViewDataSource
extension WaterfallVC{

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isMyDraft{
            return draftNotes.count
        }else{
            return 13
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // MARK: 瀑布流布局 - 草稿瀑布流
        if isMyDraft{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kDraftNoteWaterfallCellID, for: indexPath) as! DraftNoteWaterfallCell
            cell.draftNote = draftNotes[indexPath.item]
            cell.deleteBtn.tag = indexPath.item         //获取被点击的删除按钮的索引
            cell.deleteBtn.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
            return cell
        }else{
            // MARK: 瀑布流布局 - HomeVC 瀑布流
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kWaterfallCellID, for: indexPath) as! WaterfallCell
            cell.imageview.image = UIImage(named: "Discovery-\(indexPath.item + 1)")
            return cell
        }
    }

}

    // MARK: -
extension WaterfallVC{
    
    // MARK: 监听 - 删除草稿
    private func deleteDraftNote(_ index: Int){
//        print(draftNotes.count)

        //后台线程执行
        backgroundContext.perform {
            let draftNote = self.draftNotes[index]
            //数据1:本地CoreData里的
            backgroundContext.delete(draftNote)
            appDelegate.saveBackgroundContext()
            //数据2:内存中的
            self.draftNotes.remove(at: index)

            //UI操作,在主线程执行
            DispatchQueue.main.async {
            /* 用deleteItems会出现'index out of range'的错误,因为DataSource里面的index没有更新过来,故直接使用reloadData
                self.collectionView.performBatchUpdates {
                    self.collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
                }
             */
                self.collectionView.reloadData()
                self.showTextHUD("删除草稿成功")
            }
        }
    }
}

// MARK: -
extension WaterfallVC{
    
    // MARK: 监听 - 删除草稿前的提示框
    @objc private func showAlert(_ sender: UIButton){
        let index = sender.tag
        
        let alert = UIAlertController(title: "提示", message: "确认删除该草稿吗?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "取消", style: .cancel)
        let action2 = UIAlertAction(title: "确认", style: .destructive) { _ in self.deleteDraftNote(index) }
        alert.addAction(action1)
        alert.addAction(action2)
        
        present(alert, animated: true)
    }
}
