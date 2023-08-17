//
//  NoteDetailVC-EditNote.swift
//  pink
//
//  Created by gbt on 2022/11/7.
//
/*
    笔记是用户自己的笔记 -> 笔记右上角的编辑功能
 */
import LeanCloud
import Kingfisher

extension NoteDetailVC{
    // MARK: 监听自己笔记 - 编辑事件
    func editNote(){
        
        // MARK: 编辑 - 从缓存(内存)中获取当前笔记的图片
        var photos: [UIImage] = []
        
        //获取云端第一张图片(即封面)的url路径,并转为string类型
        if let coverPhotoPath = (note.get(kCoverPhotoCol) as? LCFile)?.url?.stringValue,
            //通过得到的string,获取内存缓存中的封面图片
            let coverPhoto = ImageCache.default.retrieveImageInMemoryCache(forKey: coverPhotoPath){
                photos.append(coverPhoto)
        }
        
        //获取除封面外的其他云端图片数组的url路径,并转为string类型数组
        if let photoPaths = note.get(kPhotosCol)?.arrayValue as? [String]{
            let otherPhotos = photoPaths.compactMap{ ImageCache.default.retrieveImageInMemoryCache(forKey: $0)}
            /*  append(contentsOf:) 往数组中添加一系列元素,
             var numbers = [1, 2, 3, 4, 5]
             numbers.append(contentsOf: 10...15)
             print(numbers)
             // Prints "[1, 2, 3, 4, 5, 10, 11, 12, 13, 14, 15]"
             */
            photos.append(contentsOf: otherPhotos)
        }
//        print(photos)
        
        // MARK: 编辑 - 把笔记内容传入到用户自己笔记的编辑界面
        let noteEditVC = storyboard!.instantiateViewController(identifier: kNoteEditVCID) as! NoteEditVC
        noteEditVC.editMyNote = note//将正在浏览的笔记内容note,传到用户自己笔记的编辑界面
        noteEditVC.photos = photos
        noteEditVC.videoURL = nil//此处省略视频处理,可搜索类似Kingfisher的视频处理(播放器),然后从缓存中取
        noteEditVC.updateNoteFinished = { noteID in //NoteEditVC-Note.swift(224)获得string类型的索引
            //通过索引获取用户编辑完自己笔记后的最新笔记
            let query = LCQuery(className: kNoteTable)
            query.get(noteID){res in//查询索引找到对应的笔记,更新数据和更新UI
                if case let .success(object: note) = res {
                    //笔记和笔记作者是多对一关系,更新笔记时并没有重新上传笔记作者信息,因此在NoteDetailVC.swift 中的author计算属性,获取到的作者信息是空值
                    self.note = note
                    self.showNote(true)//为防止更新笔记后,UI上作者信息为空,showNote()函数增加判断值
                }
            }
        }
        noteEditVC.modalPresentationStyle = .fullScreen
        present(noteEditVC, animated: true)
        
    }
}
