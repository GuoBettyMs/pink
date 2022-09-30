//
//  POIVC.swift
//  pink
//
//  Created by isdt on 2022/9/26.
//
/*
    小粉书的底部导航栏的“发布”功能 -> 查询地点功能
    <#注#>: 地点SDK 与项目的Team ID 是一一对应的,若中途更换Team ID,已注册好的地点SDK就无法再使用
 
    IDFA 广告标识符,类似电脑硬件UUID
 
 */

import UIKit


class POIVC: UIViewController {
    
    var pOIVCDelegate: POIVCDelegate?
    var poiName = ""
    
    lazy var locationManager = AMapLocationManager()    //定位实例化
    lazy var mapSearch = AMapSearchAPI()                //搜索POI用

    //设置周边检索的参数,搜索周边POI请求
    lazy var aroundSearchRequest: AMapPOIAroundSearchRequest = {
        let request = AMapPOIAroundSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(latitude), longitude: CGFloat(longitude))
        request.types = kPOITypes
        request.offset = kPOIsOffset            //每页展示的搜索数量
        return request
    }()
 
    //关键字搜索POI请求
    lazy var keywordsSearchRequest: AMapPOIKeywordsSearchRequest = {
        let request = AMapPOIKeywordsSearchRequest()
        request.keywords = keywords
        request.offset = kPOIsOffset            //每页展示的搜索数量
        return request
    }()
    
    //上拉加载控件实例化
    lazy var footer = MJRefreshAutoNormalFooter()
    
    
    //因页面一开始在cell中有数组取值处理，必须规定内嵌的数组有两个元素，若元素数量动态的话可用下面repeating方法
    //var pois = [Array(repeating: "", count: 2)]
    var pois = kPOIsInitArr
    var aroundSearchedPOIs = kPOIsInitArr       //完全同步copy周边的pois数组，用于简化逻辑
    
    var latitude = 0.0
    var longitude = 0.0
    var keywords = ""
    var currentAroundPage = 1           //周边搜索的当前页数
    var currentKeywordsPage = 1         //关键字搜索的当前页数
    var pageCount = 1                   //所有搜索的总页数
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        requestLocation()
    }

}


// MARK: - 遵守 UITableViewDataSource
extension POIVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { pois.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kPOICellID, for: indexPath) as! POICell
        
        let poi = pois[indexPath.row]
        cell.poi = poi
        
        if poi[0] == poiName{ cell.accessoryType = .checkmark }
        
        return cell
    }
  
}

// MARK: -
extension POIVC: UITableViewDelegate{
    
    // MARK: 遵守 UITableViewDelegate - 标记已选中的地址并传值到笔记编辑界面
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //标记已选中的地址
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .checkmark
        
        //通过自定义协议传值到笔记编辑界面
        pOIVCDelegate?.updatePOIName(pois[indexPath.row][0])        //pois有两行,主要地址和详细地址,显示主要地址
        dismiss(animated: true)
    }
}

// MARK: -
extension POIVC: AMapSearchDelegate{
    
    // MARK: 遵守 AMapSearchDelegate - 所有搜索POI的回调
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {

        hideLoadHUD()           //关闭菊花加载效果
        let poiCount = response.count
        print(poiCount)
        
        //获取搜索总页数
        if poiCount > kPOIsOffset{
            pageCount = poiCount / kPOIsOffset + 1
        }else{
            footer.endRefreshingWithNoMoreData()
        }

        if poiCount == 0 { return }
        //print(response.pois.count)
        for poi in response.pois{
            let province = poi.province == poi.city ? "" : poi.province         //判断直辖市是否是省份
            let address = poi.district == poi.address ? "" : poi.address
            
            //拼接地址
            let poi = [
                poi.name ?? kNoPOIPH,
                "\(province.unwrappedText)\(poi.city.unwrappedText)\(poi.district.unwrappedText)\(address.unwrappedText)"
            ]
            pois.append(poi)                                   //添加拼接地址
            if request is AMapPOIAroundSearchRequest{
                aroundSearchedPOIs.append(poi)                 //恢复为之前周边搜索的数据
            }
            tableView.reloadData()
        }
    }
}


// MARK: -
extension POIVC{
    
    // MARK: 监听 - 周边搜索、关键字搜索的上拉加载控件的隐藏
    func endRefreshing(_ currentPage: Int){
        if currentAroundPage < pageCount {
            footer.endRefreshing()          //结束上拉加载小菊花的UI
        }else{
            footer.endRefreshingWithNoMoreData()        //展示加载完毕UI，并使上拉加载功能失效（不触发@obj的方法了）
        }
    }
}
