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
        note.delete { res in
            if case .success = res {
                //用户表的noteCount减1
                try? self.author?.set(kNoteCountCol, value: self.author!.getExactIntVal(kNoteCountCol) - 1)
                self.author?.save(completion: { _ in })
                
                //UI操作,在主线程执行,若不在主线程完成,后台执行showTextHUD时会出现卡顿
                DispatchQueue.main.async {
                    self.showTextHUD("笔记已删除")
                }
 
            }
        }
    }
    
}

