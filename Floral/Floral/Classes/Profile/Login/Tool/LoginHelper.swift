//
//  LoginHelper.swift
//  Floral
//
//  Created by ALin on 16/5/24.
//  Copyright © 2016年 ALin. All rights reserved.
//  登录的帮助类

import UIKit

// 登录状态的key
private let LoginStatus = "LoginStatus"

class LoginHelper: NSObject {
    // 一句话实现单例(swift2.0)
    static let sharedInstance = LoginHelper()
    private override init() {} // 防止使用()初始化
    
    /// 一般情况下, 我们可以通过NSHTTPCookieStorage中的NSHTTPCookie来判断登录状态.也可以自定义一个字段来保存.这儿就简单一点了.
    /// 获取登录状态
    func isLogin() -> Bool {
        if let status : Bool = NSUserDefaults.standardUserDefaults().objectForKey(LoginStatus) as? Bool
        {
            return status
        }
        return false
    }
    
    /// 保存登录状态
    func setLoginStatus(status : Bool) {
        NSUserDefaults.standardUserDefaults().setBool(status, forKey: LoginStatus)
    }
    
}
