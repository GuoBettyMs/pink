//
//  POIVC-KeywordsSearch.swift
//  pink
//
//  Created by isdt on 2022/9/27.
//
/*
    小粉书的底部导航栏的“发布”功能 -> 查询地点功能(关键字搜索) -> viewDidLoad 内容
 */
// MARK: -
extension POIVC: UISearchBarDelegate{
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) { dismiss(animated: true) }
   
    // MARK: 遵守 UISearchBarDelegate - 清空搜索栏后的处理 & 关键字搜索POI(自动搜索)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print(searchText)
/*
         //关键字搜索POI(自动搜索),实时自动搜索,但是删除关键字后,菊花加载框未消失
 
        keywords = searchText
        pois.removeAll()
        showLoadHUD()
        keywordsSearchRequest.keywords = keywords
        mapSearch?.aMapPOIKeywordsSearch(keywordsSearchRequest)
 */

        if searchText.isEmpty{
            //重置(reset)
            pois = aroundSearchedPOIs   //恢复为之前周边搜索的数据
            setAroundSearchFooter()     //恢复为周边搜索的上拉加载功能(防止之前是从关键字搜索过来的)
            tableView.reloadData()
        }
    }
    
    // MARK:  遵守 UISearchBarDelegate - 关键字搜索POI(手动搜索)
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
        //判断搜索栏是否有空字符串
        guard let searchText = searchBar.text, !searchText.isBlank else { return }
//        print(searchBar.text)
        keywords = searchText
        
        //重置(reset)
        pois.removeAll()            //恢复为检索前的空数据状态
        currentKeywordsPage = 1     //恢复内存中的当前页数(防止还停留在之前一次的关键字检索中,比如之前加载了3页,这次检索开始时就为3)
        setKeywordsSearchFooter()
        showLoadHUD()
        makeKeywordsSearch(keywords)
    }
}


// MARK: -
extension POIVC{
    
    // MARK: 一般函数 - 关键字搜索的请求每一页搜索内容
    private func makeKeywordsSearch(_ keywords: String, _ page: Int = 1){
        keywordsSearchRequest.page = page
        keywordsSearchRequest.keywords = keywords
        mapSearch?.aMapPOIKeywordsSearch(keywordsSearchRequest)
    }
    
    // MARK: 一般函数 - 关键字搜索的上拉加载处理事件
    func setKeywordsSearchFooter(){
        //重置(reset)
        footer.resetNoMoreData()        //恢复为正常footer(防止因之前加载完毕后footer的不可用)
        footer.setRefreshingTarget(self, refreshingAction: #selector(keywordsSearchPullToRefresh))
    }
}

// MARK: -
extension POIVC{
   
    // MARK: 监听 - 关键字搜索的上拉加载控件
    @objc private func keywordsSearchPullToRefresh(){
        currentKeywordsPage += 1
        makeKeywordsSearch(keywords, currentKeywordsPage)             //请求第二页搜索内容
        endRefreshing(currentKeywordsPage)
    }

}
