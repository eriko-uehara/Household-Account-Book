//
//  ButtonCustom.swift
//  tabBarApp
//
//  Created by 上原絵里子 on 2016/02/16.
//  Copyright © 2016年 eriko.uehara. All rights reserved.
//

import UIKit

@IBDesignable
class ButtonCustom: UIButton {
    
    @IBInspectable var textColor: UIColor?
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clearColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
}