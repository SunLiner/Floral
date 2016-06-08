//
//  Area.swift
//  Floral
//
//  Created by 孙林 on 16/6/5.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

class Area: NSObject {
    /// 二级城市
    var cities : [Area]?
    /// 城市名
    var state : String?
    /// 二级城市中的城市名
    var city : String?
    
    
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        if key == "cities" {
            if let iValue = value {
                var iCities = [Area]()
                for dict in iValue as! [[String : AnyObject]] {
                    iCities.append(Area(dict: dict))
                }
                cities = iCities
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    
    class func loadAllArea() -> [Area] {
        let path = NSBundle.mainBundle().pathForResource("area", ofType: "plist")!
        let array = NSArray(contentsOfFile: path)
        var ares = [Area]()
        for dict in array as! [[String : AnyObject]]{
           ares.append(Area(dict: dict))
        }
        return ares
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }

}
