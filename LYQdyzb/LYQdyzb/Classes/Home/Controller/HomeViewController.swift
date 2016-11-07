//
//  HomeViewController.swift
//  LYQdyzb
//
//  Created by 芦亚琼 on 2016/11/7.
//  Copyright © 2016年 芦亚琼. All rights reserved.
//

import UIKit

private let kTitleViewH : CGFloat = 40

class HomeViewController: UIViewController {

    //MARK:懒加载属性
    fileprivate lazy var pageTitleView : PageTitleView = {
    
        let frame = CGRect(x: 0, y: CGFloat(kStatusBarH + kNavigationBarH), width: CGFloat(kScreenW), height: CGFloat(kTitleViewH))
        let titles = ["推荐","游戏","娱乐","趣玩"]
        let titleView = PageTitleView(frame: frame, titles: titles)
//        titleView.backgroundColor = UIColor.red
        return titleView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        
    }
}


//MARK:-设置界面
extension HomeViewController{

    fileprivate func setUpUI(){
    
        //不要调整UIScrollView的内边距
        automaticallyAdjustsScrollViewInsets = false;
        setNav()
        view.addSubview(pageTitleView)
    }
    
    //设置导航栏
    private func setNav(){
        
        let btn = UIButton()
        btn.setImage(UIImage(named:"logo"), for: .normal)
        btn.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
        
        
        let size = CGSize(width: 40, height: 40)
        
//        一、原始方法
//        let btn1 = UIButton()
//        btn1.setImage(UIImage(named:"Image_scan"), for: .normal)
//        btn1.setImage(UIImage(named:"Image_scan_click"), for: .highlighted)
//        btn1.frame = CGRect(origin: CGPoint(x:0,y:0), size: size)
//        let item1 = UIBarButtonItem(customView: btn1)
//        let btn2 = UIButton()
//        btn2.setImage(UIImage(named:"image_my_history"), for: .normal)
//        btn2.setImage(UIImage(named:"Image_my_history_click"), for: .highlighted)
//        btn2.frame = CGRect(origin: CGPoint(x:0,y:0), size: size)
//        let item2 = UIBarButtonItem(customView: btn2)
//        
//        let btn3 = UIButton()
//        btn3.setImage(UIImage(named:"btn_search"), for: .normal)
//        btn3.setImage(UIImage(named:"btn_search_clicked"), for: .highlighted)
//        btn3.frame = CGRect(origin: CGPoint(x:0,y:0), size: size)
//        let item3 = UIBarButtonItem(customView: btn3)

//        二、扩展类方法
//        let item1 = UIBarButtonItem.creatItem(imageName: "Image_scan", heightImage: "Image_scan_click", size: size)
//        let item2 = UIBarButtonItem.creatItem(imageName: "image_my_history", heightImage: "Image_my_history_click", size: size)
//        let item3 = UIBarButtonItem.creatItem(imageName: "btn_search", heightImage: "btn_search_clicked", size: size)
        
//        三、构造函数方法
        let item1 = UIBarButtonItem(imageName: "Image_scan", heightImage: "Image_scan_click", size: size)
        let item2 = UIBarButtonItem(imageName: "image_my_history", heightImage: "Image_my_history_click", size: size)
        let item3 = UIBarButtonItem(imageName: "btn_search", heightImage: "btn_search_clicked", size: size)
        
        
        navigationItem.rightBarButtonItems = [item1,item2,item3]
    }
    
    
}
