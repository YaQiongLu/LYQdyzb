//
//  UIBarButton-Extension.swift
//  LYQdyzb
//
//  Created by 芦亚琼 on 2016/11/7.
//  Copyright © 2016年 芦亚琼. All rights reserved.
//

import UIKit

extension UIBarButtonItem{


    /*  一、类方法 类扩展方法
    class func creatItem (imageName : String , heightImage : String, size : CGSize) -> UIBarButtonItem{
        
        let btn = UIButton()
        btn.setImage(UIImage(named:imageName), for: .normal)
        btn.setImage(UIImage(named:heightImage), for: .highlighted)
        btn.frame = CGRect(origin: CGPoint(x:0, y:0), size: size)
        
        return UIBarButtonItem (customView: btn)
    }
 */
    
    //二、便利构造函数方法
    convenience init(imageName : String , heightImage : String , size : CGSize) {
        
        let btn = UIButton()
        btn.setImage(UIImage(named:imageName), for: .normal)
        btn.setImage(UIImage(named:heightImage), for: .highlighted)
        btn.frame = CGRect(origin: CGPoint(x:0, y:0), size: size)
        
        self.init(customView:btn)
    }
}
