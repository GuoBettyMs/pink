//
//  EditProfileTableVC-PHPickerVCDelegate.swift
//  pink
//
//  Created by gbt on 2022/11/16.
//
/*
    个人页面的编辑资料-遵守PickerView Delegate
 */
import PhotosUI

extension EditProfileTableVC: PHPickerViewControllerDelegate{
    // MARK: 遵守PHPickerViewControllerDelegate - 在‘编辑资料’显示picker选择的内容
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        /*
         //多选时这样取:
         let itemProviders = results.map(\.itemProvider)
         results.map(\.itemProvider) 相当于 results.map { $0.itemProvider }
         这里的'\'和'$0'都是指数组里的每个元素
         
         let itemProvider = itemProviders.first //取多个元素中的第一个
         */
        
        //单选时这样取:
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self){
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                guard let self = self, let image = image as? UIImage else { return }
                
                /*
                 //loadObject(ofClass 是闭包函数,UI需要在主线程执行
                 DispatchQueue.main.async {
                     self.avatarImgView.image = image   //本次传值是一次性数据,只能将头像传到‘编辑资料’,无法传到‘个人简介’主页,因此定义全局变量avatar用来传值
                 }
                 */
                self.avatar = image
            }
        }
        
    }
}
