//
//  MallsCategory.swift
//  Floral
//
//  Created by 孙林 on 16/5/9.
//  Copyright © 2016年 ALin. All rights reserved.
//  商品分类

import UIKit

class MallsCategory: NSObject {
    // 描述
    var fnDesc : String?
    // id
    var fnId : String?
    // 类型名称
    var fnName : String?
    // 子序列
    var childrenList : [MallsCategory]?
    
    
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
   
    // 哎呀, 我去! 我天真的以为和OC一样, 调用forkeypath也是可以的, 坑死我了!!!问题是还不报错
    override func setValue(value: AnyObject?, forKey key: String) {
        if key == "childrenList" {
            if let tempValue = value {
                let temp = tempValue as! [[String : AnyObject]]
                var childrenCategory = [MallsCategory]()
                for dict in temp {
                    childrenCategory.append(MallsCategory(dict: dict))
                }
                childrenList = childrenCategory
                return
            }
            
        }
        super.setValue(value, forKey: key)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    // MARK: - 序列化和反序列化
    private let fnDesc_Key = "fnDesc"
    private let fnId_Key = "fnId"
    private let fnName_Key = "fnName"
    private let childrenList_Key = "childrenList"
    // 序列化
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(fnDesc, forKey: fnDesc_Key)
        aCoder.encodeObject(fnId, forKey: fnId_Key)
        aCoder.encodeObject(fnName, forKey: fnName_Key)
        aCoder.encodeObject(childrenList, forKey: childrenList_Key)
    }
    
    // 反序列化
    required init?(coder aDecoder: NSCoder) {
        fnDesc = aDecoder.decodeObjectForKey(fnDesc_Key) as? String
        fnId =  aDecoder.decodeObjectForKey(fnId_Key) as? String
        fnName = aDecoder.decodeObjectForKey(fnName_Key) as? String
        childrenList = aDecoder.decodeObjectForKey(childrenList_Key) as? [MallsCategory]
    }
    
    // MARK: - 保存和获取所有分类
    static let CategoriesKey = "MallsKey"
    /**
     保存所有的分类
     
     - parameter categories: 分类数组
     */
    class func savaCategories(categories: [MallsCategory])
    {
        let data = NSKeyedArchiver.archivedDataWithRootObject(categories)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: MallsCategory.CategoriesKey)
    }
    
    /**
     取出本地保存的分类
     
     - returns: 分类数组或者nil
     */
    class func loadLocalCategories() -> [MallsCategory]?
    {
        if let array = NSUserDefaults.standardUserDefaults().objectForKey(MallsCategory.CategoriesKey)
        {
            return NSKeyedUnarchiver.unarchiveObjectWithData(array as! NSData) as? [MallsCategory]
        }
        return nil
    }

}
