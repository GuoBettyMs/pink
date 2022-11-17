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

    //笔记数量,每一个笔记对应一个collectionView item
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isMyDraft{
            //个人页面collectionView item('笔记'数量) = 首页笔记数 + 草稿cell(1)
            return notes.count + 1
        }else if isDraft{
            //笔记草稿
            return draftNotes.count
        }else{
            //主页
            return notes.count
        }
    }

    //每一个笔记的UI
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // MARK: 瀑布流布局 - 个人页面'笔记'瀑布流
        //个人页面‘笔记’中草稿cell显示条件: isMyDraft 为true并且横滑tab为第一个
        if isMyDraft, indexPath.item == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kMyDraftNoteWaterfallCellID, for: indexPath)
            return cell
        }else if isDraft{
            // MARK: 瀑布流布局 - 笔记草稿瀑布流
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kDraftNoteWaterfallCellID, for: indexPath) as! DraftNoteWaterfallCell
            cell.draftNote = draftNotes[indexPath.item]
            cell.deleteBtn.tag = indexPath.item         //获取被点击的删除按钮的索引
            cell.deleteBtn.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
            return cell
        }else{
            // MARK: 瀑布流布局 - HomeVC 瀑布流
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kWaterfallCellID, for: indexPath) as! WaterfallCell

            //需在给cell.note赋值前赋值,因note的didset里面需要用到这个变量
            cell.isMyselfLike = isMyselfLike            //isMyselfLike判断已登录用户是否在看自己的'赞过'tab页
            
            //情况1: 个人页面'笔记'中没有草稿cell, 首页的笔记数 = 个人页面'笔记'数量;
            //情况2: 个人页面'笔记'中有草稿cell, 首页的笔记数 = 个人页面'笔记'数量 - 1
            let offset = isMyDraft ? 1 : 0
            cell.note = notes[indexPath.item - offset]  //把云端笔记的每个对象传到首页“发现”页面
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
            
            UserDefaults.decrease(kDraftNoteCount)       //草稿笔记数递减1

            //UI操作,在主线程执行,若不在主线程完成,后台执行showTextHUD时会出现卡顿
            DispatchQueue.main.async {
            /* 用deleteItems会出现'index out of range'的错误,因为DataSource里面的index没有更新过来,故直接使用reloadData
                self.collectionView.performBatchUpdates {
                    self.collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
                }
             */
                self.collectionView.reloadData()
                self.showTextHUD("删除草稿成功")          //不跳转界面,默认选true
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
