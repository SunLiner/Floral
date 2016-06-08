//
//  LoginHeaderView.swift
//  Floral
//
//  Created by 孙林 on 16/5/3.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

class LoginHeaderView: UIView {
    weak var delegate : LoginHeaderViewDelegate?
    // 是否是注册按钮
    var isRegister : Bool = false
    {
        didSet{
            if isRegister {
               hiddenControl()
                loginBtn.setTitle("注册", forState: .Normal)
            }
        }
    }
    
    var isRevPwd : Bool = false
        {
        didSet{
            if isRevPwd {
                hiddenControl()
                loginBtn.setTitle("完成", forState: .Normal)
            }
        }
    }
    
    private func hiddenControl()
    {
        thirdLoginView.hidden = true
        revPwdBtn.hidden = true
        registerBtn.hidden = true
        safeInput.hidden = false
        
        pwdInput.snp_updateConstraints { (make) in
            make.top.equalTo(phoneInput.snp_bottom).offset(65)
        }
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        safeInput.hidden = true
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI()
    {
        addSubview(logoView)
        addSubview(localInput)
        addSubview(phoneInput)
        addSubview(safeInput)
        addSubview(pwdInput)
        addSubview(registerBtn)
        addSubview(revPwdBtn)
        addSubview(revPwdBtnUnderLine)
        addSubview(loginBtn)
        addSubview(thirdLoginView)
        addSubview(serviceTermLabel)
        
        logoView.snp_makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 85, height: 85))
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }
        
        localInput.snp_makeConstraints { (make) in
            make.top.equalTo(logoView.snp_bottom).offset(25)
            make.size.equalTo(CGSize(width: 280, height: 35))
            make.centerX.equalTo(self)
        }
        
        phoneInput.snp_makeConstraints { (make) in
            make.size.equalTo(localInput)
            make.centerX.equalTo(self)
            make.top.equalTo(localInput.snp_bottom).offset(15)
        }
        
        safeInput.snp_makeConstraints { (make) in
            make.size.equalTo(phoneInput)
            make.centerX.equalTo(self)
            make.top.equalTo(phoneInput.snp_bottom).offset(15)
        }
        
        pwdInput.snp_makeConstraints { (make) in
            make.size.equalTo(phoneInput)
            make.centerX.equalTo(self)
            make.top.equalTo(phoneInput.snp_bottom).offset(15)
        }
        
        registerBtn.snp_makeConstraints { (make) in
            make.left.equalTo(pwdInput)
            make.top.equalTo(pwdInput.snp_bottom).offset(10)
        }
        
        revPwdBtn.snp_makeConstraints { (make) in
            make.right.equalTo(pwdInput)
            make.top.equalTo(registerBtn)
        }
        
        // 计算"忘记密码"的宽度
        let revPwdBtnWidth = (revPwdBtn.currentTitle! as NSString).boundingRectWithSize(CGSize(width: CGFloat.max, height: CGFloat.max), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: defaultFont14], context: nil).size.width
        revPwdBtnUnderLine.snp_makeConstraints { (make) in
            make.right.equalTo(revPwdBtn)
            make.size.equalTo(CGSize(width: revPwdBtnWidth, height: 1))
            make.top.equalTo(revPwdBtn.snp_bottom)
        }
        
        loginBtn.snp_makeConstraints { (make) in
            make.left.right.equalTo(pwdInput)
            make.height.equalTo(36)
            make.centerX.equalTo(self)
            make.top.equalTo(registerBtn.snp_bottom).offset(10)
        }
        
        thirdLoginView.snp_makeConstraints { (make) in
            make.right.left.equalTo(pwdInput)
            make.top.equalTo(loginBtn.snp_bottom).offset(10)
            make.height.equalTo(100)
        }
        
        serviceTermLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).offset(-20)
        }
    }
    
    // MARK: 
     /// Logo
    private lazy var logoView = UIImageView(image: UIImage(named: "LOGO_85x85_"))
    
     /// 国家地区
    private lazy var localInput : LoginInputView = LoginInputView(iconName: "local", placeHolder: "国家地区/Location", isLocation: true, isPhone: false, isSafe: false)
    
     /// 手机号
    private lazy var phoneInput : LoginInputView = LoginInputView(iconName: "phone", placeHolder: "手机号/Phone Number", isLocation: false, isPhone: true, isSafe: false)
    
     /// 密码
    private lazy var pwdInput : LoginInputView = LoginInputView(iconName: "pwd", placeHolder: "密码/Password", isLocation: false, isPhone: false, isSafe: false)
    
     /// 验证码
    private lazy var  safeInput : LoginInputView = LoginInputView(iconName: "safe", placeHolder: "验证码/Code", isLocation: false, isPhone: false, isSafe: true)
    
     /// 注册账号
    private lazy var registerBtn : UIButton = UIButton(title: "注册账号", imageName: nil, target: self, selector: #selector(LoginHeaderView.clickRegister(_:)), font: defaultFont14, titleColor: UIColor.blackColor())
    
    
     /// 忘记密码
    private lazy var revPwdBtn : UIButton = UIButton(title: "忘记密码?", imageName: nil, target: self, selector: #selector(LoginHeaderView.clickRePwd(_:)), font: defaultFont14, titleColor: UIColor.blackColor())

     /// 忘记密码下的线
    private lazy var revPwdBtnUnderLine = UIImageView(image: UIImage(named: "underLine"))
    
     /// 登陆按钮
    private lazy var loginBtn : UIButton = {
       let btn = UIButton(title: "登录", imageName: nil, target: self, selector: #selector(LoginHeaderView.clickDone(_:)), font: defaultFont14, titleColor: UIColor.blackColor())
        btn.setBackgroundImage(UIImage(named:"loginBtn"), forState: .Normal)
        return btn
    }()
    
     /// 第三方登陆视图
    private lazy var thirdLoginView : ThirdLoginView = ThirdLoginView()
    
     /// 服务条款
    private lazy var serviceTermLabel : UILabel = {
        let label = UILabel()
        // 设置字体和颜色
        label.font = UIFont.init(name: "CODE LIGHT", size: 11)
        label.textColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        
        // 设置下划线
        let originStr = "注册即表示我同意 花田小憩服务条款 内容"
        let attrstr = NSMutableAttributedString(string: originStr)
        let range = (originStr as NSString).rangeOfString("花田小憩服务条款")
        attrstr.addAttributes([NSUnderlineStyleAttributeName : NSNumber(integer: NSUnderlineStyle.StyleSingle.rawValue )], range: range)
        label.attributedText = attrstr
        label.userInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginHeaderView.clickProtocol(_:))))
        return label
    }()
    
    // MARK: - 内部控制方法
    // 点击注册按钮
    func clickRegister(btn : UIButton) {
        delegate?.loginHeaderView!(self, clickRegister: btn)
    }
    
    // 点击忘记密码按钮
    func clickRePwd(btn : UIButton) {
        delegate?.loginHeaderView!(self, clickRevpwd: btn)
    }
    
    // 点击忘记密码按钮
    func clickProtocol(tap : UITapGestureRecognizer) {
        delegate?.loginHeaderView!(self, clickProtocol: nil)
    }
    
    func ok() {
        
    }
    
    
    // 点击了登录/注册/完成按钮
    func clickDone(btn: UIButton) {
        let profile = LoginProfile()
        
        if phoneInput.textFiled.isNil() {
            self.showErrorMessage("手机号码不能为空")
            return
        }else{
            if !profile.isPhoneNumber(phoneInput.textFiled.text!) {
                self.showErrorMessage("手机号码格式不对")
                return
            }
        }
        
        if btn.currentTitle != "登录"{ // 非登录按钮, 需要判断验证码
            if safeInput.textFiled.isNil() {
                self.showErrorMessage("验证码不能为空")
                return
            }else{
                profile.safeNum = safeInput.textFiled.text!
            }
            
        }
        
        if pwdInput.textFiled.isNil() {
            self.showErrorMessage("密码不能为空")
            return
        }
        
        profile.phoneNumber = phoneInput.textFiled.text
        profile.password = pwdInput.textFiled.text
        delegate?.loginHeaderView!(self, clickDoneWithProfile: profile)
    }
}

@objc
protocol LoginHeaderViewDelegate : NSObjectProtocol {
    // 点击注册按钮
   optional func loginHeaderView(loginHeaderView : LoginHeaderView, clickRegister registerbtn: UIButton)
    // 点击忘记密码按钮
    optional func loginHeaderView(loginHeaderView : LoginHeaderView, clickRevpwd pwdBtn: UIButton)
    // 点击协议
    optional func loginHeaderView(loginHeaderView : LoginHeaderView, clickProtocol protocelLabel: UILabel?)
    // 点击登录按钮
    optional func loginHeaderView(loginHeaderView : LoginHeaderView, clickDoneWithProfile profile: LoginProfile?)
}
