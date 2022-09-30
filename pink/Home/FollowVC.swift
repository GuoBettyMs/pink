//
//  FollowVC.swift
//  LittlePinkBook
//
//  Created by isdt on 2022/9/15.
//
/*
    视图控制器 HomeVC buttonBarView 的“关注”子视图控制器
 
 */

import UIKit
import XLPagerTabStrip
import CHTCollectionViewWaterfallLayout

private let kFollowCellID = "FollowCellID"

class FollowVC: UIViewController, IndicatorInfoProvider {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let btn = ColorBtn(frame: CGRect(x: 100, y: 100, width: 100, height: 100), color: .green)
//        btn.setTitle("便利构造器测试按钮", for: .normal)
//        view.addSubview(btn)
        
//        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let layout = collectionView.collectionViewLayout as! CHTCollectionViewWaterfallLayout
        layout.columnCount = 2
        layout.minimumColumnSpacing = kWaterfallPadding
        layout.minimumInteritemSpacing = kWaterfallPadding
        layout.sectionInset = UIEdgeInsets(top: 0, left: kWaterfallPadding, bottom: kWaterfallPadding, right: kWaterfallPadding)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        IndicatorInfo(title: NSLocalizedString("Follow", comment: "首页上方的关注标签"))
    }

}

extension FollowVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 13
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kFollowCellID, for: indexPath) as! FollowCell
        cell.imgView.image = UIImage(named: "Post-\(indexPath.item + 1)")!
        return cell
    }

}

// MARK: xx - 遵守CHTCollectionViewDelegateWaterfallLayout
extension FollowVC: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        UIImage(named: "Post-\(indexPath.item + 1)")!.size
    
    }
}


// MARK: - 子类里的初始化构造器(3种)
//1.子类没有'无初始值的自有属性'时,直接重写父类的init--如下
/*
 class CVCell: UICollectionViewCell{
     lazy var imageView: UIImageView = {
         let imageView = UIImageView()
         imageView.translatesAutoresizingMaskIntoConstraints = false
         imageView.contentMode = .scaleAspectFill
         return imageView
     }()
 
    //<#指定构造器#> Designed
     override init(frame: CGRect) {
         super.init(frame: frame)
         
         addSubview(imageView)
         setUI()
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     private func setUI(){
         imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
         imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
         imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
         imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
     }
 }
 */

class ColorBtn: UIButton{
    var color: UIColor
    
    //2.子类有'无初始值的自有属性'时,需定义自己的init,在这个init里面先给自己的属性赋值,再super.init
    init(frame: CGRect, color: UIColor){
        self.color = color
        super.init(frame: frame)
        backgroundColor = color
    }
    
    //3.若对象时从IB中创建的,则走required init?(coder: NSCoder)构造器
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
