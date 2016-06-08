//
//  Pay.swift
//  Floral
//
//  Created by ALin on 16/6/3.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

class Pay: NSObject {
    /// 图标
    var icon : UIImage?
    /// 机构名称
    var title : String?
    /// 支付描述
    var des : String?
    
    init(dict:[String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
