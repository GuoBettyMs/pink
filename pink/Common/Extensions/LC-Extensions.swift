//
//  LC-Extensions.swift
//  pink
//
//  Created by isdt on 2022/10/10.
//
/*
     扩展 - 云端后台
 */
import LeanCloud

extension LCFile{

    // MARK: 云端后台 - 把文件作为某个字段关联到LCObject,存到云端
    func save(to table: LCObject, as record: String, group: DispatchGroup? = nil){
        group?.enter()
        self.save { result in
            switch result {
            case .success:
                if let _ = self.objectId?.value {
                    //print("文件保存完成。objectId: \(value)")
                    do {
                        try table.set(record, value: self)       //指定云端需要关联的属性名kAvatarCol和属性值avatarFile
                        group?.enter()
                        
                        //将对象保存到云端
                        table.save { (result) in
                            switch result {
                            case .success:
                                //print("文件已关联/文件已存入字段")
                                break
                            case .failure(error: let error):
                                print("保存表的数据失败: \(error)")
                            }
                            group?.leave()
                        }
                    } catch {
                        print("给User表的字段赋值失败: \(error)")
                    }
                }
            case .failure(error: let error):
                // 保存失败，可能是文件无法被读取，或者上传过程中出现问题
                print("保存文件进云端失败: \(error)")
            }
            group?.leave()
        } 
    }
}
