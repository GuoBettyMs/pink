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

// MARK: Cell相关ID
let kWaterfallCellID = "WaterfallCellID"
let kPhotoCellID = "PhotoCellID"
let kPhotoFooterID = "PhotoFooterID"
let kSubChannelCellID = "SubChannelCellID"
let kPOICellID = "POICellID"
let kDraftNoteWaterfallCellID = "DraftNoteWaterfallCellID"

// MARK: - 资源文件相关
let mainColor = UIColor(named: "main")!
let blueColor = UIColor(named: "blue")!
let imagePH = UIImage(named: "imagePH")!

// MARK: - CoreData
let appDelegate = UIApplication.shared.delegate as! AppDelegate       //单例模式对象: UIApplication.shared
let persistentContainer = appDelegate.persistentContainer
let context = persistentContainer.viewContext                           //主队列
let backgroundContext = persistentContainer.newBackgroundContext()      //后台队列

// MARK: - UI布局
let screenRect = UIScreen.main.bounds

// MARK: - 业务逻辑相关
//瀑布流
let kWaterfallPadding: CGFloat = 4      //瀑布流 layout间距
let kDraftNoteWaterfallCellBottomViewH: CGFloat = 80        //StackView高度和上下边距(TitleLabel+DateLabel)

let kChannels = ["推荐","旅行","娱乐","才艺","美妆","白富美","美食","萌宠"]

//YPImagePicker
let kMaxCameraZoomFactor: CGFloat = 5   //最大多少倍变焦
let kMaxPhotoCount = 9                  //picker选择照片时允许用户最多选几张
let kSpacingBetweenItems: CGFloat = 2   //照片缩略图之间的间距

//笔记
let kMaxNoteTitleCount = 20             //笔记编辑 - 标题最大字符数
let kMaxNoteTextCount = 1000            //笔记编辑 - 文本最大字符数

//话题
let kAllSubChannels = [
    ["穿神马是神马", "就快瘦到50斤啦", "花5个小时修的靓图", "网红店入坑记"],
    ["魔都名媛会会长", "爬行西藏", "无边泳池只要9块9"],
    ["小鲜肉的魔幻剧", "国产动画雄起"],
    ["练舞20年", "还在玩小提琴吗,我已经尤克里里了哦", "巴西柔术", "听说拳击能减肥", "乖乖交智商税吧"],
    ["粉底没有最厚,只有更厚", "最近很火的法属xx岛的面霜"],
    ["我是白富美你是吗", "康一康瞧一瞧啦"],
    ["装x西餐厅", "网红店打卡"],
    ["我的猫儿子", "我的猫女儿", "我的兔兔"]
]

//高德
let kAMapApiKey = "37e506cd59c2258797c6b4efe462d648"            //配置定位Key
let kNoPOIPH = "未知地点"
let kPOITypes = "医疗保健服务"                    //调试用
//let kPOITypes = "汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施"
let kPOIsInitArr = [["不显示位置", ""]]          //完全同步copy周边的pois数组，用于简化逻辑
let kPOIsOffset = 20                           //每页展示的搜索数量

//极光一键登录
let kJAppKey = "e590b77d81335e8dd9d9f960"           //配置一键登录Key

//faifno
