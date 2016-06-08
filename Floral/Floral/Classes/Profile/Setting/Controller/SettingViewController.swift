//
//  SettingViewController.swift
//  Floral
//
//  Created by 孙林 on 16/5/25.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit
import Kingfisher
let LoginoutNotify = "LoginoutNotify"

class SettingViewController: UITableViewController {

    // 缓存label
    @IBOutlet weak var cacheLabel: UILabel!
    // 图片缓存
    private lazy var cache = Kingfisher.ImageCache.defaultCache
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup()
    {
        tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        
        // 由于这个项目的主要缓存集中在图片上, 这儿只做了图片的缓存显示和清理.
        // 显示图片缓存
        cache.calculateDiskCacheSizeWithCompletionHandler { (size) in
            // b 转换 为 Mb
            let mSize = Float(size) / 1024.0 / 1024.0
            // 取一位小数即可
            self.cacheLabel.text = String(format: "%.1fM", mSize)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
                case 0,1,2:
                    showErrorMessage("账号相关的需要登录.暂未做, 敬请期待")
                case 3:
                    jumpToProtocal("积分规则", url: "http://m.htxq.net/servlet/SysContentServlet?action=getDetail&id=309356e8-6bde-40f4-98aa-6d745e804b1f")
                case 4:
                    jumpToProtocal("认证规则", url: "http://m.htxq.net/servlet/SysContentServlet?action=getDetail&id=48d4eac5-18e6-4d48-8695-1a42993e082e")
                default: break
            }
        }else if(indexPath.section == 1){
            switch indexPath.row {
                case 0:
                    jumpToProtocal("关于我们", url: "http://m.htxq.net/servlet/SysContentServlet?action=getDetail&id=0001c687-9393-4ad3-a6ad-5b81391c5253")
                case 1:
                    jumpToProtocal("商业合作", url: "http://m.htxq.net/servlet/SysContentServlet?action=getDetail&id=e30840e6-ef01-4e97-b612-8b930bdfd8bd")
                case 2:
                    ALinLog("意见反馈")
                case 3:
                    toAppStore()
                default: break
            }

        }else{
            if indexPath.row == 0 { // 清除缓存
                cache.clearDiskCache() // 清除缓存
                showHudInView(view, hint: "正在清除缓存...", yOffset: 0)
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
                    self.hideHud()
                    self.showHint("清理完成", duration: 2.0, yOffset: 0.0)
                    self.cacheLabel.text = "0M"
                })
            }
        }
    }
    
    // MARK: - private method
    // 去AppStore给我们评分
    private func toAppStore()
    {
        UIApplication.sharedApplication().openURL(NSURL(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=998252000")!)
    }

    
    // 跳转到协议界面
    private func jumpToProtocal(title: String, url: String)
    {
        let protocolVc = ProtocolViewController()
        protocolVc.navigationItem.title = title
        protocolVc.HTM5Url = url
        let nav = NavgationViewController(rootViewController: protocolVc)
        presentViewController(nav, animated: true, completion: nil)
    }
    
    // 退出登录
    @IBAction func logout() {
        // 花田小憩官方版的做法, 是调用一个接口, 告诉后台, 该号码已经退出了. 也可以把cookie清除.
        // 退出的接口: (POST)
        // http://m.htxq.net/servlet/UserCustomerServlet
        // 参数
        // action=logout&token=&userId=
        
        // 0. 设置登录状态
        LoginHelper.sharedInstance.setLoginStatus(false)
        // 1. 返回到登录界面
        // 1.2 退出设置界面
        navigationController?.popToRootViewControllerAnimated(false)
        
        // 1.1 发送通知, 通知tab进行调整
        NSNotificationCenter.defaultCenter().postNotificationName(LoginoutNotify, object: nil)
        
        
    }

}
