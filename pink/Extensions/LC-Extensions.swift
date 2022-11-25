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
//                                print("文件已关联/文件已存入\(record)字段")
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

extension LCObject{
    // MARK: 扩展 - 取出云端对象的不同类型字段数据
    func getExactStringVal(_ col: String) -> String { get(col)?.stringValue ?? "" }
    func getExactIntVal(_ col: String) -> Int { get(col)?.intValue ?? 0 }
    func getExactDoubelVal(_ col: String) -> Double { get(col)?.doubleValue ?? 1 }  //这里取1,方便大多数情况使用
    func getExactBoolValDefaultF(_ col: String) -> Bool { get(col)?.boolValue ?? false }            //查询不到字段则返回false(如性别)
    func getExactBoolValDefaultT(_ col: String) -> Bool { get(col)?.boolValue ?? true }     //查询不到字段则返回true(如查hasReply字段)
    
    enum imageType {
        case avatar
        case coverPhoto
    }
    
    // MARK: 扩展 - 取出云端对象path
    //从云端的某个file(image类型)字段取出path再变成URL
    func getImageURL(from col: String, _ type: imageType) -> URL{
        if let file = get(col) as? LCFile, let path = file.url?.stringValue, let url = URL(string: path) {
            //加载成功
            return url
        }else{
            //加载失败
            switch type{
            case .avatar:
                //头像图片返回xcode文件的avatarPH.jpeg
                return Bundle.main.url(forResource: "avatarPH", withExtension: "jpeg")!
            case .coverPhoto:
                //封面图片返回xcode文件的imagePH.png
                return Bundle.main.url(forResource: "imagePH", withExtension: "png")!
            }
        }
    }
    
    // MARK: 为userInfo表里面某个字段递增1
    static func userInfoIncrease(where userObjectId: String, increase col: String){
        let query = LCQuery(className: kUserInfoTable)
        query.whereKey(kUserObjectIdCol, .equalTo(userObjectId))        //笔记作者的id标记符
        query.getFirst { res in
            if case let .success(object: userInfo) = res{               //得到个人信息表
                try? userInfo.increase(col)                             //某个字段递增1
                userInfo.save{ _ in }
            }
        }
    }
    
    // MARK: 为userInfo表里面某个字段递减1--设为当前数量
    static func userInfoDecrease(where userObjectId: String, decrease col: String, to: Int){
        let query = LCQuery(className: kUserInfoTable)
        query.whereKey(kUserObjectIdCol, .equalTo(userObjectId))        //笔记作者的id标记符
        query.getFirst { res in
            if case let .success(object: userInfo) = res{               //得到个人信息表
                try? userInfo.set(col, value: to)                       //递减1--某个字段设为当前数量
                userInfo.save{ _ in }
            }
        }
    }

}
