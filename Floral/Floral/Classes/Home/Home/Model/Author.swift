//
//  Author.swift
//  Floral
//
//  Created by ALin on 16/4/26.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

class Author: NSObject {
    // 认证类型: 专家
    var auth : String?
    // 所在城市
    var city : String?
    // 简介
    var content : String?
    // 是否订阅
    var dingYue : Int = 0
    // 头像
    var headImg : String?
    {
        didSet{
            if !headImg!.hasPrefix("http://") {
                headImg = "http://static.htxq.net/" + headImg!
            }
        }
    }
    // 用户id
    var id : String?
    // 标示: 官方认证
    var identity : String?
    // 用户名
    var userName : String?
    // 手机号
    var mobile : Int64 = 18618234090
    // 订阅数
    var subscibeNum : Int  = 0
    // 认证的等级, 1是yellow, 2是个人认证
    var newAuth : Int = 0
        {
        didSet{
            switch newAuth {
            case 1:
                authImage = UIImage(named: "u_vip_yellow")
            case 2:
                authImage = UIImage(named: "personAuth")
            default:
                authImage = UIImage(named: "u_vip_blue")
            }
        }
    }
    var authImage : UIImage?
    // 经验值
    var experience : Int = 0
    // 等级
    var level : Int = 1
    // 积分
    var integral : Int = 0
    
    
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
