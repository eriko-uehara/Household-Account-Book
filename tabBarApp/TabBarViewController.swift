//
//  TabBarViewController.swift
//  tabBarApp
//
//  Created by 上原絵里子 on 2016/02/16.
//  Copyright © 2016年 eriko.uehara. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 背景色
        //UITabBar.appearance().barTintColor = UIColor"#B3E5FC"
        UITabBar.appearance().barTintColor = UIColor(red: 0.702, green: 0.898, blue: 0.988, alpha: 1.0)
        UITabBar.appearance().tintColor = UIColor(red: 0.247, green: 0.318, blue: 0.710
            , alpha: 1.0)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
