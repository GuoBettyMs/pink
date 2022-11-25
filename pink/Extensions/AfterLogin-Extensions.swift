//
//  AfterLogin-Extensions.swift
//  pink
//
//  Created by isdt on 2022/10/10.
//
/*
     扩展 - 给云端新增用户信息
     判断是否首次登录 & 登录后的属性配置 & 退出登录界面
 */
import LeanCloud
extension UIViewController{
    
    // MARK: LeanCloud数据存储
    //详情见 https://leancloud.cn/docs/leanstorage_guide-swift.html#hash632374954
    func configAfterLogin(_ user: LCUser, _ nickName: String, _ email: String = ""){
        
        //判断是否首次登录
        if let _ = user.get(kNickNameCol){
            dismissAndShowMeVC(user)
        }else{
            //首次登录(即注册)
            //enter和leave成对出现,全部配对成功后再执行notify中内容,整个过程不会阻塞主线程(同时拥有同步和异步的好处)
            let group = DispatchGroup()
            
            // MARK: 云端数据存储 - 上传文件(头像图片)进云端
            let randomAvatar = UIImage(named: "avatarPH\(Int.random(in: 1...4))")!
            
            //pngData() 压缩图片节省资源
            if let avatarData = randomAvatar.pngData(){
                let avatarFile = LCFile(payload: .data(data: avatarData))           //构建文件
                avatarFile.mimeType = "image/jpeg"                                  //指定文件类型为图片
                
                //把文件作为某个字段关联到LCObject,存到云端
                avatarFile.save(to: user, as: kAvatarCol, group: group)
                /* 等同于1.将文件avatarFile保存到云端 2.把LCFile字段指定成对象关联的新字段 3.保存对象
                 group.enter()              //异步
                 avatarFile.save{ result in
                    switch result {
                    case .success:
                 
                        //将文件avatarFile保存到云端(avatarFile.save方法),可获得一个永久指向该文件的 URL,保存到云端的文件可以关联到LCObject
                        if let value = avatarFile.url?.value {
                            print("文件保存到云端成功。URL: \(value)")
                            
                            //把LCFile字段关联到对象user字段
                            do {
                                try user.set(kAvatarCol, value: avatarFile)          //指定云端需要关联的属性名kAvatarCol和属性值avatarFile
                                
                                //将对象保存到云端
                                group.enter()                                        //异步
                                user.save { (result) in
                                    switch result {
                                    case .success:
                                        print("文件已关联")
                                    case .failure(error: let error):
                                        print("文件关联失败。URL: \(error)")
                                    }
                                    group.leave()                                    //异步
                                }
                            } catch {
                                print("给User表的图片字段赋值失败: \(error)")
                            }
                        }
                    case .failure(error: let error):
                        // 保存失败，可能是文件无法被读取，或者上传过程中出现问题
                        print("文件保存到云端失败  \(error)")
                    }
                    group.leave()                                        //异步
                }
                */
                 
            }
            
            // MARK: 云端数据存储 - 更新对象并保存
            //给云端 User表的email、nickName赋值
            do {
                if email != ""{
                    user.email = LCString(email)
                }
                try user.set(kNickNameCol, value: nickName)               //指定需要更新的属性名kNickNameCol和属性值nickName
            } catch {
                print("给User表的email、nickName字段赋值失败: \(error)")
                return
            }
            group.enter()
            user.save { _ in group.leave() }                              //将对象保存到云端
            
            /* 等同于
            //给云端 User表的email、nickName赋值
            do {
                if email != ""{
                    user.email = LCString(email)                            //转为LCString形式给email赋值
                }
                try user.set(kNickNameCol, value: nickName)                 //指定需要更新的属性名kNickNameCol和属性值nickName
 
                // user.save 将对象保存到云端
                group.enter()                                       //异步
                user.save { (result) in
                    switch result {
                    case .success:
                        break
                    case .failure(error: let error):
                        print("更新对象失败: \(error)")
                    }
                    group.leave()                                       //异步
                }
            } catch {
                print("给User表的email、nickName字段赋值失败: \(error)")
                return
            }
             */
            

            //注册时同时给UserInfo表写入一行数据,方便之后取xxCount数据
            group.enter()
            let userInfo = LCObject(className: kUserInfoTable)
            try? userInfo.set(kUserObjectIdCol, value: user.objectId)    //设置登录用户的id标识符
            userInfo.save{ _ in group.leave()}
            
            group.notify(queue: .main) {
                self.dismissAndShowMeVC(user)
//                print("kNickNameCol: \(user.get(kNickNameCol)?.stringValue)")
//                print("kAvatarCol: \((user.get(kAvatarCol) as! LCFile).name?.stringValue)")
            }
        }
    }
    
    // MARK: 退出登录界面,显示个人页面
    func dismissAndShowMeVC(_ user: LCUser){
        hideLoadHUD()
        
        //把当前设备关联上当前登录的user,以便之后通过查询过滤Installation表给这个user的设备发送推送
        let installation = LCApplication.default.currentInstallation
        try? installation.set(kUserCol, value: user)
        installation.save{_ in}//有存入失败的可能性,若那样则此用户再也没机会收到推送了,故在appdelegate中继续处理
        
        DispatchQueue.main.async {
            let mainSB = UIStoryboard(name: "Main", bundle: nil)

            //因为初始化了自定义的user,要使用构造方法来获取 MeVC
            let meVC = mainSB.instantiateViewController(identifier: kMeVCID) { coder in
                MeVC(coder: coder, user: user)
            }
            
            loginAndMeParentVC.removeAllChildren()            //移除所有子视图控制器
            loginAndMeParentVC.add(child: meVC)               //添加个人页面     
            
            self.dismiss(animated: true)
        }
    }
}
