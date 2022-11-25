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
import GrowingTextView

class NoteDetailVC: UIViewController {
    

    var note: LCObject//笔记对象属性
    var isLikeFromWaterfallCell = false             //笔记首页的点赞状态传值到笔记详情页面,判断详情页的当前用户是否点赞
    var delNoteFinished: (() -> ())?                //删除笔记闭包

    var isReply = false //用于判断用户按下textview的发送按钮时究竟是评论(comment)还是回复(reply)
    var commentSection = 0 //用于找出用户是对哪个评论进行的回复
    var comments: [LCObject] = []//评论对象属性
    
// 等同于 var replies: [[LCObject]] = [], 但是二维数组无法增加新属性,故使用结构体
    var replies: [ExpandableReplies] = []
    var replyToUser: LCUser?       //评论view->回复view->再回复view,再回复view中的被回复人
    
    var isFromMeVC = false          //判断是否从个人页面跳转到详情面
    var fromMeVCUser: LCUser?       //从个人页面跳转到详情面的用户
    
    var isFromPush = false          //判断是否从推送通知横幅跳转到详情面
    var delegate: NoteDetailVCDelegate? //推送通知横幅跳转到笔记详情页后,返回首页瀑布流时的点赞去重
    var cellItem: Int?     //被更新的首页瀑布流cell
     
    var noteHeroID: String? //指定需要转场动画的viewID,接收首页瀑布流cell传过来的heroID
    
    //上方bar(作者信息)
    @IBOutlet weak var authorAvatarBtn: UIButton!
    @IBOutlet weak var authorNickNameBtn: UIButton!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var shareOrMoreBtn: UIButton!
    
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
    @IBOutlet weak var noteTableView: UITableView!
    
    //下方bar(点赞收藏评论)
    @IBOutlet weak var likeBtn: FaveButton!
    @IBOutlet weak var likeCountL: UILabel!             //点赞
    @IBOutlet weak var favBtn: FaveButton!
    @IBOutlet weak var favCountL: UILabel!              //收藏
    @IBOutlet weak var commentCountBtn: UIButton!
    
    @IBOutlet weak var textViewBarView: UIView!
    @IBOutlet weak var textView: GrowingTextView!
    @IBOutlet weak var textViewBarBottomConstraint: NSLayoutConstraint!
    
    //用户评论时,给评论背景增加一个黑色遮罩
    lazy var overlayView: UIView = {
        let overlayView = UIView(frame: view.frame)
        overlayView.backgroundColor = UIColor(white: 0, alpha: 0.1)//backgroundColor、alpha不能分开写,不然第一次显示View时,透明度不会起效,只起效backgroundColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        overlayView.addGestureRecognizer(tap)//添加手势用于关闭软键盘
        return overlayView
    }()
    
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
    var currentFavCount = 0                 //当前收藏数量
    
    //评论数量初始化
    var commentCount = 0{
        didSet{
            commentCountLabel.text = commentCount.formattedStr
            commentCountBtn.setTitle(commentCount == 0 ? "评论" : commentCount.formattedStr, for: .normal)
        }
    }
    
    //计算属性
    var author: LCUser?{ note.get(kAuthorCol) as? LCUser }
    var isLike: Bool { likeBtn.isSelected }
    var isFav:Bool { favBtn.isSelected }
    var isReadMyDraft: Bool{
        if let user = LCApplication.default.currentUser, let author = author , user == author {
            return true
        }else{
            return false
        }
    }
    
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
        setUI()
        getCommentsAndReplies()
        getFav()
    }
    
    // MARK: tableHeaderView - 高度自适应
    //动态计算tableHeaderView的height(放在viewdidappear的话会触发多次),相当于手动实现了estimate size(目前cell已配备这种功能)
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustTableHeaderViewHeight()
        
    }

    // MARK: 返回上一页
    @IBAction func back(_ sender: Any) { backToCell() }
    
    // MARK: 顶部Bar - 点击作者头像或昵称跳转到个人页面
    @IBAction func goToAuthorMeVC(_ sender: Any) { noteToMeVC(author) }
    
    // MARK: 顶部Bar - 分享或者其他操作事件
    @IBAction func shareOrMore(_ sender: Any) { shareOrMore() }
    
    // MARK: 底下Bar - 点赞事件
    @IBAction func like(_ sender: Any) { like() }
    
    // MARK: 底下Bar - 收藏事件
    @IBAction func fav(_ sender: Any) { fav() }
    
    // MARK: 底下Bar - 填写评论事件
    @IBAction func comment(_ sender: Any) { comment() }
    
    // MARK: 发送评论事件
    @IBAction func postCommentOrReply(_ sender: Any) {
        //此处省略1.button的动态enable处理,2.字数限制的提示,3.按下键盘return键的处理
        //若用户输入一段空格,判断用户没有输入
        if !textView.isBlank{
            //用户输入
            if !isReply{
                //发送评论
                //note-comment一对多;user-comment一对多,故创建/取出comment表,在里面放入note和user字段
                postComment()
            }else{
                //发送回复
                //comment-reply一对多;user-reply一对多,和comment表类似
                postReply()
            }
            hideAndResetTextView()
        }    
    }
    
}
