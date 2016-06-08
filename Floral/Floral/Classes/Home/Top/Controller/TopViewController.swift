//
//  TopViewController.swift
//  Floral
//
//  Created by 孙林 on 16/5/1.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

private let TopAuthorCellReuseIdentifier = "TopAuthorCellReuseIdentifier"

class TopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TopMenuViewDelegate{
    
    // MARK: - 成员变量
        /// 数据源数组
    var datasource : [AnyObject]?
    {
        didSet{
            tableView.reloadData()
        }
    }
        /// 获取数据的操作, 默认是获取专栏
    var action : TOP10Action = TOP10Action.TopContents
    
    
    // MARK: - 生命周期方法
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        // 默认请求专栏
        getList()
    }
    
    // MARK: - 获取数据
    private func getList()
    {
        NetworkTool.sharedTools.getTop10(action) { (objs, error) in
            
            self.datasource = objs
        }
    }
    
    // MARK: - UI布局 和 相关的设置
    private func setup()
    {
        // 设置导航栏
        navigationItem.title = "本周排行TOP10"
        
        // 添加子控件
        view.addSubview(topMenuView)
        view.addSubview(tableView)
        
        // 布局
        view.backgroundColor = UIColor.whiteColor()
        topMenuView.snp_makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(view).offset(64)
            make.height.equalTo(40)
        }

        tableView.snp_makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(topMenuView.snp_bottom)
        }
        
        topMenuView.delegate = self
    }
    
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let count = datasource?.count ?? 0
        // 根据不同的top类型, 显示不同的cell
        // 当前选择的类型是"作者"
        if action.rawValue == TOP10Action.TopArticleAuthor.rawValue {
            let cell = tableView.dequeueReusableCellWithIdentifier(TopAuthorCellReuseIdentifier) as! TopAuthorCell
            if count > 0 {
                cell.author = datasource![indexPath.row] as? Author
                cell.sort = indexPath.row + 1
            }
            cell.selectionStyle = .None
            return cell
            
        }
        
        
        // 当前选择的类型是"专题"
        // 专题又分为两种cell. 
        // 前三名的cell
        let cell = tableView.dequeueReusableCellWithIdentifier((indexPath.row < 3) ? TopArticleCellReuseIdentifier.normal.rawValue : TopArticleCellReuseIdentifier.other.rawValue) as! TopArticleCell
        if  count > 1 {
            cell.article = datasource![indexPath.row] as? Article
            cell.sort = indexPath.row + 1
        }
        cell.selectionStyle = .None
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if action.rawValue == TOP10Action.TopArticleAuthor.rawValue {
            return 60
        }
        return 120
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 跳转到作者界面
        if action.rawValue == TOP10Action.TopArticleAuthor.rawValue {
            let columnis = ColumnistViewController()
            columnis.author = datasource![indexPath.row] as? Author
            navigationController?.pushViewController(columnis, animated: true)
            return;
        }
        
        // 跳转到主题界面
        let article = datasource![indexPath.row] as? Article
        let detail = DetailViewController()
        detail.article = article
        navigationController!.pushViewController(detail, animated: true)
    }
    
    
    // MARK: - TopMenuViewDelegate
    func topMenuView(topMenuView: TopMenuView, selectedTopAction action: TOP10Action.RawValue) {
        self.action = action == TOP10Action.TopArticleAuthor.rawValue ? TOP10Action.TopArticleAuthor :  TOP10Action.TopContents
        getList()
    }

    
    // MARK : 懒加载
        /// 顶部的菜单
    private lazy var topMenuView : TopMenuView = TopMenuView()
        /// tableview
    private lazy var tableView : UITableView = {
        let tab = UITableView()
        tab.dataSource = self
        tab.delegate = self
        tab.tableFooterView = UIView()
        tab.registerClass(TopArticleNormalCell.self, forCellReuseIdentifier: TopArticleCellReuseIdentifier.normal.rawValue)
        tab.registerClass(TopAuthorCell.self, forCellReuseIdentifier: TopAuthorCellReuseIdentifier)
        tab.registerClass(TopArticleOtherCell.self, forCellReuseIdentifier: TopArticleCellReuseIdentifier.other.rawValue)
        return tab
    }()
}

