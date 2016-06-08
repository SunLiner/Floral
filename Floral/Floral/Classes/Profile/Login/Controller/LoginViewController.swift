//
//  LoginViewController.swift
//  Floral
//
//  Created by 孙林 on 16/5/3.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, LoginHeaderViewDelegate {
    // 代理
    weak var delegate : LoginViewControllerDelegate?
    
    // 是否是注册按钮
    var isRegister : Bool = false
        {
        didSet{
            if isRegister {
                logoView.isRegister = isRegister
            }
        }
    }
    
    var isRevPwd : Bool = false
        {
        didSet{
            if isRevPwd {
                logoView.isRevPwd = isRevPwd
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private func setup()
    {
        // 添加点击去选择国家的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.toCountry), name: ToCountryNotifName, object: nil)
        // 点击视图, 就退下键盘
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing)))
        logoView.delegate = self
        
        // 添加子控件
        view.addSubview(bgImageView)
        view.addSubview(logoView)
        
        
        // 布局子控件
        bgImageView.snp_makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        logoView.snp_makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(64)
        }
        
        // 设置navigation
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .Done, target: self, action: #selector(LoginViewController.back))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "close"), style: .Done, target: self, action: #selector(LoginViewController.dismiss))
    }
    
    @objc private func toCountry()
    {
        let nav = NavgationViewController(rootViewController: CountryTableViewController())
        presentViewController(nav, animated: true, completion: nil)
    }
    
    // MARK: - 懒加载
    private lazy var bgImageView = UIImageView(image: UIImage(named: "loginBack"))
    
    private lazy var logoView : LoginHeaderView = LoginHeaderView()
    // MARK: - 内部控制方法
    func back()
    {
        if navigationController?.childViewControllers.count > 1 {
            navigationController?.popViewControllerAnimated(true)
        }else{
            dismiss()
        }
        
    }
    
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - LoginHeaderViewDelegate
    func loginHeaderView(loginHeaderView : LoginHeaderView, clickRevpwd pwdBtn: UIButton) {
        let login = LoginViewController()
        login.isRevPwd = true
        navigationController?.pushViewController(login, animated: true)
    }
    
    func loginHeaderView(loginHeaderView : LoginHeaderView, clickRegister registerbtn: UIButton) {
        let login = LoginViewController()
        login.isRegister = true
        navigationController?.pushViewController(login, animated: true)
    }
    
    func loginHeaderView(loginHeaderView : LoginHeaderView, clickProtocol protocelLabel: UILabel?) {
        let protocolVc = ProtocolViewController()
        protocolVc.navigationItem.title = "服务协议"
        protocolVc.HTM5Url = "http://m.htxq.net/servlet/SysContentServlet?action=getDetail&id=af50c0f4-d048-419b-a2de-47bb47fb99a5"
        let nav = NavgationViewController(rootViewController: protocolVc)
        presentViewController(nav, animated: true, completion: nil)
    }
    
    // 点击登录按钮
    func loginHeaderView(loginHeaderView: LoginHeaderView, clickDoneWithProfile profile: LoginProfile?) {
        if profile?.safeNum == nil { // 说明是登录
            LoginHelper.sharedInstance.setLoginStatus(true)
            self.showHint("登录成功", duration: 2.0, yOffset: 0)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
                self.delegate?.loginViewControllerDidSuccess!(self)
            })
        }else{
            if isRegister {
                 self.showHint("注册成功", duration: 2.0, yOffset: 0)
            }else{
                self.showHint("密码重置成功", duration: 2.0, yOffset: 0)
            }
        }
    }
    
}

@objc
protocol LoginViewControllerDelegate : NSObjectProtocol {
    // 登录成功的回调
    optional func loginViewControllerDidSuccess(loginViewController: LoginViewController)
}
