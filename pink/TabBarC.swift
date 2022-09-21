//
//  TabBarC.swift
//  LittlePinkBook
//
//  Created by isdt on 2022/9/15.
//
/*
    小粉书的底部导航栏
 */


import UIKit
import YPImagePicker
import AVFoundation

class TabBarC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print("MJRefresh, DateToolsSwift")
        
//        delegate = self
    }
 
}

//// MARK: 遵守 UITabBarControllerDelegate
//extension TabBarC: UITabBarControllerDelegate{
//
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        if viewController is PostVC{
//
//            //待做(判断是否登录)
//
//            var config = YPImagePickerConfiguration()
//
//            // MARK: 通用配置
//            config.isScrollToChangeModesEnabled = false //取消滑动切换，防止和编辑相册图片时的手势冲突
//            config.onlySquareImagesFromCamera = false //是否只让拍摄正方形照片
//            config.albumName = Bundle.main.appName //存图片进相册App的'我的相簿'里的文件夹名称(在本地设备中新建一个新文件夹,新文件夹名称为app名称)
//            config.startOnScreen = .library //一打开就展示相册
//            config.screens = [.library, .video, .photo] //依次展示相册，拍视频，拍照页面
//            config.maxCameraZoomFactor = kMaxCameraZoomFactor //最大多少倍变焦
//            /*
//            config.targetImageSize = YPImageSize.original
//            config.overlayView = UIView()           //支持翻转
//            config.hidesStatusBar = true            //隐藏手机的状态栏
//            config.hidesCancelButton = true
//            config.preferredStatusBarStyle = UIStatusBarStyle.default       //手机状态栏类型为默认
//            config.bottomMenuItemSelectedTextColour = UIColor(red: 38, green: 38, blue: 38, alpha: 1)       //底部菜单栏item 已选择的文本颜色
//            config.bottomMenuItemUnSelectedTextColour UIColor(red: 38, green: 38, blue: 38, alpha: 1)       //底部菜单栏item 未选择的文本颜色
//            config.filters = [DefaultYPFilters...]      //自定义滤镜
//             */
//
//
//
//            // MARK: 相册配置
//            /*
//             //小红书的照片和视频逻辑:
//             //1.照片和视频不可混排,且在相册中多选的视频最后会帮我们合成一个视频(即最终只能有一个视频)
//             //2.无论是相册照片还是现拍照片,之后在编辑页面皆可追加
//             //总结:允许一个笔记发布单个视频或多张照片
//
//            config.library.onlySquare = false     //将图片自动扩大为正方形
//            config.library.minWidthForItem = nil
//            config.library.mediaType = YPlibraryMediaType.photo
//            config.library.minNumberOfItems = 1
//            config.library.numberOfItemsInRow = 4
//            config.library.skipSelectionsGallery = false            //多选图片时,是否允许跳过图片的编辑画面
//            config.library.preselectedItems = nil       //指定用户使用哪种媒体设备
//             */
//
//            config.library.defaultMultipleSelection = true //是否可多选
//            config.library.maxNumberOfItems = kMaxPhotoCount //最大选取照片或视频数
//            config.library.spacingBetweenItems = kSpacingBetweenItems //照片缩略图之间的间距
//
//            // MARK: 视频配置(参照文档,此处全部默认)
//            /*
//            config.video.compression = AVAssetExportPresetHighestQuality    //图片画质
//            config.video.fileType = .mov            //剪辑后的文件类型为 .mov
//            config.video.recordingTimeLimit = 60.0   //用户记录的最大时长
//            config.video.libraryTimeLimit = 60.0     //用户能从相册选取最大时长为60的视频
//            config.video.minimumTimeLimit = 3.0      //用户记录的最小时长
//            config.video.trimmerMaxDuration = 60.0    //小于最大时长才能允许用户剪辑
//            config.video.trimmerMinDuration = 3.0     //超过最小时长才能允许用户剪辑
//            */
//            // MARK: - Gallery(多选完后的展示和编辑页面)-画廊
//            config.gallery.hidesRemoveButton = false //每个照片或视频右上方是否有删除按钮
//
//
//            let picker = YPImagePicker(configuration: config)
//            /*
//             let picker = YPImagePicker(configuration: config) 等同于以下代码
//
//            YPImagePickerConfiguration.shared = config
//            let picker = YPImagePicker()
//
//             当在iPad展示 picker 时,需设置尺寸
//             let preferredContentSize = CGSize(width: 500,height: 600)
//             YPImagePickerConfiguration.widthOniPad = preferredContentSize.width
//
//             */
//
//            // MARK: 选完或按取消按钮后的异步回调处理（依据配置处理单个或多个）
//            picker.didFinishPicking { [unowned picker] items, cancelled in
//                if cancelled{
//                    print("用户按了左上角的取消按钮")
//                }
//
//                /*
//                if let photo = items.singlePhoto{
//                    print(photo.fromCamera)     //图片来源(相机或者相册)
//                    print(photo.image)          //用户选择的最后图片(可能添加滤镜)
//                    print(photo.originalImage)   //用户选择的原图(未添加滤镜)
//                }
//
//                 for item in items {
//                 /*     判断枚举类型并取出关联值
//                     switch item {
//                        case .photo(let photo):
//                            print(photo)
//                        case .video(let video):
//                            print(video)
//                     }
//                 */
//
//                 //判断并取出关联值的简写
//                    if case let .photo(photo) = item {
//                        photo
//                 }
//
//                 */
//                picker.dismiss(animated: true)
//            }
//            present(picker, animated: true)
//
//            return false
//        }
//
//        return true
//
//    }
//}

