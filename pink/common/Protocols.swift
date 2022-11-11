//
//  Protocols.swift
//  pink
//
//  Created by isdt on 2022/9/26.
//
/*
    自定义协议

 */

import Foundation

protocol ChannelVCDelegate {
    
    /*
     知识点：文档注释(documentation comments)
     把下面的文档注释右击选择code snippet,保存为代码片段
     占位符的写法为两个<#，左右对称,完成后有高亮效果

     /// <#描述#>
     /// - Parameter <#参数名#>: 参数描述
     /// - Parameter <#参数名#>: 参数描述
     /// - Returns:

     commend 按住新函数,可发现函数描述为自定义描述内容
     注，参数个数必须对应上否则无法三指展示文档
     /// ww
     /// - Parameter www: 参数描述
     /// - Parameter eee: 参数描述
     /// - Returns:
     func aa(www, eee) -> String
     
     */

    /// 用户从选择话题页面返回编辑笔记页面传值用
    /// - Parameter channel: 传回来的channel
    /// - Parameter subChannel: 传回来的subChannel
    func updateChannel(channel: String, subChannel: String)
    
}

//自定义-发布笔记的地点协议
protocol POIVCDelegate{
    func updatePOIName(_ poiName: String)
}

//自定义-个人页面的简介协议
protocol IntroVCDelegate {
    func updateIntro(_ intro: String)
}
