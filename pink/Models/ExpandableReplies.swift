//
//  ExpandableReplies.swift
//  pink
//
//  Created by gbt on 2022/11/9.
//
/*
    二维数组无法增加属性,故使用结构体
 等同于 var replies: [[LCObject]] = []
 */
import LeanCloud

struct ExpandableReplies {
    var isExpanded = false
    var replies: [LCObject]
}
