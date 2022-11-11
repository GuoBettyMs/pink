//
//  CustomClasses.swift
//  pink
//
//  Created by gbt on 2022/11/9.
//
/*
    
    自定义子视图手势: 继承轻触手势,再添加新属性
 */
import LeanCloud

class UIPassableTapGestureRecognizer: UITapGestureRecognizer{
    var passObj: LCUser?
}
