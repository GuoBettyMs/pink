//
//  pink-Bridging-Header.h
//  pink
//
//  Created by isdt on 2022/9/21.
//
/*
 
    桥接方法见: https://developer.apple.com/documentation/swift/importing-objective-c-into-swift
    手动方法:
 1.新建文件 File > New > File > [ operating system ] > Source > Header File 自己创建一个桥接头。"-Bridging-Header.h"
 2.点击左侧列表的 project,弹出项目设置, 点击 target ,在 Build Settings 中的 Swift Compiler - General 中(也可直接搜 brid)
 3.找到 Objective-C Bridging Header ,选择第二个空, 填入具有桥接头文件的路径, 如 pink/pink-Bridging-Header.h
 4.在桥接文件 pink-Bridging-Header 中,增加 OC文件,如 #import "MBProgressHUD.h"
 */

#ifndef pink_Bridging_Header_h
#define pink_Bridging_Header_h


#endif /* pink_Bridging_Header_h */

//<>-cocoapods导入的库或者系统库,""-本地文件,若不熟练则可统一使用引号

//提示框
#import "MBProgressHUD.h"           //导入OC文件,在其他文件中就无需再添加

//高德定位
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

//高德搜索
#import <AMapSearchKit/AMapSearchKit.h>

//上拉加载
#import "MJRefresh.h"
