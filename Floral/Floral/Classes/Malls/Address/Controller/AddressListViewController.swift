//
//  AddressListViewController.swift
//  Floral
//
//  Created by 孙林 on 16/6/4.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

// 地址改变通知
let AddressChangeNotify = "AddressChangeNotify"
// 地址改变通知useinfo的key
let AddressChangeNotifyKey = "address"

// 重用标识符
private let AddressCellReuseIdentifier = "AddressCellReuseIdentifier"

class AddressListViewController: UITableViewController, UIAlertViewDelegate {
    // 上一页已经选中了的地址ID
    var selectedID : String?
    
    var refresh : Bool = false
        {
        didSet{
            if refresh {
               getAddressList()
            }
        }
    }
    
    
    var addresses : [Address]?
    {
        didSet{
            if let _ = addresses {
                tableView.reloadData()
            }
        }
    }
    
    // 正在操作的地址
    private var selectedAddress : Address?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAddressList()
        setup()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        KeyWindow.addSubview(addAddressBtn)
        addAddressBtn.snp_makeConstraints { (make) in
            make.centerX.equalTo(KeyWindow)
            make.bottom.equalTo(-15)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        addAddressBtn.removeFromSuperview()
    }
    
    // 获取地址列表
    private func getAddressList() {
        showHudInView(view, hint: "正在加载...", yOffset: 0)
        NetworkTool.sharedTools.getAddressList { [unowned self](addresses, error) in
            self.hideHud()
            if error != nil{
                self.showHint("网络异常", duration: 2.0, yOffset: 0)
            }else{
                self.addresses = addresses
            }
        }
    }
    
    static var g_self : AddressListViewController?
    // 基本设置
    private func setup()
    {
        AddressListViewController.g_self = self
        
        navigationItem.title = "收货地址"
        tableView.registerClass(AddressViewCell.self, forCellReuseIdentifier: AddressCellReuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .None
        
        // 添加新增按钮
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return addresses?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return (addresses?.count ?? 0)>0 ? addresses![indexPath.row].cellHeight : 83
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(AddressCellReuseIdentifier) as! AddressViewCell
        let count = addresses?.count ?? 0
        if  count > 0{
            let address = addresses![indexPath.row]
            cell.selectedAddress = selectedID == address.fnId
            cell.address = address
            
        }
        return cell
    }
    
    // MARK: - Table view data delegate
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let count = addresses?.count ?? 0
        if indexPath.row == count - 1 { // 自提地址不能删除, 系统默认的地址
            return false
        }
        return true
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let address = self.addresses![indexPath.row]
        selectedAddress = address
        let delete = UITableViewRowAction(style: .Destructive, title: "删除") { (_, indexpath) in
            
            // 删除地址
            NetworkTool.sharedTools.deleteAddress(address.fnId!, finished: { (isDelete) in
                if isDelete{
                    self.showHint("删除成功", duration: 2.0, yOffset: 0)
                    // 重新请求地址列表
                    self.getAddressList()
                }else{
                    self.showHint("操作失败", duration: 2.0, yOffset: 0)
                }
            })
        }
        delete.backgroundColor = UIColor.redColor()
        
        let update = UITableViewRowAction(style: .Normal, title: "修改") { (_, indexpath) in
            self.toAddVc(true)
        }
        update.backgroundColor = UIColor.blueColor()
        
        let setDefault = UITableViewRowAction(style: .Default, title: "设置成默认") { (_, indexpath) in
            UIAlertView(title: "花田小憩", message: "是否设置成默认地址?", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "设置").show()
        }
        setDefault.backgroundColor = UIColor.greenColor()
        
        
        return [delete, update, setDefault]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSNotificationCenter.defaultCenter().postNotificationName(AddressChangeNotify, object: nil, userInfo: [AddressChangeNotifyKey : addresses![indexPath.row]])
        navigationController?.popViewControllerAnimated(false)
    }
    
    // MARK: - UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            // 设置成默认的地址
            NetworkTool.sharedTools.setDefaultAddress(selectedAddress!.fnId!, finished: { (isOk) in
                isOk ? self.showHint("操作成功", duration: 2.0, yOffset: 0) : self.showHint("操作失败", duration: 2.0, yOffset: 0)
                
                // 左滑动自动消失
                self.tableView.reloadData()
           })
        }
        
        
    }
    
    // MARK: - 懒加载
    /// 新增地址按钮
    private lazy var addAddressBtn = UIButton(title: nil, imageName: "f_addAdress_278x35", target: g_self!, selector: #selector(AddressListViewController.clickAdd), font: nil, titleColor: nil)
    
    /// 点击新增按钮
    @objc private func clickAdd()
    {
        toAddVc(false)
    }
    
    private func toAddVc(isUpdate: Bool)
    {
        let addVc = AddAddressViewController()
        if isUpdate {
            addVc.updateAddress = selectedAddress!
        }
        navigationController?.pushViewController(addVc, animated: true)
    }
}
