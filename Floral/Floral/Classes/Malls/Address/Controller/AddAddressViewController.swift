//
//  AddAddressViewController.swift
//  Floral
//
//  Created by 孙林 on 16/6/5.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

class AddAddressViewController: UIViewController {

    // 需要修改的地址
    var updateAddress : Address?
    {
        didSet{
            if let iupdate = updateAddress {
                userNameView.inputFiled.text = iupdate.fnUserName
                locationView.inputFiled.text = iupdate.fnConsigneeArea
                adddressView.inputFiled.text = iupdate.fnConsigneeAddress
                cellPhoneView.inputFiled.text = "\(iupdate.fnMobile)"
                postCodeView.inputFiled.text = "\(iupdate.fnPostCode)"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    private func setup()
    {
        view.backgroundColor = UIColor.init(gray: 241)
        navigationItem.title = "新增地址"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .Done, target: self, action: #selector(AddAddressViewController.save))
        
        view.addSubview(userNameView)
        view.addSubview(cellPhoneView)
        view.addSubview(postCodeView)
        view.addSubview(locationView)
        view.addSubview(adddressView)
        
        userNameView.snp_makeConstraints { (make) in
            make.right.left.equalTo(0)
            make.top.equalTo(64)
            make.height.equalTo(40)
        }
        
        cellPhoneView.snp_makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(userNameView.snp_bottom)
            make.height.equalTo(userNameView)
        }
        
        postCodeView.snp_makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(cellPhoneView.snp_bottom)
            make.height.equalTo(cellPhoneView)
        }
        
        locationView.snp_makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(postCodeView.snp_bottom)
            make.height.equalTo(postCodeView)
        }
        
        adddressView.snp_makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(locationView.snp_bottom)
            make.height.equalTo(locationView)
        }
    }
    
    // 点击保存
    func save() {
        // 判断是否为空
        if !checkNotNil() {
            return
        }
        
        // 判断手机号码格式
        if !cellPhoneView.inputFiled.text!.isPhoneNumber()
        {
            showErrorMessage("手机号码格式不对")
            return;
        }
        // 判断邮政编码格式
        if !postCodeView.inputFiled.text!.isPostCode() {
            showErrorMessage("邮政编码格式不对")
            return
        }
        
        view.endEditing(true)
        
        var parameters = [String : AnyObject]()
        parameters["fnConsigneeAddress"] = adddressView.inputFiled.text!
        parameters["fnPostCode"] = postCodeView.inputFiled.text!
        parameters["fnConsigneeArea"] = locationView.inputFiled.text!
        parameters["fnMobile"] = cellPhoneView.inputFiled.text!
        parameters["fnCustomerId"] = "041a470b-79ee-4c0b-b870-9356f15f6a8b"
        parameters["fnUserName"] = userNameView.inputFiled.text!
        parameters["fnId"] = ""
        // 修改的时候才需要传id
        if let iUpdate = updateAddress {
            parameters["fnId"] = iUpdate.fnId
        }
        NetworkTool.sharedTools.updateAddress(parameters) { (status) in
            if status{
                self.showHint("操作成功", duration: 2.0, yOffset: 0)
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
                    let addressList = self.navigationController!.childViewControllers[self.navigationController!.childViewControllers.count - 2] as! AddressListViewController
                    addressList.refresh = true
                    self.navigationController?.popToViewController(addressList, animated: false)
                })
                
            }else{
                self.showHint("操作失败", duration: 2.0, yOffset: 0)
            }
        }
    }
    
    private func checkNotNil() -> Bool
    {
        if userNameView.inputFiled.isNil() {
            showErrorMessage("收货人不能为空")
            return false
        }
        
        if cellPhoneView.inputFiled.isNil() {
            showErrorMessage("手机号码不能为空")
            return false
        }
        
        if postCodeView.inputFiled.isNil() {
            showErrorMessage("邮政编码不能为空")
            return false
        }
        
        if locationView.inputFiled.isNil() {
            showErrorMessage("所在地区不能为空")
            return false
        }
        
        if adddressView.inputFiled.isNil() {
            showErrorMessage("收货地址不能为空")
            return false
        }
        return true
    }
    
    // MARK: - 懒加载
    /// 收货人
    private lazy var userNameView: AddAddressInputView = AddAddressInputView(frame: CGRectZero, title: "收货人", isNum: false)
    
    /// 手机号码
    private lazy var cellPhoneView: AddAddressInputView = AddAddressInputView(frame: CGRectZero, title: "手机号码", isNum: true)
    
    /// 邮政编码
    private lazy var postCodeView: AddAddressInputView = AddAddressInputView(frame: CGRectZero, title: "邮政编码", isNum: true)
    
    /// 所在地区
    private lazy var locationView: AddAddressInputView = AddAddressInputView(frame: CGRectZero, title: "所在地区", isNum:  false)
    
    /// 详细地址
    private lazy var adddressView: AddAddressInputView = AddAddressInputView(frame: CGRectZero, title: "详细地址", isNum:  false)
}
