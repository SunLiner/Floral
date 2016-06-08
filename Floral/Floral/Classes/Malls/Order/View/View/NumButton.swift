//
//  NumButton.swift
//  Floral
//
//  Created by ALin on 16/6/3.
//  Copyright © 2016年 ALin. All rights reserved.
//  点击不同区域, 有不用响应的button

import UIKit

// 购买数量变化的通知名
let BuyNumNotifyName = "BuyNumNotifyName"
// 购买数量变化的通知的userinfo的key
let BuyNumKey = "BuyNumKey"

class NumButton: UIButton {
    var num : Int = 1 {
        didSet{
            if num < 1 { // 最少购买一件
                num = 1
                showErrorMessage("购买数量不能小于1, 亲")
            }else
                if(num > 99){ // 最多购买99件
                num = 99
                showErrorMessage("企业购买请联系我们的客服")
            }
            setTitle("\(num)", forState: .Normal)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 取出当前点击的点
        let touch = touches.first!
        // 获取point
        let point = touch.locationInView(self)
        
        
        if CGRectContainsPoint(CGRect(x: 0, y: 0, width: frame.width * 0.5, height: frame.height), point) // 点击了减号
        {
            num -= 1
        }else{ // 点击了加号区域
            num += 1
        }
       
        NSNotificationCenter.defaultCenter().postNotificationName(BuyNumNotifyName, object: nil, userInfo: [BuyNumKey: num])
    }

}
