//
//  PieGraphView.swift
//  tabBarApp
//
//  Created by 上原絵里子 on 2016/02/10.
//  Copyright © 2016年 eriko.uehara. All rights reserved.
//

import UIKit

class PieGraphView: UIView {
    
    var _params:[Dictionary<String,AnyObject>]!
    var _end_angle:CGFloat!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect,params:[Dictionary<String,AnyObject>]) {
        super.init(frame: frame)
        _params = params;
        self.backgroundColor = UIColor.clearColor();
        _end_angle = -CGFloat(M_PI / 2.0);
    }
    
    func update(link:AnyObject){
        let angle = CGFloat(M_PI*2.0 / 100.0);
        _end_angle = _end_angle +  angle
        if(_end_angle > CGFloat(M_PI*2)) {
            //終了
            link.invalidate()
        } else {
            self.setNeedsDisplay()
        }
    }
    
    func startAnimating(){
        let displayLink = CADisplayLink(target: self, selector: Selector("update:"))
        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        let context:CGContextRef = UIGraphicsGetCurrentContext()!;
        var x:CGFloat = rect.origin.x;
        x += rect.size.width/2;
        var y:CGFloat = rect.origin.y;
        y += rect.size.height/3;
        var max:CGFloat = 0;
        for dic : Dictionary<String,AnyObject> in _params {
            let value = CGFloat(dic["value"] as! Float)
            max += value;
        }
        
        var start_angle:CGFloat = -CGFloat(M_PI / 2);
        var end_angle:CGFloat    = 0;
        let radius:CGFloat  = x - 90.0;
        for dic : Dictionary<String,AnyObject> in _params {
            let value = CGFloat(dic["value"] as! Float)
            end_angle = start_angle + CGFloat(M_PI*2) * (value/max);
            if(end_angle > _end_angle) {
                end_angle = _end_angle;
            }
            let color:UIColor = dic["color"] as! UIColor
            
            CGContextMoveToPoint(context, x, y);
            CGContextAddArc(context, x, y, radius,  start_angle, end_angle, 0);
            
            CGContextSetFillColor(context, CGColorGetComponents(color.CGColor));
            CGContextClosePath(context);
            CGContextFillPath(context);
            start_angle = end_angle;
        }
    }
}