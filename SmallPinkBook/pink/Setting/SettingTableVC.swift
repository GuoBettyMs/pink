//
//  SettingTableVC.swift
//  pink
//
//  Created by gbt on 2022/11/15.
//
/*
    个人页面的‘设置’页面 
 */
import UIKit
import Kingfisher
import LeanCloud

class SettingTableVC: UITableViewController {

    var user: LCUser!      //给‘账号与安全’功能传值
    @IBOutlet weak var cacheSizeL: UILabel!
    
    var cacheSizeStr = kNoCachePH{
        didSet{
            DispatchQueue.main.async {
                self.cacheSizeL.text = self.cacheSizeStr
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //计算缓存文件的容量.此处以Kingfisher缓存为例,其余省略
        ImageCache.default.calculateDiskStorageSize { res in
            if case let .success(size) = res {
                var cacheSizeStr: String{
                    guard size > 0 else { return kNoCachePH }
                    guard size >= 1024 else { return "\(size) B" }
                    guard size >= 1048576 else { return "\(size / 1024) KB" } //1048576 = 1024 ^ 2
                    guard size >= 1073741824 else { return "\(size / 1048576) MB" }//1073741824 = 1024 ^ 3
                    return "\(size / 1073741824) GB"
                }
                self.cacheSizeStr = cacheSizeStr
                
            }
        }
      
    }

  
    // MARK: 给‘账号与安全’功能传值
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let acountTableVC = segue.destination as? AccountTableVC{
            acountTableVC.user = user
        }
    }
    
    
}


