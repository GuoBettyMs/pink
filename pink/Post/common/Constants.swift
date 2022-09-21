//
//  Constants.swift
//  LittlePinkBook
//
//  Created by isdt on 2022/9/15.
//

import UIKit

// MARK: StoryboardID
let kFollowVCID = "FollowVCID"
let kNearByVCID = "NearByVCID"
let kDisCoveryVCID = "DiscoveryVCID"
let kWaterfallVCID = "WaterfallVCID"

// MARK: CellID
let kWaterfallCellID = "WaterfallCellID"
let kPhotoCellID = "PhotoCellID"
let kPhotoFooterID = "PhotoFooterID"


// MARK: - 业务逻辑相关
//瀑布流
let kWaterfallPadding: CGFloat = 4      //瀑布流 layout间距
let kChannels = ["推荐","旅行","娱乐","才艺","美妆","白富美","美食","萌宠"]

//YPImagePicker
let kMaxCameraZoomFactor: CGFloat = 5   //最大多少倍变焦
let kMaxPhotoCount = 9                  //picker选择照片时允许用户最多选几张
let kSpacingBetweenItems: CGFloat = 2   //照片缩略图之间的间距
