//
//  RecommendVC.swift
//  LYQdyzb
//
//  Created by 芦亚琼 on 2017/8/3.
//  Copyright © 2017年 芦亚琼. All rights reserved.
//

import UIKit

fileprivate let kItemMargin : CGFloat = 10
fileprivate let kItemW = (kScreenW - 3 * kItemMargin) / 2
fileprivate let kItemNormalH = kItemW * 3 / 4
fileprivate let kItemPrettyH = kItemW * 4 / 3
fileprivate let kHeaderViewH : CGFloat = 50


fileprivate let kNormalCellId = "kNormalCellId"
fileprivate let kPrettyCellId = "kPrettyCellId"
fileprivate let kHeaderViewId = "kHeaderViewId"

class RecommendVC: UIViewController {
    
    //MARK: - 懒加载属性
    lazy var collectionView : UICollectionView = {

        //1.创建布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kItemW, height: kItemNormalH)
        layout.minimumLineSpacing = 0 //最小线间距
        layout.minimumInteritemSpacing = kItemMargin //最小项目间距
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderViewH)//设置组头
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)//设置内边距 让两边的margin平均
        
        //2.创建collectionView
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self as UICollectionViewDataSource
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleHeight,.flexibleWidth]//随着父控件的高度／宽度拉伸而拉伸
        collectionView.register(UINib(nibName: "CollectionNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellId)//注册cell
        collectionView.register(UINib(nibName: "CollectionPrettyCell", bundle: nil), forCellWithReuseIdentifier: kPrettyCellId)//注册cell
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewId)//注册组头
        return collectionView
        
    }()
    

    //MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        //1.设置UI
        setupUI()
        
        //2.发送网络请求
        loadData()
    }

}

//MARK: - 设置UI界面内容
extension RecommendVC{

    fileprivate func setupUI() {
        
        //1.将collectionView添加到控制器view中
        view.addSubview(collectionView)
    }
}


//MARK: -请求网络数据
extension RecommendVC{

    fileprivate func loadData() {
        
    }
}

//MARK: - UICollectionViewDataSource数据源协议
extension RecommendVC : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    //1.返回组
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 12
    }
    
    //2.返回行
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 8
        }
        return 4
    }

    //3.返回怎样的cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        var cell : UICollectionViewCell!
        
        //1.获取cell
        if indexPath.section == 1 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPrettyCellId, for: indexPath)
        }else{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellId, for: indexPath)
        }
        
        return cell
    }
    
    //4.返回怎样的组头
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //1.取出每组的headerView
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewId, for: indexPath)
    
        return headerView
        
    }
    
    //5.每组item返回怎样的高度
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 1 {
            return CGSize(width: kItemW, height: kItemPrettyH)
        }else{
            return CGSize(width: kItemW, height: kItemNormalH)
        }
    }
    
}
