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


//定义协议
protocol PageTitleViewDelegate : class {//写class表示协议只能被类遵守，不能被结构体、枚举等遵守
    func pageTitleView(titleView :PageTitleView, selectedIndex index : Int)
}

//定义属性
let kScrkllLineH : CGFloat = 2.0
fileprivate let kNormalColor : (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
fileprivate let kSelectColor : (CGFloat, CGFloat, CGFloat) = (255, 128, 0)

//定义类
class PageTitleView: UIView {
    
    //定义属性
    fileprivate var currentIndex = 0  //记录当前选中label的下标，默认选中第0个下标
    fileprivate var titles : [String]
    weak var delegate :PageTitleViewDelegate?//代理属性 用weak
    
    //懒加载数组
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    
    //懒加载创建的控件
    fileprivate lazy var scrollLine : UIView  = {
    
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
    
    
    //懒加载创建scrollView
    fileprivate lazy var scrollView : UIScrollView = {
    
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        
        return scrollView
        
    }()
    
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
    
        //1.添加滚动视图
        addSubview(scrollView)
        scrollView.frame = bounds
        
        //2.设置标题文字
        setupTitelLabels()
        
        //3.设置底线和滚动的滑块
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
            
            //1.创建label
            let label = UILabel()
            //2.设置label的属性
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = .center
            //3.设置label的frame
            let labelX : CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
        
            //4.将label添加到scrollView中
            scrollView.addSubview(label)
            //创建的label加到数组中，以便获取第一个
            titleLabels.append(label)
            
            //5.给label添加手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(tapGes:)))
            label.addGestureRecognizer(tapGes)
            
        }
    }
    
    private func setbottomLine(){
    
        
        //1.添加底部的横线
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        let lineH : CGFloat = 0.5
        view.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(view)
        
        //获取数组中的第一个Label
        guard let firstLabel = titleLabels.first else {return}
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        
        //2.添加滚动的滑块
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrkllLineH, width: firstLabel.frame.width, height: kScrkllLineH)
    }
}

//MARK: - 监听label点击
extension PageTitleView{

    //事件监听 前面要加@objc
    @objc fileprivate func titleLabelClick(tapGes : UITapGestureRecognizer){
        
        //1.获取当前label
        guard let currentLabel = tapGes.view as? UILabel else { return }
        //2.获取之前的label
        let oldLabel = titleLabels[currentIndex]
        //3.切换文字颜色
        currentLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        //4.保存最新label的下标值
        currentIndex = currentLabel.tag
        //5.滚动条位置发生改变
        let scrollLinex = CGFloat(currentIndex) * scrollLine.frame.size.width
        UIView.animate(withDuration: 0.15) {
            //一个view的frame 包含它的矩形形状（size）的长和宽。和它在父视图中的坐标原点（origin）x和y坐标
            self.scrollLine.frame.origin.x = scrollLinex
        }
        //6.通知代理
        delegate?.pageTitleView(titleView: self, selectedIndex: currentIndex)
        
    }
    
}

//MARK: - 对外暴露的方法
extension PageTitleView{

    func setTitleWithProgress(progress : CGFloat, sourceIndex : Int, targetIndex : Int) {
        
        //1.取出sourceLabel/targetlabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        //2.处理滑块的逻辑
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        //3.颜色渐变
        //3.1取出变化的范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        
        //3.2变化sourceLabel
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        
        //3.3变化targetLabel
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        
        //4.记录最新的index
        currentIndex = targetIndex
        
    }
}
