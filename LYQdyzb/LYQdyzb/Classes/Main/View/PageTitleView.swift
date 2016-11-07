//
//  PageTitleView.swift
//  LYQdyzb
//
//  Created by 芦亚琼 on 2016/11/7.
//  Copyright © 2016年 芦亚琼. All rights reserved.
//

import UIKit


//在swift 3中，新增加了一个 fileprivate来显式的表明，这个元素的访问权限为文件内私有。过去的private对应现在的fileprivate。现在的private则是真正的私有，离开了这个类或者结构体的作用域外面就无法访问。

//open则是弥补public语义上的不足。
//现在的访问权限则依次为：open，public，internal，fileprivate，private。

let kScrkllLineH : CGFloat = 2.0


class PageTitleView: UIView {
    
    //懒加载数组
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    
    //懒加载创建的控件
    fileprivate lazy var scrollLine : UIView  = {
    
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
    
    
    //懒加载要创建的控件
    fileprivate lazy var scrollView : UIScrollView = {
    
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        
        return scrollView
        
    }()

    fileprivate var titles : [String]
    
    //自定义构造函数
    init(frame: CGRect, titles : [String]) {
        
       self.titles = titles
        
        super.init(frame: frame)

        setupUI()
    
    }
    
    //自定义构造函数必须写的方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




extension PageTitleView{
    
    fileprivate func setupUI(){
    
        addSubview(scrollView)
        scrollView.frame = bounds
        
        setupTitelLabels()
        setbottomLine()
        
    }
    
    
    private func setupTitelLabels() {
    
//  for i in 0..<titles.count
//  {
//    
//
//  }
        //把可以直接创建的属性写在循环外面 提高性能
        let labelW : CGFloat = frame.width / CGFloat (titles.count)
        let labelH : CGFloat = frame.height - kScrkllLineH
        let labelY : CGFloat = 0
        
        for (index, title) in titles.enumerated() {
            
            let label = UILabel()
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textColor = UIColor.darkGray
            label.textAlignment = .center
            
            let labelX : CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            scrollView.addSubview(label)

            //创建的label加到数组中，以便获取第一个
            titleLabels.append(label)
        }
    }
    
    private func setbottomLine(){
    
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        let lineH : CGFloat = 0.5
        view.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(view)
        
        //获取数组中的第一个Label
        guard let firstLabel = titleLabels.first else {return}
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrkllLineH, width: firstLabel.frame.width, height: kScrkllLineH)
    }
}

