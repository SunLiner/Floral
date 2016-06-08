//
//  NSDate+Extension.swift
//  Floral
//
//  Created by ALin on 16/4/12.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

extension NSDate
{
    class func dateWithstr(dateStr: String) -> NSDate?
    {
        let formatter = NSDateFormatter()
        // 2016-04-24 15:10:24.0
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // 有的时候, 有的服务器生成的时间是采用的其他地区或者语音,这种情况, 一定要设置本地化, 比如这儿的Aug, 如果你不设置成en, 那么鬼才知道你要解析成什么样的.
//        formatter.locale = NSLocale(localeIdentifier: "en")
        return formatter.dateFromString(dateStr)
    }
    
    // 分类中可以直接添加计算型属性, 因为他不需要分配存储空间
    var dateDesc : String{
        let formatter = NSDateFormatter()
        var formatterStr : String?
        let calendar = NSCalendar.currentCalendar()
        if calendar.isDateInToday(self){
            let seconds = (Int)(NSDate().timeIntervalSinceDate(self))
            if seconds < 60{
                return "刚刚"
            }else if seconds < 60 * 60{
                return "\(seconds/60)分钟前"
            }else{
                return "\(seconds/60/60)小时前"
            }
        }else if calendar.isDateInYesterday(self){
            // 昨天: 昨天 17:xx
            formatterStr = "昨天 HH:mm"
        }else{
            
            // 很多年前: 2014-12-14 17:xx
            // 如果枚举可以选择多个, 就用数组[]包起来, 如果为空, 就直接一个空数组
            let components = calendar.components(NSCalendarUnit.Year, fromDate: self, toDate: NSDate(), options: [])
            // 今年: 03-15 17:xx
            if components.year < 1
            {
                formatterStr = "MM-dd HH:mm"
            }else{
                formatterStr = "yyyy-MM-dd HH:mm"
            }
        }
        formatter.dateFormat = formatterStr
        
        return formatter.stringFromDate(self)
    }
}