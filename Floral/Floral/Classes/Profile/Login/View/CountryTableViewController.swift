//
//  CountryTableViewController.swift
//  Floral
//
//  Created by 孙林 on 16/5/4.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

let ChangeCountyNotifyName = "ChangeCountyNotifyName"

// 重用标识符
private let CountryCellIdentifier = "CountryCellIdentifier"

class CountryTableViewController: UITableViewController {
    // 国家名数组
    var countries : [[String]]?
    {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    // 索引keys
    var keys : [NSString]?
    {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        getList()
    }
    
    private func setup()
    {
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: CountryCellIdentifier)
        navigationItem.title = "选择国家和地区"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .Done, target: self, action: #selector(CountryTableViewController.back))
    }
    
    func back() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    private  func getList() {
        // 获取plist的路径
        let path = NSBundle.mainBundle().pathForResource("country.plist", ofType: nil)
        // 获得
        let dic = NSDictionary.init(contentsOfFile: path!)
        // 索引排序
        keys = dic!.allKeys.sort({ (obj1, obj2) -> Bool in
            return (obj1 as! String) < (obj2 as! String)
        }) as? [NSString]
        
        // 获取国家名
        var values = [[String]]()
        if let rkeys = keys {
            for key in rkeys {
                if let value = dic![key] {
                    values.append(value as! [String])
                }
            }
            countries = values
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return keys?.count ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = countries?.count ?? 0
        if count == 0 {
            return 0
        }
        let array  = countries![section]
        return array.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CountryCellIdentifier)!
        let count = countries?.count ?? 0
        if count > 1 {
            let countryCount = countries![indexPath.section].count ?? 0
            if countryCount > 1 {
                cell.textLabel?.text = countries![indexPath.section][indexPath.row]
            }
        }
        return cell
        
    }
    
    // 设置左边的索引
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let count = keys?.count ?? 0
        return count > 0 ? keys![section] as String : nil
    }
    
    // 设置每组的title
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return keys as? [String]
    }
    
    // MARK: - Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let country = countries![indexPath.section][indexPath.row]
        NSNotificationCenter.defaultCenter().postNotificationName(ChangeCountyNotifyName, object: nil, userInfo: ["country" : country])
        back()
    }

}
