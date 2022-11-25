//
//  EditProfileTableVC-Delegate.swift
//  pink
//
//  Created by gbt on 2022/11/16.
//
/*
    ’编辑资料‘页面-遵守tableView Delegate,显示个人页面的信息
 */

import PhotosUI //调用PHPickerConfiguration()
import ActionSheetPicker_3_0
import DateToolsSwift

extension EditProfileTableVC{
    // MARK: 遵守tableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        switch indexPath.row{
        case 0 ://不需要增加break,只会执行case 0 内容
            var config = PHPickerConfiguration()
            config.filter = .images     //picker 显示内容,目前不支持照相
            config.selectionLimit = 1   //可选择的最大数量
            
            //PHPickerConfiguration 即将全面替代UIImagePickerController的照片视频选择器
            let vc = PHPickerViewController(configuration: config)
            vc.delegate = self
            present(vc, animated: true)
        case 1:
            showTextHUD("修改昵称,和修改简介一样.这里需做一些限制")
        case 2:
            //多项选择器
//            ActionSheetMultipleStringPicker.show(withTitle: "Multiple String Picker", rows: [
//                       ["One", "Two", "A lot"],
//                       ["Many", "Many more", "Infinite"]
//                       ], initialSelection: [2, 2], doneBlock: {
//                           picker, indexes, values in
//
//                           print("values = \(values)")
//                           print("indexes = \(indexes)")
//                           print("picker = \(picker)")
//                           return
//                   }, cancel: { ActionMultipleStringCancelBlock in return }, origin: cell)
            
            //单项选择器
            /*  未接收个人页面初始信息setUI()时
             //getExactBoolValDefaultF查找Bool字段,若字段为ture返回0,字段为false返回1(查找不到Bool字段,则Bool字段为false,结果返回1)
             var initialSection = user.getExactBoolValDefaultF(kGenderCol) ? 0 : 1
             
             //选择器选项保存上一次的选择
             if let gender = gender {
                 //如果第一个gender有值,则初始值为上一次的选择
                 initialSection = gender ? 0 : 1 //gender 可能为空,故属性gender要guard let ...else {return}
             }
             
             let acp = ActionSheetStringPicker(
                 title: nil,
                 rows: ["男","女"],
                 initialSelection: initialSection,
                 doneBlock: { (_, index, _) in self.gender = index == 0 },
                 cancel: { _ in },
                 origin: cell)
             acp?.show()
             */
            
            let acp = ActionSheetStringPicker(
                title: nil,
                rows: ["男","女"],
                initialSelection: gender ? 0 : 1, //初始选项,个人页面gender
                doneBlock: { (_, index, _) in self.gender = index == 0 },
                cancel: { _ in },
                origin: cell)
            acp?.show()

        case 3:
            /*  未接收个人页面初始信息setUI()时
             var selectedDate = Date().subtract(TimeChunk(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: 20))    //选择器时间在2000附近

             //若用户再次设置birth
             if let birth = birth{
                 selectedDate = birth
             }else if let birth = user.get(kBirthCol)?.dateValue{ //若用户没有设置birth,云端获取birth
                 selectedDate = birth
             }
             
             let dataPicker = ActionSheetDatePicker(
                 title: nil,
                 datePickerMode: .date,
                 selectedDate: selectedDate,
                 doneBlock: { _, date, _ in
                     self.birth = date as? Date
                 },
                 cancel: {_ in},
                 origin: cell)
             
             //最早和最晚日期
             dataPicker?.minimumDate = Date().subtract(TimeChunk(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: 40))
             dataPicker?.maximumDate = Date()
             
             dataPicker?.show()
            */
            
            //日期选择器
            var selectedDate = Date().subtract(TimeChunk(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: 20))    //选择器时间在2000附近

            if let birth = birth{ selectedDate = birth }    //接收个人页面birth
            
            let dataPicker = ActionSheetDatePicker(
                title: nil,
                datePickerMode: .date,
                selectedDate: selectedDate,
                doneBlock: { _, date, _ in
                    self.birth = date as? Date
                },
                cancel: {_ in},
                origin: cell)
            
            //最早和最晚日期
            dataPicker?.minimumDate = Date().subtract(TimeChunk(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: 40))
            dataPicker?.maximumDate = Date()
            
            dataPicker?.show()
        case 4:
            /*  未接收个人页面初始信息setUI()时
             let vc = storyboard!.instantiateViewController(identifier: kIntroVCID) as! IntroVC
             vc.intro = user.getExactStringVal(kIntroCol)
             vc.delegate = self
             present(vc, animated: true)
             */
            
            //和个人页编辑简介差不多,此处正向传值需传全局变量intro
            let vc = storyboard!.instantiateViewController(identifier: kIntroVCID) as! IntroVC
            vc.intro = intro    //UI
            vc.delegate = self  //接收个人页面intro
            present(vc, animated: true)
        default:
            break
            
        }
        
    }
}

extension EditProfileTableVC: IntroVCDelegate{
    //接收个人页面intro
    func updateIntro(_ intro: String) {
        self.intro = intro
    }
}
