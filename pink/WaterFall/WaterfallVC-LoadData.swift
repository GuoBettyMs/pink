//
//  WaterfallVC-LoadData.swift
//  pink
//
//  Created by isdt on 2022/9/29.
//
/*
    瀑布流布局的 viewDidLoad 内容
 */

import CoreData
import LeanCloud

extension WaterfallVC{
    
    // MARK: 从本地取出我的草稿
    func getDraftNotes(){
        
        let request = DraftNote.fetchRequest() as NSFetchRequest<DraftNote>
        
        /*
        //分页(上拉加载)
        request.fetchLimit = 20         //相当于高德SDK的offset, 指请求数量
        request.fetchOffset = 0         //请求数据从第1个到第20个;再次请求时,从第21个到第40个
        
        //筛选
        //筛选出标题为"iOS"的数据
        request.predicate = NSPredicate(format: "title = %@", "iOS")
        */
        
        
        //按照key排序(ascending: false 从早到晚; ascending: true 从晚到早)
        let sortDescriptor1 = NSSortDescriptor(key: "updatedAt", ascending: false)
        //let sortDescriptor2 = NSSortDescriptor(key: "title", ascending: true) //文本的话按汉字的UNICODE编码或英文字母
        request.sortDescriptors = [sortDescriptor1]         //数组中谁在前谁优先
        
        /*
        //Fault--有缺陷的数据(如下),只在需要时加载数据(类似懒加载)--提高性能
        // <DraftNote: 0x600003181180> (entity: DraftNote; id: 0x86431deb76afbec7 <x-coredata://CDCE4C09-7C03-4502-B5F7-22D358108754/DraftNote/p5>; data: <fault>)
         
         request.returnsObjectsAsFaults = true               //默认true,无需设置
         let draftNotes = try! context.fetch(request)
         print(draftNotes)
         print(draftNotes[0].title)
         print(draftNotes)
         self.draftNotes = draftNotes
         
        //一开始只加载draftNotes的metadata(放入内存)
        //等实际访问到某个draftNote下面的某个属性的时候才加载此draftNote所有属性到内存--触发Fault
        
         */
        
        //指定字段--提高性能
        //访问的某个draftNote下面的属性若已在propertiesToFetch中指定,则访问此属性不会触发Fault,访问其他属性会触发Fault
        request.propertiesToFetch = ["coverPhoto", "title", "updatedAt", "isVideo"]
        
        showLoadHUD()
        
        //后台线程执行
        backgroundContext.perform {
            if let draftNotes = try? backgroundContext.fetch(request){
                self.draftNotes = draftNotes
                
                //UI操作,在主线程执行
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            self.hideLoadHUD()
        }

    }
    
    // MARK: 首页 - 从云端取出<所有>用户发布的笔记
    @objc func getNotes(){
        
        //基础查询
        let query = LCQuery(className: kNoteTable)
        query.whereKey(kChannelCol, .equalTo(channel))      //根据横滑话题进行基础查询
        query.whereKey(kAuthorCol, .included)               //查询笔记作者,并包含各自对应的博客文章
        query.whereKey(kUpdatedAtCol, .descending)
        query.limit = kNotesOffset                          //上拉加载的分页
        query.find { result in
            switch result {
            case .success(objects: let notes):
                // notes 是包含满足条件的 objects 对象的数组
                self.notes = notes
                print("notes : \(notes)")           //需要把AppDelegate的LCApplication.logLevel改为 .debug
                self.collectionView.reloadData()
                break
            case .failure(error: let error):
                print("云端基础查询失败: \(error)")
            }
            /* 等同于
             if case let .success(objects: notes) = result{
                 self.notes = notes
                 self.collectionView.reloadData()
             }
             */
            DispatchQueue.main.async {
                self.header.endRefreshing()
            }
        }
    }
}
