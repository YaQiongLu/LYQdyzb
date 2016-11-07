//
//  MainViewController.swift
//  LYQdyzb
//
//  Created by 芦亚琼 on 2016/11/7.
//  Copyright © 2016年 芦亚琼. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildVc(storyName: "Home")
        addChildVc(storyName: "Live")
        addChildVc(storyName: "Follow")
        addChildVc(storyName: "Profile")
        
        
    }
    
    private func addChildVc(storyName : String) {
    
        let chileVc = UIStoryboard(name: storyName, bundle: nil).instantiateInitialViewController()!
        addChildViewController(chileVc)
        
    }
    
    
    
    
}
