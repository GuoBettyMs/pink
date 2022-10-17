//
//  NoteDetailVC-Cofig.swift
//  pink
//
//  Created by isdt on 2022/10/13.
//
/*
    NoteDetailVC属性
 
 */
import Foundation

extension NoteDetailVC{
    func config(){
        
        imageViewSlideshow.zoomEnabled = true                       //允许缩放
        imageViewSlideshow.circular = false                         //取消自动轮播功能
        imageViewSlideshow.contentScaleMode = .scaleAspectFit       //设置内容模式
        
        let pageControl = UIPageControl()
        imageViewSlideshow.pageIndicator = pageControl              //添加分页符
        pageControl.currentPageIndicatorTintColor = mainColor
        pageControl.pageIndicatorTintColor = .systemGray
        

    }
}
