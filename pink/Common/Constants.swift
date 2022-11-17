//
//  Constants.swift
//  LittlePinkBook
//
//  Created by isdt on 2022/9/15.
//
/*
    全局变量
 */
import UIKit

// MARK: StoryboardID
let kFollowVCID = "FollowVCID"
let kNearByVCID = "NearByVCID"
let kDisCoveryVCID = "DiscoveryVCID"
let kWaterfallVCID = "WaterfallVCID"
let kNoteEditVCID = "NoteEditVCID"
let kChannelTableVCID = "ChannelTableVCID"
let kLoginNaviID = "LoginNaviID"
let kLoginVCID = "LoginVCID"
let kMeVCID = "MeVCID"
let kDraftNotesNaviID = "DraftNotesNaviID"
let kNoteDetailVCID = "NoteDetailVCID"
let kIntroVCID = "IntroVCID"
let kEditProfileNaviID = "EditProfileNaviID"
let kSettingTableVCID = "SettingTableVCID"


// MARK: Cell相关ID
let kWaterfallCellID = "WaterfallCellID"
let kPhotoCellID = "PhotoCellID"
let kPhotoFooterID = "PhotoFooterID"
let kSubChannelCellID = "SubChannelCellID"
let kPOICellID = "POICellID"
let kDraftNoteWaterfallCellID = "DraftNoteWaterfallCellID"
let kMyDraftNoteWaterfallCellID = "MyDraftNoteWaterfallCellID"
let kCommentViewID = "CommentViewID"
let kReplyCellID = "ReplyCellID"
let kCommentSectionFooterViewID = "CommentSectionFooterViewID"

// MARK: - 资源文件相关
let mainColor = UIColor(named: "main")!
let blueColor = UIColor(named: "blue")!
let mainLightColor = UIColor(named: "main-light")!
let imagePH = UIImage(named: "imagePH")!

// MARK: - UserDefaults的key
let kNameFromAppleID = "nameFromAppleID"
let kEmailFromAppleID = "emailFromAppleID"
let kDraftNoteCount = "draftNoteCount"      //个人的草稿笔记数
let kUserInterfaceStyle = "userInterfaceStyle"  //模仿UIUserInterfaceStyle枚举,0指跟随系统,1和2对应浅色和深色模式

// MARK: - CoreData
let appDelegate = UIApplication.shared.delegate as! AppDelegate       //单例模式对象: UIApplication.shared
let persistentContainer = appDelegate.persistentContainer
let context = persistentContainer.viewContext                           //主队列
let backgroundContext = persistentContainer.newBackgroundContext()      //后台队列

// MARK: - UI布局
let screenRect = UIScreen.main.bounds   //屏幕宽高

// MARK: - 业务逻辑相关
//瀑布流
let kWaterfallPadding: CGFloat = 4                          //瀑布流 layout间距
let kDraftNoteWaterfallCellBottomViewH: CGFloat = 80        //本地草稿页面cell 底部StackView的总高度(含TitleLabel+DateLabel上下边距)
let kWaterfallCellBottomViewH: CGFloat = 76                 //首页发现页面cell底部StackView的总高度(含TitleLabel+authorNickNameL上下边距)

let kChannels = ["推荐","旅行","娱乐","才艺","美妆","白富美","美食","萌宠"]

//YPImagePicker
let kMaxCameraZoomFactor: CGFloat = 5   //最大多少倍变焦
let kMaxPhotoCount = 9                  //picker选择照片时允许用户最多选几张
let kSpacingBetweenItems: CGFloat = 2   //照片缩略图之间的间距

//笔记
let kMaxNoteTitleCount = 20             //笔记编辑 - 标题最大字符数
let kMaxNoteTextCount = 1000            //笔记编辑 - 文本最大字符数
let kNoteCommentPH = "精彩评论将被优先展示哦"

//用户
let kMaxIntroCount = 100
let kIntroPH = "填写个人简介更容易获得关注哦,点击此处填写"
let kNoCachePH = "无缓存"

//话题
let kAllSubChannels = [
    ["穿神马是神马", "就快瘦到50斤啦", "花5个小时修的靓图", "网红店入坑记"],
    ["魔幻景点", "爬行西藏", "年度最佳旅游胜地"],
    ["玛丽苏的魔幻剧", "国产动画雄起"],
    ["练舞20年", "还在玩小提琴吗,我已经尤克里里了哦", "巴西柔术", "听说拳击能减肥", "乖乖交智商税吧"],
    ["粉底没有最厚,只有更厚", "最近很火的法属xx岛的面霜"],
    ["我是白富美你是吗", "康一康瞧一瞧啦"],
    ["装x西餐厅", "地方美食打卡"],
    ["我的猫儿子", "我的皮卡丘", "我的兔兔"]
]

//高德
let kAMapApiKey = "37e506cd59c2258797c6b4efe462d648"            //配置定位Key
let kNoPOIPH = "未知地点"
//let kPOITypes = "购物服务"                     //调试用
let kPOITypes = "汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施"
let kPOIsInitArr = [["不显示位置", ""]]          //完全同步copy周边的pois数组，用于简化逻辑
let kPOIsOffset = 20                           //每页展示的搜索数量

//极光一键登录
let kJAppKey = "e590b77d81335e8dd9d9f960"       //配置一键登录Key

//支付宝登录
//kAliPayAppID: 应用真实ID、kAliPayPID: 商户ID、kAlipayPrivateKey:极光一键登录平台上传的公钥对应的私钥(建议用支付宝开发平台开发助手申请的)
let kAppScheme = "pink"                             //浏览器搜索栏输入"pink://",回车后可直接跳转到App
let kAliPayAppID = "2021000121677944"               //沙箱APPID
let kAliPayPID = "2088621993691831"                 //沙箱PID
let kAlipayPrivateKey = "MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCNLQOqKnkbVlK6Zm57tZR/ldjAD2hYtN5oz1O8HdxRI4hIOPqUONaz3aiLozX/lMT75FjKazLZIcUaNtyduSb7NKp9/sNKi+qrHMZuteiQTQrsdhcLi15KgKShbKCzsiknyQ/BW7fnL/3xp8oj5ZzBwobepAVadxatGRDKDY/TMGFwePGlcQph8FmnR2gi/Z6tw8jxDVmfoc6t9ER7M35u4fsXQ2EbBp2qNFhlzzM3kT3we482BGiBUKmfJJm2qdZ5E8EWVPC/zOCOelhVKqgFbnJYMOzxE89b6gJVcjGQhRl0VqrFU6hwv8XFu22qsfn4QOYl2JaTUST1jT9VWoTzAgMBAAECggEAeVWE3s2eRLaOZ5H9xukq9fTN01PqtMLOnHoEV5u6bSoCyT/fbWDkdrY9U7Y0hLNSEcQR4/b6Ps/dXUhlmFE3hZOgLKW3JuzWBba3fRNvDAaLKuvbpppjsdiapfp8q7Sl1oHhvqebiWEf+n/hJbUEYytTSyrhRv0vShpO6bl6MWEI2Y/uYWNW3DdXw8a4ljRNvNRCp7za0/1ljg2bH9obpqoKl62wDGz00qgQC+LHwp49Qa3w/X9c6j3g+jXvheGvksWRk/dVZ49E2Q6IdqdzMddvZx62igC8yhZiAhd1DEJUOJ6s/ZKB0jbsvjE1LkjyPT/LJp95IChY6TdjLcY5gQKBgQDlrX8NVb5GZq5zxXfWh4SA23zH9TG7HY8a4cmJWSgpyttTmIcJ4owkDbNcQfpwMgfhanDIfB4xc3gVQfbJck8k4QvMBcBu9XEimq45V9MdxyRzUuPQwUouAmjkFSy+peP23P3qFqf5hvswdp3ukBUG/K+9C/NEDII+6nQOtpp3kwKBgQCdWvcqRUX+g3zIXvx2XE2VxGD8OH/Fl0wLMyaSUAGpQ7qC33qKNKD5b5PMQ3OE7AC/0DqPHdB2APPvSk3ZAyoxOUERWtKVxnJWdj2lwsH3OdBd+xVmP42Id3pIN5fDIKBjN2OilZpVVBlAbmKE7tOF1Gz0GIeK53Ic25DUdgVZIQKBgQCtDDVn9KxyGrdiHuwVxPE+rSCs/77Cfpjt5iSUyYoLQv5RU+CawAhaub/jyQpKMkfhvPLQ+0M8ewWE7rhkOy4KWU0sIUFF2MOvEOAn8FXuX7bE9TUUei3L0KD7CEE4O4Ew5HyjPQK+bMchUp3XutM8+nHme/SD1vDjOn7K/yYO5QKBgEteyereWYNqObfD/4s19Reag5Xr/g+Hw63Np1kHp3QK8+hB4PEX+k7fydxaJpfxbv5xX8szTaloFW91mMosgOYo9Wi5pwqEjjmp0yd1nPCtKYgKfxqFsGZATDsRHckh9JDxc/DpVY4vhRTeiqP/vSNqN3HH2gyHhZoa9Uk+6prhAoGBAKl5jlHNVvpfzQMdv4dF2PN2wSk7IQCOl1PEzftd1GejmKuliFFu30zn8WVuwkOoSVZzo2IAZ133s76DGHrISV9bVAtgL2eG1cVhpg2/ekgdL+qsG+ea2YtD7DqW16L90OObz5tOVc+UHwN2gIDRPcSBHxbcc7Hcqn7oABzvtA6M"  //沙箱公钥对应的私钥

//正则表达式
let kPhoneRegEx = "^1\\d{10}$"       //^1表示以1开头，$表示结尾，\d表示数字，{10}表示前面的\d有10位,验证手机号码个数是否正确
let kAuthCodeRegEx = "^\\d{6}$"      //^表示开头，$表示结尾，\d表示数字，{6}表示前面的\d有6位,验证验证码个数是否正确
let kPasswordRegEX = "^[0-9a-zA-Z]{6,16}$"  //密码验证

//云端
let kNotesOffset = 10                //10条笔记
let kCommentsOffset = 10             //10条评论

// MARK: - Leancloud
//配置相关
let kLCAppID = "4NLz9QdvBA1wlBsJIKNKVf01-gzGzoHsz"
let kLCAppKey = "rrE6YI1D01Sqq4H8LyOjY2tg"
let kLCServerURL = "https://4nlz9qdv.lc-cn-n1-shared.com"

//LeanCloud 通用字段
let kCreatedAtCol = "createdAt"
let kUpdatedAtCol = "updatedAt"

//LeanCloud 表
let kNoteTable = "Note"                     //笔记云端表
let kUserLikeTable = "UserLike"             //点赞笔记云端表
let kUserFavTable = "UserFav"               //收藏笔记云端表
let kCommentTable = "Comment"               //笔记的评论云端表
let kReplyTable = "Reply"                   //笔记的评论回复云端表
let kUserInfoTable = "UserInfo"             //用户个人社交信息的云端表

//LeanCloud User表字段
let kNickNameCol = "nickName"               //登录用户的昵称字段
let kAvatarCol = "avatar"                   //在云端LeanCloud设置默认头像字段
let kGenderCol = "gender"                   //在云端LeanCloud设置默认性别字段
let kIntroCol = "intro"                     //在云端LeanCloud设置默认个人简介字段
let kIDCol = "id"                           //在云端LeanCloud设置默认个人的小粉书号
let kBirthCol = "birth"
let KIsSetPasswordCol = "isSetPassword"

//kNoteTable - 云端笔记普通数据的Note表字段
let kCoverPhotoCol = "coverPhoto"               //封面图片
let kCoverPhotoRatioCol = "coverPhotoRatio"     //封面图片宽高比字段
let kPhotosCol = "photos"                       //图片
let kVideoCol = "video"                         //视频
let kTitleCol = "title"                         //标题
let kTextCol = "text"                           //正文
let kChannelCol = "channel"                     //话题
let kSubChannelCol = "subChannel"               //副话题
let kPOINameCol = "poiName"                     //地点
let kIsVideoCol = "isVideo"                     //视频标识符
let kLikeCountCol = "likeCount"                 //点赞数量
let kFavCountCol = "favCount"                   //收藏数量
let kCommentCountCol = "commentCount"           //评论数量
let kAuthorCol = "author"                       //笔记作者
let kHasEditCol = "hasEdit"

//kUserLikeTable表包含的字段
let kUserCol = "user"                           //被点赞笔记的用户
let kNoteCol = "note"                           //被点赞笔记

//Comment表字段
let kHasReplyCol = "hasReply"                   //是否有回复字段,默认评论下没有回复

//Reply表字段
let kCommentCol = "comment"
let kReplyToUserCol = "replyToUser"             //子回复,评论view->回复view->再回复view,再回复view中的被回复人字段

//UserInfo表
let kUserObjectIdCol = "userObjectId"           //用户ID标记符

// MARK: - 全局函数 - 设置系统图标
//全局图标
func largeIcon(_ iconName: String, with color: UIColor = .label) -> UIImage{
    let config = UIImage.SymbolConfiguration(scale: .large)
    let icon = UIImage(systemName: iconName, withConfiguration: config)!
    return icon.withTintColor(color)
}

//全局字符图标
func fontIcon(_ iconName: String, fontSize: CGFloat, with color: UIColor = .label) -> UIImage{
    let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: fontSize))
    let icon = UIImage(systemName: iconName, withConfiguration: config)!
    return icon.withTintColor(color)
}

//全局提示框
func showGlobalTextHUD(_ title: String){
    let window = UIApplication.shared.windows.last!
    let hud = MBProgressHUD.showAdded(to: window, animated: true)
    hud.mode = .text            //不指定的话显示菊花和配置的文本
    hud.label.text = title
    hud.hide(animated: true, afterDelay: 2)
}
