//
//  RemindViewController.swift
//  Floral
//
//  Created by ALin on 16/6/6.
//  Copyright © 2016年 ALin. All rights reserved.
//  消息提醒

import UIKit

private let NormalReuseIdentifier = "NormalReuseIdentifier"
private let InfoReuseIdentifier = "InfoReuseIdentifier"
class RemindViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    private func setup()
    {
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .None
        tableView.registerClass(RemindNormalCell.self, forCellReuseIdentifier: NormalReuseIdentifier)
        tableView.registerClass(RemindInfoCell.self, forCellReuseIdentifier: InfoReuseIdentifier)
        navigationItem.title = "消息"
    }
    
    deinit{
        ALinLog("")
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // 实际开发中, 后面的1需要根据系统返回的消息提醒来确定消息的数目. 
        return titles.count + 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row > titles.count - 1 {
            return 100
        }
        return 40
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row > titles.count - 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(InfoReuseIdentifier) as! RemindInfoCell
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(NormalReuseIdentifier) as! RemindNormalCell
        cell.title = titles[indexPath.row]
        cell.index = indexPath.row
        return cell
    }
    
    // MARK: - Table view data delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row > titles.count - 1 {
            KeyWindow.addSubview(notifyView)
            notifyView.snp_makeConstraints(closure: { (make) in
                make.edges.equalTo(0)
            })
        }else{
            UIAlertView(title: "花田小憩", message: "由于此项功能需要认证后的专栏作家才有相关的数据, 所以后期会尽量补上", delegate: nil, cancelButtonTitle:  "好的").show()
        }
    }
    
    private lazy var titles = ["收到的评论", "收到的赞", "新的订阅"]
    /// 消息视图
    private lazy var notifyView : RemindNotifyView = RemindNotifyView()

}
