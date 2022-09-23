//
//  NoteEditVC-CollectionView.swift
//  pink
//
//  Created by isdt on 2022/9/23.
//
/*
 
    发布笔记编辑页面的 CollectionView
 
 */

import YPImagePicker
import SKPhotoBrowser
import AVKit

// MARK: - 遵守 UICollectionViewDataSource
extension NoteEditVC: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPhotoCellID, for: indexPath) as! PhotoCell
        
        cell.imageView.image = photos[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //若只有header和footer其中一个也可这样，但不推荐
        //let photoFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kPhotoFooterID, for: indexPath) as! PhotoFooter
        //return photoFooter
        
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let photoFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kPhotoFooterID, for: indexPath) as! PhotoFooter
            photoFooter.addPhotoBtn.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
            return photoFooter
        default:
            fatalError("collectionView的footer出问题了")
            //或 return UICollectionReusableView()
        }
    }
    
}
// MARK: - 遵守 UICollectionViewDelegate
extension NoteEditVC: UICollectionViewDelegate{
    //点击图片,有放大缩小删除退出功能
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //预览照片/视频+删除照片
        if isVideo{
            let playerVC = AVPlayerViewController()
            //要预览视频,需将 videoURL 赋值,赋值后点击图片会播放视频
            playerVC.player = AVPlayer(url: videoURL!)
            present(playerVC, animated: true) {
                playerVC.player?.play()
            }
        }else{
            // 1. create SKPhoto Array from UIImage
            var images: [SKPhoto] = []
            
            for photo in photos{
                images.append(SKPhoto.photoWithImage(photo))
            }
            // 2. create PhotoBrowser Instance, and present from your viewController.
            let browser = SKPhotoBrowser(photos: images, initialPageIndex: indexPath.item)
            browser.delegate = self
            SKPhotoBrowserOptions.displayAction = false
            SKPhotoBrowserOptions.displayDeleteButton = true
            present(browser, animated: true)
        }
    }
}

// MARK: - SKPhotoBrowserDelegate
extension NoteEditVC: SKPhotoBrowserDelegate{
    func removePhoto(_ browser: SKPhotoBrowser, index: Int, reload: @escaping (() -> Void)) {
        photos.remove(at: index)
        photoCollectionV.reloadData()
        reload()
    }
}

// MARK: - 监听
extension NoteEditVC{
    @objc private func addPhoto(){
        if photoCount < kMaxPhotoCount{
            var config = YPImagePickerConfiguration()
            
            // MARK: 通用配置
            config.albumName = Bundle.main.appName //在本地设备中新建一个新文件夹,新文件夹名称为 appName
            config.screens = [.library] //只展示相册
            
            // MARK: 相册配置
            config.library.defaultMultipleSelection = true //是否可多选
            config.library.maxNumberOfItems = kMaxPhotoCount - photoCount //最大选取照片或视频数
            config.library.spacingBetweenItems = kSpacingBetweenItems //照片缩略图之间的间距
            
            // MARK: - Gallery(多选完后的展示和编辑页面)-画廊
            config.gallery.hidesRemoveButton = false //每个照片或视频右上方是否有删除按钮
            
            let picker = YPImagePicker(configuration: config)
            
            // MARK: 选完或按取消按钮后的异步回调处理（依据配置处理单个或多个）
            picker.didFinishPicking { [unowned picker] items, _ in
  
                for item in items {
                    if case let .photo(photo) = item{
                        self.photos.append(photo.image)
                    }
                }
                self.photoCollectionV.reloadData()      //重新加载photoCollectionV的所有数据
                
                picker.dismiss(animated: true)
            }
            
            present(picker, animated: true)
        }else{
            showTextHUD("最多只能选择\(kMaxPhotoCount)张照片哦")
        }
    }
}

