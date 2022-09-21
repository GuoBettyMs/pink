//
//  MyViewController.swift
//  LittlePinkBook
//
//  Created by isdt on 2022/9/20.
//
/*
    用代码做 UICollectionView, 和 AutoLayout
*/


import UIKit

class ViewController: UIViewController, UICollectionViewDataSource {

    private let photos = [UIImage(named: "Post-1"), UIImage(named: "Post-2"), UIImage(named: "Post-3")]
    
    private lazy var cv: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 90, height: 90)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .systemBackground
        
        //元类型(类型的类型)-metatype
        //let x: Int = 1
        //let xx: Int.Type = Int.self       //调用元类型时,要用 类型.self
        cv.register(CVCell.self, forCellWithReuseIdentifier: "CVCellID")
        cv.dataSource = self
        
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cv)
        setUI()
    }
    
    private func setUI(){
        cv.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        cv.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        cv.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        cv.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
//        NSLayoutConstraint.activate([
//            cv.heightAnchor.constraint(equalToConstant: 90)
//        ])
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CVCellID", for: indexPath) as! CVCell
        cell.imageView.image = photos[indexPath.item]
        return cell
    }

}


class CVCell: UICollectionViewCell{
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
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
