//
//  YQNetWorkTools.swift
//  swiftTest
//
//  Created by 芦亚琼 on 2017/6/27.
//  Copyright © 2017年 芦亚琼. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType {

    case get
    case post
}

class YQNetWorkTools {
    
    class func resquesData(URLString : String, type : MethodType, parameters : [String : Any]? = nil, finishedCallBack : @escaping (_ result : Any) -> ()) {
        
        //三目运算：如果请求类型是get就用HTTPMethod.get，否则用HTTPMethod.post
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        Alamofire.request(URLString, method:  method, parameters: parameters).responseJSON { (response) in
            
            //1.校验是否有结果
            guard let result = response.result.value else {
            
                print(response.result.error ?? "请求失败")  //如果没值，来到这里
                return
            }
            
            //2.将结果回调出去
            finishedCallBack(result)      //如果有值，继续执行，来到这里
            
        }
        
    }

    
}
