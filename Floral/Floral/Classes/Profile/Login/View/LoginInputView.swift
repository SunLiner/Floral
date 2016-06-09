//
//  LoginInputView.swift
//  Floral
//
//  Created by 孙林 on 16/5/3.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

let ToCountryNotifName = "ToCountryNotifName"


// 默认的字体大小14
let defaultFont14 = UIFont.systemFontOfSize(13)

class LoginInputView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    convenience init(iconName: String, placeHolder: String, isLocation: Bool, isPhone: Bool, isSafe: Bool)
    {
        self.init(frame: CGRectZero)
        iconView.image = UIImage(named: iconName)
        textFiled.placeholder = placeHolder
        if isLocation {
            locationBtn.hidden = false
            textFiled.userInteractionEnabled = false
        }else{
            locationBtn.hidden = true
            textFiled.userInteractionEnabled = true
        }
        
        if isPhone {
            textFiled.keyboardType = .NumberPad
        }else{
            textFiled.keyboardType = .Default
        }
        
        if isSafe {
            safeBtn.hidden = false
        }else{
            safeBtn.hidden = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var g_self : LoginInputView?
    private func setup()
    {
        LoginInputView.g_self = self
        // 监听国家的改变
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginInputView.changeCounty(_:)), name: ChangeCountyNotifyName, object: nil)
        
        // 添加子控件
        addSubview(undLine)
        addSubview(iconView)
        addSubview(textFiled)
        addSubview(locationBtn)
        addSubview(safeBtn)
        
        // 布局子控件
        undLine.snp_makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self).offset(-1)
        }
        
        iconView.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.size.equalTo(CGSize(width: 19, height: 20))
            make.centerY.equalTo(self)
        }
        
        textFiled.snp_makeConstraints { (make) in
            make.left.equalTo(iconView.snp_right).offset(10)
            make.width.equalTo(self)
            make.centerY.equalTo(self)
        }
        
        locationBtn.snp_makeConstraints { (make) in
            make.right.equalTo(self).offset(-10)
            make.centerY.equalTo(self)
        }
        
        safeBtn.snp_makeConstraints { (make) in
            make.right.equalTo(self)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: 80, height: 25))
        }
    }
    
    // MARK: - 懒加载
        /// 底部的分割线
    private lazy var undLine : UIImageView = UIImageView(image: UIImage(named: "underLine"))
    
        /// 图标
    private lazy var iconView: UIImageView = UIImageView(image: UIImage(named: "safe"))
        /// 输入框
    lazy var textFiled : UITextField = {
       let textFiled = UITextField()
        textFiled.placeholder = "国家地区/Location"
        textFiled.font = defaultFont14
        // 设置placeholder的颜色(一定要在placeholder设置后才会生效)
        textFiled.setValue(UIColor.blackColor(), forKeyPath: "_placeholderLabel.textColor")
        // 设置placeholder的字体
        textFiled.setValue(defaultFont14, forKeyPath: "_placeholderLabel.font")
        return textFiled
    }()
    
        /// 国家地区按钮
    private lazy var locationBtn : TitleBtn = {
       let btn = TitleBtn()
        btn.setTitle("中国/+86", forState: .Normal)
        btn.titleLabel?.font = defaultFont14
        btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        btn.setImage(UIImage(named:"goto"), forState: .Normal)
        btn.addTarget(self, action: #selector(LoginInputView.toLocation), forControlEvents: .TouchUpInside)
        return btn
    }()
    
    private lazy var safeBtn : UIButton = {
       let btn = UIButton(title: "获取验证码", imageName: nil, target: g_self!, selector: #selector(LoginInputView.clickSafeNum(_:)), font: defaultFont14, titleColor: UIColor.blackColor())
        btn.setTitleColor(UIColor.lightGrayColor(), forState:.Selected)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.lightGrayColor().CGColor
        return btn
    }()
    
    // MARK: - 内部控制方法
    func toLocation() {
        NSNotificationCenter.defaultCenter().postNotificationName(ToCountryNotifName, object: nil)
    }
    
    func changeCounty(noti: NSNotification) {
        let county = noti.userInfo!["country"] as! String
        locationBtn.setTitle(county, forState: .Normal)
    }
    
    /// 点击"发送验证码"按钮
    func clickSafeNum(btn: UIButton) {
        var seconds = 10 //倒计时时间
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        let timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(timer,dispatch_walltime(nil, 0),1 * NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(timer) { 
            if(seconds<=0){ //倒计时结束，关闭
                dispatch_source_cancel(timer);
                dispatch_async(dispatch_get_main_queue(), {
                    //设置界面的按钮显示 根据自己需求设置
                    btn.setTitleColor(UIColor.blackColor(), forState:.Normal)
                    btn.setTitle("获取验证码", forState:.Normal)
                    btn.titleLabel?.font = defaultFont14
                    btn.userInteractionEnabled = true
                    });
            }else{
                
                dispatch_async(dispatch_get_main_queue(), {
                    UIView.beginAnimations(nil, context: nil)
                    UIView.setAnimationDuration(1)
                })
                dispatch_async(dispatch_get_main_queue(), {
                    //设置界面的按钮显示 根据自己需求设置
                    UIView.beginAnimations(nil, context: nil)
                    UIView.setAnimationDuration(1)
                    btn.setTitleColor(UIColor.orangeColor(), forState:.Normal)
                    btn.setTitle("\(seconds)秒后重新发送", forState:.Normal)
                    btn.titleLabel?.font = UIFont.systemFontOfSize(11)
                    UIView.commitAnimations()
                    btn.userInteractionEnabled = false
                
                })
               seconds -= 1

        }
            
    }
    dispatch_resume(timer)
}
}
