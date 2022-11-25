//
//  NoteEditVC-Note.swift
//  pink
//
//  Created by isdt on 2022/10/12.
//
/*
    发布新笔记
 */
import LeanCloud

extension NoteEditVC{
     
    // MARK: 发布新笔记到云端
    func createNote(){
        do{
            let noteGroup = DispatchGroup()
            
            //创建云端表格
            let note = LCObject(className: kNoteTable)
            
            // MARK: 云端存储 - 单个文件
            //存储单个图片或视频存进云端
            if let videoURL = self.videoURL{
                let video = LCFile(payload: .fileURL(fileURL: videoURL))
                video.save(to: note, as: kVideoCol, group: noteGroup)
            }
            
            //存储封面图片进云端
            if let coverPhotoData = photos[0].jpeg(.high){            //对图片进行压缩处理
                let coverPhoto = LCFile(payload: .data(data: coverPhotoData))
//                coverPhoto.mimeType = "image/jpeg"
                coverPhoto.save(to: note, as: kCoverPhotoCol, group: noteGroup)
            }
            
            // MARK: 云端存储 - 多个文件
            //存为[LCFile]类型最后会变成[Pointer]类型(里面无path,不方便之后的取操作),需存为以下类型:
            //["https://1.jpg", "https://2.jpg", "https://3.jpg"]
            
            let photoGroup = DispatchGroup()
            
            //1.把所有的文件存进云端
            var photoPaths: [Int: String] = [:]
            for (index, eachPhoto) in photos.enumerated(){
                if let eachPhoto = eachPhoto.jpeg(.high){               //对图片进行压缩处理
                    let photo = LCFile(payload: .data(data: eachPhoto))
                    photoGroup.enter()
                    //存储eachPhoto到photoPaths数组
                    photo.save{ res in
//                        print("第\(index)Photo文件保存进云端成功")
                        if case .success = res, let path = photo.url?.stringValue {
                            photoPaths[index] = path
                            //结果: photoPaths(无序): [0: "https://1.jpg", 1: "https://2.jpg", 2: "https://3.jpg", ...]
                        }
                        photoGroup.leave()
                    }
                }
            }
            
            //2.得到photoPaths数组(即所有的path)后进行排序,并把排序后的path数组存入表中对应的字段里
            noteGroup.enter()
            photoGroup.notify(queue: .main) {
                //var dic = [1: "aa", 3: "cc", 2: "bb", 4: "dd"]
                //let sortedDic = dic.sorted(by: <)//通过排序变成元祖数组
                //print(sortedDic)
                //[(key: 1, value: "aa"), (key: 2, value: "bb"), (key: 3, value: "cc"), (key: 4, value: "dd")]
                //$0代表每个key,map+sorted后变成按照首字母顺序排序的数组
                //对所有的path进行排序得到新数组,取出新数组的第一个photoPathsArr
                let photoPathsArr = photoPaths.sorted(by: <).map{$0.value}
                //photoPathsArr 保存到云端表中对应的字段kPhotosCol
                do{
                    try note.set(kPhotosCol, value: photoPathsArr)
                    note.save { _ in
//                        print("Photo文件存储到云端表中对应的Photo字段成功")
                        noteGroup.leave()
                    }
                }catch{
                    print("photo字段赋值失败: \(error)")
                }
                
            }
            
            // MARK: 云端存储 - 一般类型
            //封面图宽高比
            let coverPhotoSize = photos[0].size
            let coverPhotoRatio = Double(coverPhotoSize.height / coverPhotoSize.width)
            
            //存储普通数据进云端
            try note.set(kCoverPhotoRatioCol, value: coverPhotoRatio)
            try note.set(kTitleCol, value: titleTextField.exactText)
            try note.set(kTextCol, value: textView.exactText)
            try note.set(kChannelCol, value: channel.isEmpty ? "推荐" : channel)
            try note.set(kSubChannelCol, value: subChannel)
            try note.set(kPOINameCol, value: poiName)
            try note.set(kLikeCountCol, value: 0)           //点赞字段
            try note.set(kFavCountCol, value: 0)            //收藏字段
            try note.set(kCommentCountCol, value: 0)

            //存储笔记的作者进云端
            let author = LCApplication.default.currentUser!
            try note.set(kAuthorCol, value: author)
            
            //保存
            noteGroup.enter()
            note.save { _ in
//                print("存储一般数据进云端成功")
                noteGroup.leave()
            }
            
            //UI操作,在主线程执行,若不在主线程完成,后台执行showTextHUD时会出现卡顿
            noteGroup.notify(queue: .main) {
//                print("笔记内容全部存储到云端结束")
                
                //请求通知权限.可根据实际业务逻辑灵活放置
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                    if let error = error{ print("请求通知授权出错: \(error)") }
                }
                
                //当用户发表过较多笔记时,判断用户对通知的授权状态
                //若notDetermined(从来未授权过)则请求权限,若denied(拒绝授权)则弹出自定义请求权限框引导用户授权(因系统弹框只弹一次)
                let noteCount = author.getExactIntVal(kNoteCountCol)
                //笔记是3的倍数时,弹出自定义请求权限框
                if noteCount != 0, noteCount % 3 == 0{ self.showAllowPushAlert() }

                //用户表的noteCount增1
                try? author.increase(kNoteCountCol)
                author.save{ _ in }
                
                self.showTextHUD("发布笔记成功", false)           //跳转界面,选false
            }
            
            if draftNote != nil{
                navigationController?.popViewController(animated: true)         //回到本地草稿页面
            }else{
                dismiss(animated: true)
            }
        }catch{
           showTextHUD("字段赋值失败: \(error)")
        }
        
    }
    
    // MARK: 将草稿作为笔记存到云端
    func postDraftNote(_ draftNote: DraftNote){
        createNote()        //将笔记存到云端
        
        //发布草稿笔记时需删掉这个草稿
        backgroundContext.perform {
            backgroundContext.delete(draftNote)
            appDelegate.saveBackgroundContext()
            
            //UI
            DispatchQueue.main.async {
                self.postDraftNoteFinished?()           //获取新的草稿数据
            }
        }
    }
    
    // MARK: 更新笔记(用户重新发布自己之前写过的笔记)
    func updateNote(_ editMyNote: LCObject){
        do{
            let noteGroup = DispatchGroup()
            
            if !isVideo{
                //存储封面图片进云端
                if let coverPhotoData = photos[0].jpeg(.high){            //对图片进行压缩处理
                    let coverPhoto = LCFile(payload: .data(data: coverPhotoData))
    //                coverPhoto.mimeType = "image/jpeg"
                    coverPhoto.save(to: editMyNote, as: kCoverPhotoCol, group: noteGroup)
                }
                
                // MARK: 云端存储 - 多个文件
                //存为[LCFile]类型最后会变成[Pointer]类型(里面无path,不方便之后的取操作),需存为以下类型:
                //["https://1.jpg", "https://2.jpg", "https://3.jpg"]
                
                let photoGroup = DispatchGroup()
                
                //1.把所有的文件存进云端
                var photoPaths: [Int: String] = [:]
                for (index, eachPhoto) in photos.enumerated(){
                    if let eachPhoto = eachPhoto.jpeg(.high){               //对图片进行压缩处理
                        let photo = LCFile(payload: .data(data: eachPhoto))
                        photoGroup.enter()
                        //存储eachPhoto到photoPaths数组
                        photo.save{ res in
    //                        print("第\(index)Photo文件保存进云端成功")
                            if case .success = res, let path = photo.url?.stringValue {
                                photoPaths[index] = path
                                //结果: photoPaths(无序): [0: "https://1.jpg", 1: "https://2.jpg", 2: "https://3.jpg", ...]
                            }
                            photoGroup.leave()
                        }
                    }
                }
                
                //2.得到photoPaths数组(即所有的path)后进行排序,并把排序后的path数组存入表中对应的字段里
                noteGroup.enter()
                photoGroup.notify(queue: .main) {
                    //var dic = [1: "aa", 3: "cc", 2: "bb", 4: "dd"]
                    //let sortedDic = dic.sorted(by: <)//通过排序变成元祖数组
                    //print(sortedDic)
                    //[(key: 1, value: "aa"), (key: 2, value: "bb"), (key: 3, value: "cc"), (key: 4, value: "dd")]
                    //$0代表每个key,map+sorted后变成按照首字母顺序排序的数组
                    //对所有的path进行排序得到新数组,取出新数组的第一个photoPathsArr
                    let photoPathsArr = photoPaths.sorted(by: <).map{$0.value}
                    //photoPathsArr 保存到云端表中对应的字段kPhotosCol
                    do{
                        try editMyNote.set(kPhotosCol, value: photoPathsArr)
                        editMyNote.save { _ in
    //                        print("Photo文件存储到云端表中对应的Photo字段成功")
                            noteGroup.leave()
                        }
                    }catch{
                        print("photo字段赋值失败: \(error)")
                    }
                }
            }
            
            // MARK: 云端存储 - 一般类型
            //封面图宽高比
            let coverPhotoSize = photos[0].size
            let coverPhotoRatio = Double(coverPhotoSize.height / coverPhotoSize.width)
            
            //存储普通数据进云端
            try editMyNote.set(kCoverPhotoRatioCol, value: coverPhotoRatio)
            try editMyNote.set(kTitleCol, value: titleTextField.exactText)
            try editMyNote.set(kTextCol, value: textView.exactText)
            try editMyNote.set(kChannelCol, value: channel.isEmpty ? "推荐" : channel)
            try editMyNote.set(kSubChannelCol, value: subChannel)
            try editMyNote.set(kPOINameCol, value: poiName)
 
            try editMyNote.set(kHasEditCol, value: true)
            //保存
            noteGroup.enter()
            editMyNote.save { _ in
//                print("存储一般数据进云端成功")
                noteGroup.leave()
                
            }
            
            //UI操作,在主线程执行,若不在主线程完成,后台执行showTextHUD时会出现卡顿
            noteGroup.notify(queue: .main) {
//                print("笔记内容全部存储到云端结束")
                self.updateNoteFinished?(editMyNote.objectId!.stringValue!)//笔记获取完成编辑后,调用闭包,传递此笔记的索引
                self.showTextHUD("更新自己笔记成功", false)           //跳转界面,选false
            }
            dismiss(animated: true)
        }catch{
           showTextHUD("字段赋值失败: \(error)")
        }
        
    }
    
}
