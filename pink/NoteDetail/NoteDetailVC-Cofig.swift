//
//  NoteDetailVC-Cofig.swift
//  pink
//
//  Created by isdt on 2022/10/13.
//
/*
    详细笔记页面 - 属性
 */
import Foundation

extension NoteDetailVC{
    
    // MARK: 属性
    func config(){
        
        imageViewSlideshow.zoomEnabled = true                       //允许缩放
        imageViewSlideshow.circular = false                         //取消自动轮播功能
        imageViewSlideshow.contentScaleMode = .scaleAspectFit       //设置内容模式
        
        let pageControl = UIPageControl()
        imageViewSlideshow.pageIndicator = pageControl              //添加分页符
        pageControl.currentPageIndicatorTintColor = mainColor
        pageControl.pageIndicatorTintColor = .systemGray

    }
    
    // MARK: 一般函数 - 计算tableHeaderView里内容的总heigh
    func adjustTableHeaderViewHeight(){
        //计算出tableHeaderView里内容的总height--固定用法(开销较大,不可过度使用)
        let height = tableHeaderView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var frame = tableHeaderView.frame         //取出初始frame值,待会把里面的height替换成上面计算的height,其余不替换
        
        //一旦tableHeaderView的height已经是实际height了,则不能也没必要继续赋值frame了.
        //需判断,否则更改tableHeaderView的frame会再次触发viewDidLayoutSubviews,进而进入死循环
        if frame.height != height{
            frame.size.height = height           //替换成实际height
            tableHeaderView.frame = frame        //重新赋值frame,即可改变tableHeaderView的布局(实际就是改变height)
        }
    }
    
}
