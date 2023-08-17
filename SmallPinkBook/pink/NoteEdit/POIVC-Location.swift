//
//  POIVC-Location.swift
//  pink
//
//  Created by isdt on 2022/9/26.
//
/*
    小粉书的底部导航栏的“发布”功能 -> 查询地点功能(周边搜索) -> viewDidLoad 内容
 */

extension POIVC{
    func requestLocation(){
        // MARK: 请求定位
        showLoadHUD()     //开启菊花加载效果
        
        //请求位置权限、逆地理编码reGeocode <#注#> withReGeocode 为true,表示开启异步任务
        locationManager.requestLocation(withReGeocode: true, completionBlock: { [weak self] (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in

            if let error = error {
                let error = error as NSError
                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
                    print("定位错误:{\(error.code) - \(error.localizedDescription)};")
                    self?.hideLoadHUD()              //关闭菊花加载效果
                    return
                }
                else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                    || error.code == AMapLocationErrorCode.timeOut.rawValue
                    || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
                    || error.code == AMapLocationErrorCode.badURL.rawValue
                    || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                    || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue {
                    
                    //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
                    print("逆地理错误:{\(error.code) - \(error.localizedDescription)};")
                    self?.hideLoadHUD()              //关闭菊花加载效果
                    return
                }
                else {
                    //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
                }
            }
            
            guard let POIVC = self else { return }
            
            if let location = location {
//                print("location:", location)
                
                // 获取当前的地理坐标
                POIVC.latitude = location.coordinate.latitude
                POIVC.longitude = location.coordinate.longitude
                
                // MARK: 搜索周边POI
                POIVC.setAroundSearchFooter()               //搜索前增加上拉加载处理事件
                POIVC.makeAroundSearch()
            }
            
            //子线程并发的异步执行代码
            if let reGeocode = reGeocode {
//                print("reGeocode:", reGeocode)
                //几个常用场景的说明:
                //1.直辖市的province和city是一样的
                //2.偏远乡镇的street等小范围的东西都可能是nil
                //3.用户在海上或海外,若未开通‘海外LBS服务’,则都返回nil
                
                guard let formattedAddress = reGeocode.formattedAddress, !formattedAddress.isEmpty else{return}
                let province = reGeocode.province == reGeocode.city ? "" : reGeocode.province
               
                //拼接地址
                let currentPOI = [
                    reGeocode.poiName ?? kNoPOIPH,
                    "\(province.unwrappedText)\(reGeocode.city.unwrappedText)\(reGeocode.district.unwrappedText)\(reGeocode.street.unwrappedText)\(reGeocode.number.unwrappedText)"
                ]
                POIVC.pois.append(currentPOI)                              //添加拼接地址
                POIVC.aroundSearchedPOIs.append(currentPOI)                //恢复为之前周边搜索的数据
                
                //回到主线程执行UI,主线程不能同步sync执行
                DispatchQueue.main.async {
                    POIVC.tableView.reloadData()            //获取地址需要时间,故需要reloadData,使继续遵守 UITableViewDataSource
                }

            }
        })
        
    }
}
// MARK: -
extension POIVC{
    
    // MARK: 一般函数 - 周边搜索的请求每一页搜索内容
    private func makeAroundSearch( _ page: Int = 1){
        aroundSearchRequest.page = page
        mapSearch?.aMapPOIAroundSearch(aroundSearchRequest)
    }
    
    // MARK: 一般函数 - 周边搜索的上拉加载处理事件
    func setAroundSearchFooter(){
        //重置(reset)
        footer.resetNoMoreData()        //恢复为正常footer(防止因之前加载完毕后footer的不可用)
        footer.setRefreshingTarget(self, refreshingAction: #selector(aroundSearchPullToRefresh))
    }
}

// MARK: -
extension POIVC{
   
    // MARK: 监听 - 周边搜索的上拉加载控件
    @objc private func aroundSearchPullToRefresh(){
        currentAroundPage += 1
        makeAroundSearch(currentAroundPage)             //请求第二页搜索内容
        endRefreshing(currentAroundPage)
    }

}

