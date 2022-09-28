//
//   POIVC-Config.swift
//  pink
//
//  Created by isdt on 2022/9/26.
//
/*
 小粉书的底部导航栏的“发布”功能 -> 查询地点功能 -> viewDidLoad 内容
 */

extension POIVC{
    func config(){
        //设置定位精度、定位超时时间、逆地理请求超时时间
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters      //定位精确到百米
        locationManager.locationTimeout = 5         //定位超时时间
        locationManager.reGeocodeTimeout = 5        //逆地理请求超时时间
        
        //搜索POI
        mapSearch?.delegate = self
        

        //配置refresh控件的三种方法,此处用第三种
        //1.闭包
        //tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {})
        //2.
        //tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(xxx))
        //3.设全局MJRefreshAutoNormalFooter,之后用他的setRefreshingTarget即可添加事件--此举方便自定义header和footer的样式
        tableView.mj_footer = footer        //上拉加载控件加载到tableView
        
        //searchbar取消按钮,一开始不生效的bug
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton{
            cancelButton.isEnabled = true
        }
    }
}
