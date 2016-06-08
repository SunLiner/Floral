//
//  DetailViewController.swift
//  Floral
//
//  Created by ALin on 16/4/27.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit
import Kingfisher

// 屏幕的宽度
let ScreenWidth  = UIScreen.mainScreen().bounds.width
// 屏幕的高度
let ScreenHeight = UIScreen.mainScreen().bounds.height

// 头部Cell的高度
private let DetailHeadCellHeight   : CGFloat = 240
// HeaderView的高度
private let DetailHeaderViewHeight : CGFloat = 40
// 底部工具栏的高度
private let DetailFooterViewHeight : CGFloat = 40

class DetailViewController: UITableViewController, ToolBottomViewDelegate {
    var article : Article?

    // 浏览器的高
    var WebCellHeight : CGFloat?
    {
        didSet{
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .None)
        }
    }
    // MARK: - 声明周期方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseSetup()
        
        // 获取数据
        getDetail()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        addToolBar()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        toolBar.removeFromSuperview()
        blur.removeFromSuperview()
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - 数据获取
    private func getDetail()
    {
    NetworkTool.sharedTools.getArticleDetail(["articleId":article!.id!]) { [unowned self] (article, error) in
            self.article = article
            self.tableView.reloadData()
        }
    }
    
    // MARK: - 基本设置相关
    // 头部的重用标识符
    private let DetailHeadCellReuseIdentifier = "DetailHeadCellReuseIdentifier"
    // webView的重用标识符
    private let DetailWebCellReuseIdentifier = "DetailWebCellReuseIdentifier"
    // 基本设置
    private func baseSetup()
    {
        // 设置navigationItem
        navigationItem.title = article?.title ?? "详情"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ad_share"), style: .Done, target: self, action: #selector(DetailViewController.shareThread))
        
        // 注册cell
        tableView.registerClass(DetailHeadCell.self, forCellReuseIdentifier: DetailHeadCellReuseIdentifier)
        tableView.registerClass(DetailWebViewCell.self, forCellReuseIdentifier: DetailWebCellReuseIdentifier)
        tableView.separatorStyle = .None
        
        // 监听webview的高的改变的通知
        NSNotificationCenter.defaultCenter().addObserverForName(DetailWebViewCellHeightChangeNoti, object: nil, queue: NSOperationQueue.mainQueue()) {[weak self] (noti) in
            if let instance = self // 这儿需要防止循环引用
            {
                instance.WebCellHeight = CGFloat(noti.userInfo![DetailWebViewCellHeightKey] as! Float)
            }
            
        }
    }
    
    
    // MARK: - table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 返回2个cell一个是头, 一个是webview
        return 2
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(DetailHeadCellReuseIdentifier) as! DetailHeadCell
            cell.article = article
            cell.selectionStyle = .None
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(DetailWebCellReuseIdentifier) as! DetailWebViewCell
        cell.article = article
        cell.selectionStyle = .None
        cell.parentViewController = self
        return cell
    }
    
    // MARK: - table view delegate
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return DetailHeaderViewHeight
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = DetailHeaderView(frame: CGRect(x: 0, y: 0, width: 0, height: DetailHeaderViewHeight))
        view.article = article
        return view
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return DetailHeadCellHeight
        }
        return  WebCellHeight ?? (ScreenHeight - DetailHeadCellHeight - DetailHeaderViewHeight - DetailFooterViewHeight)
    }
    
    private var isShowShared = false
    // MARK: - 内部控制方法
    // 分享
    func shareThread() {
        if !isShowShared {
            isShowShared = true
            KeyWindow.addSubview(blur)
            blur.snp_makeConstraints { (make) in
                make.top.equalTo(64)
                make.left.right.bottom.equalTo(KeyWindow)
            }
            blur.startAnim()
        }else{
            hideShareView()
        }
        
    }
    
    @objc private func hideShareView()
    {
        blur.endAnim()
        isShowShared = false
    }
    
    // 添加底部视图
    func addToolBar() {
        KeyWindow.addSubview(toolBar)
        toolBar.snp_makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(30)
        }
    }
    
    // MARK: - 懒加载
    /// 底部视图
    private lazy var toolBar : ToolBottomView = {
        let tool = ToolBottomView()
        tool.backgroundColor = UIColor.whiteColor()
        tool.layer.borderWidth = 0.5
        tool.layer.borderColor = UIColor.lightGrayColor().CGColor
        tool.delegate = self
        // 此时需要显示时间了
        self.article!.isNotHomeList = true
        tool.article = self.article
        return tool
    }()
    
    /// 分享视图
    private lazy var blur : ShareBlurView = {
        let blur = ShareBlurView(effect:  UIBlurEffect(style: .Dark))
        // 点击视图, 退出分享界面
        blur.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(DetailViewController.hideShareView)))
        blur.shareBlock = { type in
            ShareTool.sharedInstance.share(type, shareText: "\(self.article!.title!): \(self.article!.desc!)", shareImage: Kingfisher.ImageCache.defaultCache.retrieveImageInDiskCacheForKey(self.article!.smallIcon!), shareUrl: self.article!.sharePageUrl, handler: self, finished: {
                self.hideShareView()
            })
            
            // 下面这段代码是系统的分享
//            if !SLComposeViewController.isAvailableForServiceType(SLServiceTypeSinaWeibo) {
//                self.showErrorMessage("您未安装新浪微博...")
//                return
//            }
//            
//            let shareComposeVc = SLComposeViewController(forServiceType: SLServiceTypeSinaWeibo)
//            shareComposeVc.addImage(UIImage(named: "20160425175259881847"))
//            shareComposeVc.addURL(NSURL(string: "http://www.jianshu.com/users/9723687edfb5/latest_articles"))
//            shareComposeVc.setInitialText("花田小憩, 放飞您的思绪, 放松您的精神...")
//            self.presentViewController(shareComposeVc, animated: true, completion: nil)
//            shareComposeVc.completionHandler = { result in
//                if result == SLComposeViewControllerResult.Done {
//                    self.showErrorMessage("分享成功")
//                }else{
//                    self.showErrorMessage("您取消了分享")
//                }
//            }

        }
        return blur
    }()
    
    // MARK: - ToolBottomViewDelegate
    func toolBottomView(toolBottomView: ToolBottomView, type: ToolBarBtnType.RawValue) {
        if type == ToolBarBtnType.Comment.rawValue {
            let comment = CommentViewController()
            comment.bbsID = article?.id
            navigationController?.pushViewController(comment, animated: true)
        }
    }
    
}
