//
//  Address.swift
//  Floral
//
//  Created by ALin on 16/6/3.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

class Address: NSObject {
    /// 收货详细地址
    var fnConsigneeAddress : String?
    /// 收货地区, 如 :北京, 通州
    var fnConsigneeArea : String?
    /// 用户ID
    var fnCustomerId : String?
    /// 地址ID
    var fnId : String?
    /// 是否是默认地址, 1是默认, 0是非, 也有可能传空, 所有这儿不能设默认值
    var fnIsUse : Int?
    /// 手机号
    var fnMobile : Int64 = 0
    /// 邮编
    var fnPostCode : Int = 0
    /// 收货人
    var fnUserName : String?
    /// 未知属性, 现在传回来的都是空字符串
    var fnConsigneeName : String?
    
    // cell的高度
    var cellHeight : CGFloat {
        var height : CGFloat  = 0.0
        height += (DefaultMargin15 + DefaultMargin20 + DefaultMargin10 + DefaultMargin10)
        height += ((fnConsigneeArea! + fnConsigneeAddress!) as NSString).boundingRectWithSize(CGSize(width: ScreenWidth - DefaultMargin20 - DefaultMargin15 * 2 - 17, height: CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : defaultFont14], context: nil).size.height
        if height < 83 {
            height = 83
        }else{
            height += DefaultMargin10
        }
        return height
    }
    
    
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
