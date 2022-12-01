//
//  NoteDetailVC-DelNote.swift
//  pink
//
//  Created by gbt on 2022/11/7.
//
/*
    笔记是用户自己的笔记 -> 笔记右上角的删除功能
 */
import LeanCloud

extension NoteDetailVC{
    // MARK: 监听自己笔记 - 删除事件
    func delNote(){
        //对”删除“弹框提示进行封装
        showDelAlert(for: "笔记") { _ in
            self.delLCNote()//删除云端笔记
            self.dismiss(animated: true){
                self.delNoteFinished?()//闭包
            }
        }
    }

    
    private func delLCNote(){
        
//        note.delete { res in
//            if case .success = res{
//                //用户表的noteCount减1,但有时云端未及时更新noteCount
//                try? self.author?.set(kNoteCountCol, value: self.author!.getExactIntVal(kNoteCountCol) - 1)
//                self.author?.save{ _ in }
//
//                DispatchQueue.main.async {
//                    self.showTextHUD("笔记已删除")
//                }
//            }
//        }
        
        var counts = 0
        let author = LCApplication.default.currentUser!
        let query = LCQuery(className: kNoteTable)
        query.whereKey(kAuthorCol, .equalTo(author))//条件查询
        query.whereKey(kAuthorCol, .included)//同时查询出作者对象
        query.whereKey(kUpdatedAtCol, .descending)//排序,获取最新发布的
        
        query.find { result in
            if case let .success(objects: notes) = result{
//                print("作者笔记总数 noteCount: \(notes.count)")
                counts = notes.count
            }
        }

        note.delete { res in
            if case .success = res {
                //用户表的noteCount 设置为当前笔记总数
                try? self.author?.set(kNoteCountCol, value: counts - 1)
                self.author?.save{ _ in }

                //UI操作,在主线程执行,若不在主线程完成,后台执行showTextHUD时会出现卡顿
                DispatchQueue.main.async {
                    self.showTextHUD("笔记已删除")
                }
                print("删除后 kNoteCountCol:  \(counts - 1) ,getExactIntVal(kNoteCountCol): \(self.author!.getExactIntVal(kNoteCountCol) - 1)")//有时获取的noteCount未及时减1
            }
        }
    }
    
}

