//
//  TabBarC.swift
//  LittlePinkBook
//
//  Created by isdt on 2022/9/15.
//
/*
    小粉书的底部导航栏功能:
    1.主页
    2.商场
    3.发布
    4.信息
    5.个人
 */


import UIKit
import YPImagePicker
import LeanCloud

class TabBarC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }

}

extension TabBarC: UITabBarControllerDelegate{

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        // MARK: 遵守 UITabBarControllerDelegate - 发布功能
        if viewController is PostVC{

            //判断是否登录
            if let _ = LCApplication.default.currentUser{
                
                // MARK: 选择器属性
                //属性 - 通用配置
                var config = YPImagePickerConfiguration()
                config.isScrollToChangeModesEnabled = false //取消滑动切换，防止和编辑相册图片时的手势冲突
                config.onlySquareImagesFromCamera = false //是否只让拍摄正方形照片
                config.albumName = Bundle.main.appName //存图片进相册App的'我的相簿'里的文件夹名称(在本地设备中新建一个新文件夹,新文件夹名称为app名称)
                config.startOnScreen = .library //一打开就展示相册
                config.screens = [.library, .video, .photo] //依次展示相册，拍视频，拍照页面
                config.maxCameraZoomFactor = kMaxCameraZoomFactor //最大多少倍变焦
                //拍视频后的剪辑处理
                //此包会把拍摄的视频往上移,导致下面多出黑色,遂取消剪辑,从tmp文件夹取出原视频并自己制作封面
                config.showsVideoTrimmer = false
                /*
                 config.targetImageSize = YPImageSize.original
                 config.overlayView = UIView()           //支持翻转
                 config.hidesStatusBar = true            //隐藏手机的状态栏
                 config.hidesCancelButton = true
                 config.preferredStatusBarStyle = UIStatusBarStyle.default       //手机状态栏类型为默认
                 config.bottomMenuItemSelectedTextColour = UIColor(red: 38, green: 38, blue: 38, alpha: 1)       //底部菜单栏item 已选择的文本颜色
                 config.bottomMenuItemUnSelectedTextColour UIColor(red: 38, green: 38, blue: 38, alpha: 1)       //底部菜单栏item 未选择的文本颜色
                 config.filters = [DefaultYPFilters...]      //自定义滤镜
                 */
                
                // 属性 - 相册配置
                config.library.mediaType = YPlibraryMediaType.photoAndVideo     //相册显示图片&视频
                config.library.defaultMultipleSelection = true //是否可多选
                config.library.maxNumberOfItems = kMaxPhotoCount //最大选取照片或视频数
                config.library.spacingBetweenItems = kSpacingBetweenItems //照片缩略图之间的间距
                /*
                 //<#注:小红书的照片和视频逻辑:#>
                 //1.照片和视频不可混排,且在相册中多选的视频最后会帮我们合成一个视频(即最终只能有一个视频)
                 //2.无论是相册照片还是现拍照片,之后在编辑页面皆可追加
                 //总结:允许一个笔记发布单个视频或多张照片
                 
                 config.library.onlySquare = false     //将图片自动扩大为正方形
                 config.library.minWidthForItem = nil
                 config.library.minNumberOfItems = 1
                 config.library.numberOfItemsInRow = 4
                 config.library.skipSelectionsGallery = false            //多选图片时,是否允许跳过图片的编辑画面
                 config.library.preselectedItems = nil       //指定用户使用哪种媒体设备
                 */
                
                // 属性 - 视频配置(参照文档,此处全部默认)
                
                /*
                 config.video.compression = AVAssetExportPresetHighestQuality    //压缩视频画质
                 config.video.fileType = .mov            //剪辑后的文件类型为 .mov
                 config.video.recordingTimeLimit = 60.0   //用户记录的最大时长
                 config.video.libraryTimeLimit = 60.0     //用户能从相册选取最大时长为60的视频
                 config.video.minimumTimeLimit = 3.0      //用户记录的最小时长
                 config.video.trimmerMaxDuration = 60.0    //小于最大时长才能允许用户剪辑
                 config.video.trimmerMinDuration = 3.0     //超过最小时长才能允许用户剪辑
                 */
                // 属性 - Gallery(多选完后的展示和编辑页面)-画廊
                config.gallery.hidesRemoveButton = false //每个照片或视频右上方是否有删除按钮
                
                
                let picker = YPImagePicker(configuration: config)
                /*
                 let picker = YPImagePicker(configuration: config) 等同于以下代码
                 
                 YPImagePickerConfiguration.shared = config
                 let picker = YPImagePicker()
                 
                 当在iPad展示 picker 时,需设置尺寸
                 let preferredContentSize = CGSize(width: 500,height: 600)
                 YPImagePickerConfiguration.widthOniPad = preferredContentSize.width
                 
                 */
                picker.didFinishPicking { [unowned picker] items, cancelled in
                    
                    // MARK: 选择器 - 上传照片&视频(无法拍摄视频,上传视频后退出再多次上传才能进入剪辑视频界面)
                    //选完或按取消按钮后的异步回调处理（依据配置处理单个或多个）
                    if cancelled{
                        //                    print("用户按了左上角的取消按钮")
                        picker.dismiss(animated: true)
                    }else{
                        // MARK: 选择器 - 笔记编辑界面
                        var photos: [UIImage] = []
                        var videoURL: URL?
                        for item in items{
                            switch item{
                            case .photo(let photo):
                                photos.append(photo.image)
                                //                        case .video:
                                //                            //从沙盒的tmp文件夹中找到原视频
                                //                            let url = URL(fileURLWithPath: "recordedVideoRAW.mov", relativeTo: FileManager.default.temporaryDirectory)
                                //                            photos.append(url.thumbnail)         //无法修改封面图片,添加后的视频无法播放
                                //                            videoURL = url
                            case .video(let video):
                                //从沙盒的tmp文件夹中找到原视频
                                let url = URL(fileURLWithPath: "recordedVideoRAW.mov", relativeTo: FileManager.default.temporaryDirectory)
                                photos.append(video.thumbnail)         //给视频提供封面图片
                                videoURL = video.url
                            }
                        }
                        
                        //跳转到笔记编辑界面
                        let noteEditVC = self.storyboard!.instantiateViewController(identifier: kNoteEditVCID) as! NoteEditVC
                        noteEditVC.photos = photos
                        noteEditVC.videoURL = videoURL
                        picker.pushViewController(noteEditVC, animated: true)
                    }
                    
                    /*
                     if let photo = items.singlePhoto{
                     print(photo.fromCamera)     //图片来源(相机或者相册)
                     print(photo.image)          //用户选择的最后图片(可能添加滤镜)
                     print(photo.originalImage)   //用户选择的原图(未添加滤镜)
                     }
                     for item in items {
                     //判断枚举类型并取出关联值
                     switch item {
                     case .photo(let photo):
                     print(photo)
                     case .video(let video):
                     print(video)
                     }
                     
                     //判断并取出关联值的简写
                     if case let .photo(photo) = item {
                     photo
                     }
                     */
                    
                }
                present(picker, animated: true)
            }else{
                
                //用户未登录
                let alert = UIAlertController(title: "提示", message: "需要先登录哦", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "再看看", style: .cancel, handler: nil)
                let action2 = UIAlertAction(title: "去登录", style: .default) { _ in
                    tabBarController.selectedIndex = 4
                }
                alert.addAction(action1)
                alert.addAction(action2)
                
                present(alert, animated: true, completion: nil)
            }
            return false
        }

        return true

    }
}

