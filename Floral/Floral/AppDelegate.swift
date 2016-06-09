//
//  AppDelegate.swift
//  Floral
//
//  Created by ALin on 16/4/25.
//  Copyright © 2016年 ALin. All rights reserved.


//  github : https://github.com/SunLiner/Floral
//  blog : http://www.jianshu.com/p/2893be49c50e


import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 方便测试: 每次登录的时候, 都把登录状态设置false
//        LoginHelper.sharedInstance.setLoginStatus(false)
        
        // 设置全局的UINavigationBar属性
        let bar = UINavigationBar.appearance()
        bar.tintColor = UIColor.blackColor()
        bar.titleTextAttributes = [NSFontAttributeName : UIFont.systemFontOfSize(15), NSForegroundColorAttributeName : UIColor.blackColor()]
        
        // 设置window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        // 根据版本号, 判断显示哪个控制器
        if toNewFeature() {
            window?.rootViewController = NewFeatureViewController()
        }else{
            window?.rootViewController = MainViewController()
        }
        
        // 设置相关的appkey
        setAppKey()
        
        window?.makeKeyAndVisible()
        
        
        
        return true
    }
    
    private let SLBundleShortVersionString = "SLBundleShortVersionString"
    // MARK: - 判断版本号
    private func toNewFeature() -> Bool
    {
        // 根据版本号来确定是否进入新特性界面
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        let oldVersion = NSUserDefaults.standardUserDefaults().objectForKey(SLBundleShortVersionString) ?? ""
        
        // 如果当前的版本号和本地保存的版本比较是降序, 则需要显示新特性
        if (currentVersion.compare(oldVersion as! String)) == .OrderedDescending{
            // 保存当前的版本
             NSUserDefaults.standardUserDefaults().setObject(currentVersion, forKey: SLBundleShortVersionString)
            return true
        }
        return false
    }
    
    
    // MARK: - 设置相关的APPkey
    private func setAppKey()
    {
        // 设置友盟的appkey
        UMSocialData.setAppKey("574e565fe0f55a1b7c002d43")
        // 如果碰到"NSConcreteMutableData wbsdk_base64EncodedString]: ..."这个错误, 说明新版的新浪SDK不支持armv7s, 需要在在other linker flags增加-ObjC 选项，并添加ImageIO 系统framework
        // 如果需要使用SSO授权, 需要在info里面添加白名单, 具体可以直接拷贝我的info.plist里面的LSApplicationQueriesSchemes
        UMSocialSinaSSOHandler.openNewSinaSSOWithAppKey("3433284356", secret: "a4708df245b826da73511ad268a85c3c", redirectURL: "http://sns.whalecloud.com/sina2/callback")
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        let result = UMSocialSnsService.handleOpenURL(url)
        if result == false {
            
        }
        return result
    }
    

}

// 首先要明确一点: swift里面是没有宏定义的概念
// 自定义内容输入格式: 文件名[行号]函数名: 输入内容
// 需要在info.plist的other swift flag的Debug中添加DEBUG
func ALinLog<T>(message: T, fileName: String = #file, lineNum: Int = #line, funcName: String = #function)
{
    #if DEBUG
        print("\((fileName as NSString).lastPathComponent)[\(lineNum)] \(funcName): \(message)")
    #endif
}

