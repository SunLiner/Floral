//
//  ShareTool.swift
//  Floral
//
//  Created by ALin on 16/6/1.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

private let DefalutShareUrl = "http://www.jianshu.com/users/9723687edfb5/latest_articles"
class ShareTool: NSObject {
    /// 单例
    static let sharedInstance = ShareTool()
    /// 分享
    func share(platformName: String, shareText text: String?, shareImage image:UIImage?, shareUrl url: String?, handler: UIViewController, finished:()->()){
        let shareUlr = url ?? DefalutShareUrl
        
        var shareContent = text
        
        // 分享的文字必须小于140个汉字
        var contentLength = shareContent?.characters.count ?? 0
        if contentLength > 140 {
            shareContent = (shareContent! as NSString).substringToIndex(139)
        }
        if platformName == UMShareToWechatSession {
            UMSocialData.defaultData().extConfig.wechatSessionData.url = shareUlr
        }else if platformName == UMShareToWechatTimeline{
            UMSocialData.defaultData().extConfig.wechatTimelineData.url = shareUlr
        }else if platformName == UMShareToSina{
            contentLength = shareContent?.characters.count ?? 0
            let urlLength = url?.characters.count ?? 0
            if (contentLength + urlLength) > 140 {
                shareContent = (shareContent! as NSString).substringToIndex(139-urlLength)
            }
            // 新浪微博的链接需要和内容一起
            shareContent = shareContent! + "  \(shareUlr)"
        }
        
        
        
        let shareImage = image ?? UIImage(named: "AppIcon")
        
        let dataService = UMSocialDataService.defaultDataService()
        // 在swift中不能直接打出下面的代码, 需要在桥接文件中加入#import <CoreLocation/CoreLocation.h>
        dataService.postSNSWithTypes([platformName], content: shareContent, image: shareImage, location: nil, urlResource: nil, presentedController: handler) { (response) in
            finished()
        }
    }
}
