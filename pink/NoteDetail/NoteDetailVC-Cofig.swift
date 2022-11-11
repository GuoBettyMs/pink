//
//  NoteDetailVC-Cofig.swift
//  pink
//
//  Created by isdt on 2022/10/13.
//
/*
    详细笔记页面 - 属性
 */
import ImageSlideshow
import GrowingTextView
import LeanCloud

extension NoteDetailVC{
    
    // MARK: 属性
    func config(){
        //imageSlideshow
        imageViewSlideshow.zoomEnabled = true                       //允许缩放
        imageViewSlideshow.circular = false                         //取消自动轮播功能
        imageViewSlideshow.contentScaleMode = .scaleAspectFit       //设置内容模式
        imageViewSlideshow.activityIndicator = DefaultActivityIndicator() //更新用户自己笔记后,在加载图片时,设置加载小菊花
        
        let pageControl = UIPageControl()
        imageViewSlideshow.pageIndicator = pageControl              //添加分页符
        pageControl.currentPageIndicatorTintColor = mainColor
        pageControl.pageIndicatorTintColor = .systemGray
        
        //因FaveButton的封装,用户未登录时点击按钮也会变色,故需提前拦截
        if LCApplication.default.currentUser == nil{
            likeBtn.setToNormal()
            favBtn.setToNormal()
        }
        
        //评论的textView
        //GrowingTextView默认高度30时placeholder垂直居中,现高度变为40,需上下各补上5才行,加上原有的8,为13
        textView.textContainerInset = UIEdgeInsets(top: 11.5, left: 16, bottom: 11.5, right: 16)
        textView.delegate = self

        //添加观察者,监听键盘的弹出和收起
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        //注册可重用的section header(评论view)
        tableView.register(UINib(nibName: "CommentView", bundle: nil), forHeaderFooterViewReuseIdentifier: kCommentViewID)
        
        //注册可重用的section footer(评论view与评论view之间的分隔线)
        tableView.register(CommentSectionFooterView.self, forHeaderFooterViewReuseIdentifier: kCommentSectionFooterViewID)
    }
    
    // MARK: 一般函数 - 计算tableHeaderView里内容的总height
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

extension NoteDetailVC: GrowingTextViewDelegate{
    
    // MARK: 遵守GrowingTextViewDelegate - 自增长textView内文字换行时高度增长的动画
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}

extension NoteDetailVC{
    // MARK: 监听键盘Frame
    @objc private func keyboardWillChangeFrame(_ notification: Notification){
        if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            //键盘的当前高度(弹起时大于0,收起时为0)
            let keyboardH = screenRect.height - endFrame.origin.y
//            print(keyboardH)
            if keyboardH > 0{
                //不能使用 view.addSubview, view.addSubview指添加view到最上层
                view.insertSubview(overlayView, belowSubview: textViewBarView)//给评论背景加黑色透明遮罩
            }else{
                overlayView.removeFromSuperview()//移除黑色透明遮罩
                textViewBarView.isHidden = true
            }
            
            textViewBarBottomConstraint.constant = -keyboardH//故事版中firstItem 跟secondItem不同,之间的constant正负不同
            view.layoutIfNeeded()//根据当前layout的constant来刷新view
        }
    }
}
