//
//  UIViewController+Extension.swift
//  Floral
//
//  Created by ALin on 16/4/27.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

// keyWindow
let KeyWindow : UIWindow = UIApplication.sharedApplication().keyWindow!

private var HUDKey = "HUDKey"
extension UIViewController
{
    var hud : MBProgressHUD?
        {
        get{
           return objc_getAssociatedObject(self, &HUDKey) as? MBProgressHUD
        }
        set{
            objc_setAssociatedObject(self, &HUDKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var good : Int?
    {
        get{
           return 200
        }
        set{
//            _good = 300
            ALinLog(good)
        }
    }
    
    /**
     显示提示信息(有菊花, 一直显示, 不消失)
     
     - parameter view:    显示在哪个View上
     - parameter hint:    提示信息
     - parameter yOffset: y上的偏移量
     */
    func showHudInView(view: UIView, hint: String, yOffset:CGFloat?){
        let HUD = MBProgressHUD(view: view)
        HUD.label.text = hint
        HUD.margin = 10.0
        HUD.offset.y = yOffset ?? 0
        view.addSubview(HUD)
        HUD.showAnimated(true)
        good = 100
        hud = HUD
    }
    
    /**
     显示纯文字提示信息(显示在keywindow上)
     
     - parameter hint: 提示信息
     - parameter duration: 持续时间(不填的话, 默认两秒)
     - parameter yOffset: y上的偏移量
     */
    func showHint(hint: String, duration: Double?, yOffset:CGFloat?) {
        let view = KeyWindow
        let HUD = MBProgressHUD(view: view)
        view.addSubview(HUD)
        HUD.userInteractionEnabled = false
        HUD.mode = .Text
        HUD.label.text = hint
        HUD.offset.y = yOffset ?? 0
        HUD.showAnimated(true)
        HUD.removeFromSuperViewOnHide = false
        HUD.hideAnimated(true, afterDelay: duration ?? 2)
        hud = HUD
    }
    
    
    /**
     显示纯文字提示信息
     
     - parameter hint: 显示在哪个View上
     - parameter hint: 提示信息
     - parameter duration: 持续时间(不填的话, 默认两秒)
     - parameter yOffset: y上的偏移量
     */
    func showHint(view: UIView, hint: String, duration: Double?, yOffset:CGFloat?) {
        let HUD = MBProgressHUD(view: view)
        view.addSubview(HUD)
        HUD.userInteractionEnabled = false
        HUD.mode = .Text
        HUD.label.text = hint
        HUD.offset.y = yOffset ?? 0
        HUD.removeFromSuperViewOnHide = false
        HUD.showAnimated(true)
        HUD.hideAnimated(true, afterDelay: duration ?? 2)
        hud = HUD
    }

    
    func hideHud() {
        hud!.hideAnimated(true)
    }

    
}