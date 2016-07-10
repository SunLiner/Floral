//
//  OrderViewController.swift
//  Floral
//
//  Created by ALin on 16/6/2.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

// 最顶部的订单详情重用标识符
private let OrderCellReuseIdentifier = "OrderCellReuseIdentifier"
// 收货地址重用标识符
private let AddressCellReuseIdentifier = "AddressCellReuseIdentifier"
// 留言信息重用标识符
private let MessageCellReuseIdentifier = "MessageCellReuseIdentifier"
// 配送信息重用标识符
private let DistributionCellReuseIdentifier = "DistributionCellReuseIdentifier"
// 总价信息重用标识符
private let InfoCellReuseIdentifier = "InfoCellReuseIdentifier"

class OrderViewController: UITableViewController {
    // 订单id, 暨商品的第
    var olderID : String?
    
    var goods : Goods?
    {
        didSet{
            if let _ = goods {
                tableView.reloadData()
                bottomView.totalPrice = "\(goods!.fnMarketPrice)"
            }
        }
    }
    
    // 购买数量, 默认为1
    var buyNum : Int = 1
        {
        didSet{
            tableView.reloadSections(NSIndexSet(index: 4), withRowAnimation: .None)
            bottomView.totalPrice = "\(goods!.fnMarketPrice * Float(buyNum))"
        }
    }
    
    // MARK: - life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        getOlderInfo()
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        bottomView.removeFromSuperview()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        KeyWindow.addSubview(bottomView)
        bottomView.snp_makeConstraints { (make) in
            make.bottom.left.right.equalTo(KeyWindow)
            make.height.equalTo(44)
        }
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
        ALinLog("deinit........")
    }
    
    // MARK: - 内部控制方法
    /// 获取数据
    private func getOlderInfo()
    {
        NetworkTool.sharedTools.getOlder(olderID!) { (goods, error) in
            self.goods = goods
        }
    }
    
    /// 基本设置
    private func setup()
    {
        navigationItem.title = "确认订单"
        
        view.backgroundColor = UIColor(gray: 241)
        //tableView.tableFooterView = UIView() 设置tableFooterView后会出发reloadData, 这时候registerClass还没执行，在cellForRowAtIndexPath中导致Crash
        tableView.separatorStyle = .None
        tableView.registerClass(OlderViewCell.self, forCellReuseIdentifier: OrderCellReuseIdentifier)
        tableView.registerClass(TakeAddressViewCell.self, forCellReuseIdentifier: AddressCellReuseIdentifier)
        tableView.registerClass(OlderMessageViewCell.self, forCellReuseIdentifier: MessageCellReuseIdentifier)
        tableView.registerClass(DistributionViewCell.self, forCellReuseIdentifier: DistributionCellReuseIdentifier)
        tableView.registerClass(TotalInfoViewCell.self, forCellReuseIdentifier: InfoCellReuseIdentifier)
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
        tableView.tableFooterView = UIView()
        // 添加通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(OrderViewController.buyNumChange(_:)), name: BuyNumNotifyName, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(OrderViewController.addressChange(_:)), name: AddressChangeNotify, object: nil)
    }
    
    @objc private func buyNumChange(notify: NSNotification)
    {
        buyNum = notify.userInfo![BuyNumKey]!.integerValue
    }
    
    @objc private func addressChange(notify: NSNotification)
    {
        guard let _ = notify.userInfo else{
            return
        }
        
        let good = notify.userInfo![AddressChangeNotifyKey] as! Address
        
        goods?.uAddress = good
        
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 1)], withRowAnimation: .Automatic)
    }


    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0, 3:
            return 90
        case 1:
            return goods?.uAddress != nil ? 75 : 45
        case 2:
            return 150
        case 4:
            return 100
        default:
            return 40
        }
    }
   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell?
        
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCellWithIdentifier(OrderCellReuseIdentifier, forIndexPath: indexPath)
            (cell as! OlderViewCell).goods = goods
        case 1:
            cell = tableView.dequeueReusableCellWithIdentifier(AddressCellReuseIdentifier, forIndexPath: indexPath)
            (cell as! TakeAddressViewCell).address = goods?.uAddress
        case 2:
            cell = tableView.dequeueReusableCellWithIdentifier(MessageCellReuseIdentifier, forIndexPath: indexPath) as! OlderMessageViewCell
        case 3:
            cell = tableView.dequeueReusableCellWithIdentifier(DistributionCellReuseIdentifier, forIndexPath: indexPath) as! DistributionViewCell
        case 4:
            cell = tableView.dequeueReusableCellWithIdentifier(InfoCellReuseIdentifier, forIndexPath: indexPath)
            (cell as! TotalInfoViewCell).goods = goods
            (cell as! TotalInfoViewCell).num = buyNum
        default:
            break
        }
        
        return cell!
    }
 
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 { // 选中收货地址
            let address = AddressListViewController()
            address.selectedID = goods?.uAddress?.fnId
            navigationController?.pushViewController(address, animated: true)
        }
    }

    // MARK: - 懒加载
    // 底部视图
    private lazy var bottomView : OlderBottomView = {
        let bottom = OlderBottomView()
        bottom.entryToBuy = {[unowned self] totalPrice in
            if self.goods?.uAddress == nil{
                self.showErrorMessage("请选择收货地址")
            }else{
                ALinLog("购买吧, 合计\(totalPrice)")
                KeyWindow.addSubview(self.payView)
                self.payView.totalPrice = totalPrice
                self.payView.frame = KeyWindow.bounds
                self.payView.startAnim()
            }
        }
        return bottom
    }()
    
    private lazy var payView : PayView = PayView()
}
