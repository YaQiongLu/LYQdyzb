//
//  UIColor-Extension.swift
//  LYQdyzb
//
//  Created by 芦亚琼 on 2017/6/29.
//  Copyright © 2017年 芦亚琼. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(r:CGFloat, g:CGFloat, b:CGFloat){
    
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
    
}
