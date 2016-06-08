//
//  Goods.swift
//  Floral
//
//  Created by 孙林 on 16/5/11.
//  Copyright © 2016年 ALin. All rights reserved.
//  商品详情

import UIKit

class Goods: NSObject {
    /// 1是推荐  2是最热
    var fnJian : Int = 0
        {
        didSet{
            if fnJian == 2 {
                fnjianIcon = UIImage(named: "f_hot_56x51")
                fnjianTitle = "最热"
            }else{
                fnjianIcon = UIImage(named: "f_jian_56x51")
                fnjianTitle = "推荐"
            }
        }
    }
    /// 图片地址
    var fnAttachment : String?
    /// 缩略图
    var fnAttachmentSnap : String?
    /// 价格
    var fnMarketPrice : Float = 0
    /// 类型(暂且理解为是类型)
    var fnEnName : String?
    /// 商品名字
    var fnName : String?
    /// 商品ID
    var fnId : String?

    /// 推荐/最热的图片
    var fnjianIcon : UIImage?
    /// 推荐/最热的文字
    var fnjianTitle : String?
    
    /// 默认收货地址
    var uAddress : Address?
    
    
    init(dict:[String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        if key == "uAddress" {
            if let iValue = value {
                 uAddress = Address(dict: iValue as! [String : AnyObject])
            }
           return
        }
        super.setValue(value, forKey: key)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
