//
//  LoginProfile.swift
//  Floral
//
//  Created by ALin on 16/5/24.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

class LoginProfile: NSObject {
    /// 直接用string即可. 方便post, 也不用转换类型
    /// 国家编号
    var countryNum : Int = 86 // 默认选中中国
    /// 手机号
    var phoneNumber : String?
    /// 验证码
    var safeNum : String?
    /// 密码
    var password : String?
    
    /// 判断是否是手机号
    func isPhoneNumber(phone: String) -> Bool {
        let pattern = "^\\d+$"
        return NSPredicate.init(format: "SELF MATCHES %@", pattern).evaluateWithObject(phone)
    }
}
