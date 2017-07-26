//
//  PageContentView.swift
//  LYQdyzb
//
//  Created by 芦亚琼 on 2017/6/29.
//  Copyright © 2017年 芦亚琼. All rights reserved.
//

import UIKit


protocol PageContentViewDelegate : class {
    func pageContentView(contentView : PageContentView, progress : CGFloat, sourceIndex : Int, targetIndex : Int)
}

fileprivate let ContentCellID = "ContentCellID"

class PageContentView: UIView {
    
    //MARK:- 定义属性
    fileprivate var childVcs : [UIViewController]
    fileprivate weak var parentViewController : UIViewController?//weak防止循环引用
    fileprivate var startOffsetX : CGFloat = 0;//记录属性
    fileprivate var isForbidScrollDelegate : Bool = false
    weak var delegate : PageContentViewDelegate?
    
    
    //MARk: - 懒加载属性
    //[weak self]在闭包中防止循环引用
    fileprivate lazy var collectionView : UICollectionView = {[weak self] in
    
        //1.创建layout 流水布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        //2.创建UICollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false //水平滚动指示器
        collectionView.isPagingEnabled = true //分页
        collectionView.bounces = false //反弹效果
        
        //3.遵循collectionView协议
        collectionView.dataSource = self
        collectionView.delegate = self as! UICollectionViewDelegate
        
        //4.注册cell
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        
        return collectionView
        
    }()

    //MARK:- 自定义构造函数
    init(frame: CGRect, childVcs: [UIViewController], parentViewController: UIViewController?){
        
        self.childVcs = childVcs
        self.parentViewController = parentViewController
    
        super.init(frame: frame)
        
        //设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 设置UI界面
extension PageContentView{

    fileprivate func setupUI(){
    
        //1.将所有子控制器添加到父控制器中
        for childVc in childVcs {
            parentViewController?.addChildViewController(childVc)
        }
        
        //2.添加UICollectionView，用于在Cell中存放控制器的View
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}

//MARK: -遵循UICollectionViewDataSource
extension PageContentView : UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1.创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:ContentCellID, for: indexPath)
        
        //2.0 防止cell循环引用，先把contentView的subviews移除，避免添加多次
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        //2.1 给cell设置内容
        let childVC = childVcs[indexPath.item]
        childVC.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVC.view)
        
//        frame: 该view在父view坐标系统中的位置和大小。（参照点是，父亲的坐标系统）
//        bounds：该view在本地坐标系统中的位置和大小。（参照点是，本地坐标系统，就相当于ViewB自己的坐标系统，以0,0点为起点）
        
        //3.返回cell
        return cell
    }
}


//MARK: -遵循UICollectionViewDelegate
extension PageContentView : UICollectionViewDelegate{

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbidScrollDelegate = false
        
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //0.判断是否是点击事件
        if isForbidScrollDelegate { return }
        
        //1.定义获取需要的数据
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        //2.判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        
        if currentOffsetX > startOffsetX {//左滑
            
            //1.计算progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            //2.计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            //3.计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            //4.如果完全滑过去
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
            
        }else{//右滑
        
            //1.计算progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            
            //3.计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)

            //2.计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }
            
        }
        
        //3.用代理将progress、sourceIndex、targetIndex传给titleView
        delegate?.pageContentView(contentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
        
//        print(progress,sourceIndex,targetIndex)
        
    }
}

//MARK:- 设置对外暴露的方法
extension PageContentView{

    func  setCurrentIndex(currentIndex : Int)  {
        
        isForbidScrollDelegate = true
        
        //随着title的点击，滚动到对应页面
        let offsetX = CGFloat(currentIndex) * collectionView.frame.size.width
        collectionView.setContentOffset(CGPoint(x:offsetX, y:0), animated: false)
        
    }
}
