//
//  NoteDetailVC.swift
//  pink
//
//  Created by isdt on 2022/10/13.
//
/*
    详细笔记页面
 */

import UIKit
import FaveButton
import ImageSlideshow
import LeanCloud

class NoteDetailVC: UIViewController {
    
    //自定义对象属性
    let note: LCObject
    var isLikeFromWaterfallCell = false             //点赞动画

    //上方bar(作者信息)
    @IBOutlet weak var authorAvatarBtn: UIButton!
    @IBOutlet weak var authorNickNameBtn: UIButton!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    
    //整个tableHeaderView
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var imageViewSlideshow: ImageSlideshow!          //自动轮播图片
    @IBOutlet weak var imageViewSlideshowH: NSLayoutConstraint!
    @IBOutlet weak var titleL: UILabel!
    //这里不使用UITextView是因其默认是滚动状态,不太方便搞成有多少就显示多少行的状态,实际开发中显示多行文本一般是用Label
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var channelBtn: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    //整个tableView
    @IBOutlet weak var tableView: UITableView!
    
    //下方bar(点赞收藏评论)
    @IBOutlet weak var likeBtn: FaveButton!
    @IBOutlet weak var likeCountL: UILabel!
    @IBOutlet weak var favBtn: FaveButton!
    @IBOutlet weak var favCountL: UILabel!
    @IBOutlet weak var commentCountBtn: UIButton!
    
    //点赞数量初始化
    var likeCount = 0 {
        didSet{
            likeCountL.text = likeCount == 0 ? "点赞" : likeCount.formattedStr
        }
    }
    var currentLikeCount = 0                //当前点赞数量
    
    //收藏数量初始化
    var favCount = 0{
        didSet{
            favCountL.text = favCount == 0 ? "收藏" : favCount.formattedStr
        }
    }
    var currentFavCount = 0                 //当前关注数量
    
    //评论数量初始化
    var commentCount = 0{
        didSet{
            commentCountLabel.text = commentCount.formattedStr
            commentCountBtn.setTitle(commentCount == 0 ? "评论" : commentCount.formattedStr, for: .normal)
        }
    }
    
    //计算属性
    var author: LCUser?{ note.get(kAuthorCol) as? LCUser }
    
    //给note: LCObject 创建初始化构造器
    init?(coder: NSCoder, note: LCObject) {
        self.note = note
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("必须传一些参数进来以构造本对象,不能单纯的用storyboard!.instantiateViewController构造本对象")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        config()
        
//        imageViewSlideshow.setImageInputs([ImageSource(image: UIImage(named: "Discovery-11")!),
//                                           ImageSource(image: UIImage(named: "Discovery-12")!),
//                                           ImageSource(image: UIImage(named: "Discovery-13")!)])
//        //跟屏幕宽度等宽比地修改图片的高度约束,constant 相当于故事版设置的高度约束
//        let imageSize = UIImage(named: "avatarPH1")!.size
//        imageViewSlideshowH.constant = (imageSize.height / imageSize.width) * screenRect.width
        
        
        setUI()

    }
    
    // MARK: tableHeaderView - 高度自适应
    //动态计算tableHeaderView的height(放在viewdidappear的话会触发多次),相当于手动实现了estimate size(目前cell已配备这种功能)
    override func viewDidLayoutSubviews() {

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
