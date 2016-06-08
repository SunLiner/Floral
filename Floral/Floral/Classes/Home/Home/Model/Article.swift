//
//  Article.swift
//  Floral
//
//  Created by ALin on 16/4/26.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

class Article: NSObject {
    // 创建时间
    var createDate : String?
    {
        didSet{
            if var date = createDate {
                if date.containsString(".0") {
                    date = date.stringByReplacingOccurrencesOfString(".0", withString: "")
                }
                let time : NSDate? = NSDate.dateWithstr(date)
                if let t = time {
                    createDateDesc = t.dateDesc;
                }
            }
        }
    }
    
    // 描述创建时间, 比如昨天, 今天, 去年等
    var createDateDesc : String?
    
    // 摘要
    var desc : String?
    // 评论数
    var fnCommentNum : Int = 0
    // 点赞数
    var favo : Int = 0
    // 文章ID
    var id : String?
    // 序号
    var order : Int = 0
    // 文章的H5地址
    var pageUrl : String?
    // 阅读数
    var read : Int = 0
    // 分享数
    var share : Int = 0
    // 用户分享的URL
    var sharePageUrl : String?
    // 缩略图
    var smallIcon : String?
    // 文章标题
    var title : String?
    // 是否是首页的, 如果是首页不显示时间
    var isNotHomeList : Bool = false
    
    
    // 作者
    var author : Author?
    
    // 所属分类
    var category : Category?
    
    
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        // 单独处理author和category
        if key == "author" {
            if let valueOfKey = value{
                author = Author(dict: valueOfKey as! [String : AnyObject])
            }
            return;
        }
        if key == "category" {
            if let valueOfKey = value{
                category = Category(dict: valueOfKey as! [String : AnyObject])
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
}
