//
//  NoteEditVC-DraftNote.swift
//  pink
//
//  Created by isdt on 2022/9/28.
//
/*
    发布笔记编辑页面的 故事版事件 -  存草稿到本地
 */

extension NoteEditVC{
    
    // MARK: 一般函数 - 创建草稿
    func createDraftNote(){
        
        //后台线程执行
        backgroundContext.perform {
            let draftNote = DraftNote(context: backgroundContext)
           
            //视频转化为Data
            if self.isVideo {
                draftNote.video = try? Data(contentsOf: self.videoURL!)
            }
            self.handlePhotos(draftNote)                 //处理图片
            
            draftNote.isVideo = self.isVideo
            self.handleOthers(draftNote)                  //处理其他数据
           
            DispatchQueue.main.async {
                self.showTextHUD("创建草稿成功",false)             //UI操作,在主线程执行
            }
        }
        dismiss(animated: true)             //创建草稿后退出笔记编辑界面
    }
    
    // MARK: 一般函数 - 更新草稿
    func updateDraftNote(_ draftNote: DraftNote){
        
        //后台线程执行
        backgroundContext.perform {
            if !self.isVideo{
                self.handlePhotos(draftNote)             //处理图片数据
            }
            self.handleOthers(draftNote)                  //处理其他数据
            
            //UI操作,在主线程执行
            DispatchQueue.main.async {
                
                //更新草稿后获取新的草稿数据, WaterfallVC-Delegate.swift-40,因获取草稿数据时采用了菊花加载动画,故不再使用showTextHUD
                self.updateDraftNoteFinished?()
                self.showTextHUD("更新草稿成功",false)             //UI操作,在主线程执行
            }
        }
        navigationController?.popViewController(animated: true)         //返回草稿总页面
    }

}

extension NoteEditVC{
    
    // MARK: 创建/更新草稿 - 处理图片数据
    private func handlePhotos(_ draftNote: DraftNote){
        draftNote.coverPhoto = photos[0].jpeg(.high)            //封面图片
        
       //所有图片转化为Data
        var photos: [Data] = []
        for photo in self.photos{
            if let pngData = photo.pngData(){
                photos.append(pngData)
            }
        }
        draftNote.photos = try? JSONEncoder().encode(photos)
    }
    
    // MARK: 创建/更新草稿 - 处理其他数据
    private func handleOthers(_ draftNote: DraftNote){

        //UI操作,在主线程执行
        DispatchQueue.main.async {
            draftNote.title = self.titleTextField.exactText
            draftNote.text = self.textView.exactText
        }
        draftNote.channel = channel
        draftNote.subChannel = subChannel
        draftNote.poiName = poiName
        draftNote.updatedAt = Date()
        
        //保存
        appDelegate.saveBackgroundContext()
    }
    
}
