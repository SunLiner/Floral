//
//  Comment.swift
//  Floral
//
//  Created by ALin on 16/5/30.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

class Comment: NSObject {
    /// 评论的文章的id
    var bbsId : String?
    /// 评论的内容
    var content : String?
    /// 评论的id
    var id : String?
    /// 回复的是谁, 显示 @XXXX
    var toUser : Author?
    /// 回复人
    var writer: Author?
    ///评论时间
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
    
    // 转换后的时间
    var createDateDesc : String?
    
    /// 是否是匿名
    var anonymous : Bool
    {
        if writer?.userName?.characters.count > 0 {
            return false
        }
        return true
    }
    
    
    // 行高, 计算性属性, 只读
    var rowHeight : CGFloat
    {
        let contentWidth = ScreenWidth - DefaultMargin15 - DefaultMargin20 - DefaultHeadHeight
        let contentHeight = (content! as NSString).boundingRectWithSize(CGSizeMake(contentWidth, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(12)], context: nil).size.height
        
        return DefaultMargin10 + DefaultHeadHeight  + contentHeight + DefaultMargin10 + 30 + DefaultMargin10
    }
    
    
    init(dict:[String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        if key == "toUser" {
            toUser = Author(dict: value as! [String : AnyObject])
            return
        }
        if key == "writer" {
            writer = Author(dict: value as! [String : AnyObject])
            return
        }
        super.setValue(value, forKey: key)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    /// 创建快速创建一个comment
    class func quickBuild(content: String, toUserName: String?) -> Comment
    {
        var touser :[String : AnyObject]
        if toUserName?.characters.count < 1 {
            touser = ["id" : "",
               "userName"  : ""]
        }else{
            touser = ["id" : "a1e67080-dd5a-4aea-abae-95712211e69a",
               "userName"  : toUserName!]
        }
        
        
        let writer =  ["id" : "a1e67080-dd5a-4aea-abae-95712211e69a",
                "userName"  : "ALin",
                  "headImg" : "http://static.htxq.net/UploadFiles/headimg/20160422164405309.jpg"]
        
        let dict = ["createDate" : NSDate().dateDesc,
                    "content":content,
                    "toUser" : touser,
                    "writer" : writer
                    ]
        
        return Comment(dict: dict as! [String : AnyObject])
    }
}
