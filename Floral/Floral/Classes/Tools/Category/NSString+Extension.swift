//
//  NSString+Extension.swift
//  Floral
//
//  Created by 孙林 on 16/6/5.
//  Copyright © 2016年 ALin. All rights reserved.
//

import Foundation

extension String
{
    /// 判断是否是手机号
    func isPhoneNumber() -> Bool {
        let pattern = "^1[345789]\\d{9}$"
        return NSPredicate.init(format: "SELF MATCHES %@", pattern).evaluateWithObject(self)
    }
    
    
    /// 判断是否是邮政编码
    func isPostCode() -> Bool {
        let pattern = "^\\d{6}$"
        return NSPredicate.init(format: "SELF MATCHES %@", pattern).evaluateWithObject(self)
    }
}