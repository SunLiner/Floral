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
    
    private func setup()
    {
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
       let btn = UIButton(title: "获取验证码", imageName: nil, target: nil, selector: nil, font: defaultFont14, titleColor: UIColor.lightGrayColor())
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
}
