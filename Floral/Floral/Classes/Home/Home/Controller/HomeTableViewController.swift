//
//  HomeTableViewController.swift
//  Floral
//
//  Created by ALin on 16/4/25.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit
import Alamofire

private let HomeArticleReuseIdentifier = "HomeArticleReuseIdentifier"
class HomeTableViewController: UITableViewController, BlurViewDelegate {
    // MARK: - 参数/变量
    // 文章数组
    var articles : [Article]?
    // 当前页
    var currentPage : Int = 0
    // 所有的主题分类
    var categories : [Category]?
    // 选中的分类
    var selectedCategry : Category?
    
    
    // MARK: - 生命周期方法
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        
    }

    // MARK: - 基本设置
    // 设置导航栏和tableview相关
    private func setup()
    {
        // 设置左右item
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuBtn)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "TOP", style: .Plain, target: self, action: #selector(HomeTableViewController.toTop))
        
        // 设置titleView
        navigationItem.titleView = titleBtn
        
        // 设置tableview相关
        tableView.registerClass(HomeArticleCell.self, forCellReuseIdentifier: HomeArticleReuseIdentifier)
        tableView.rowHeight = 330;
        tableView.separatorStyle = .None
        tableView.tableFooterView = UIView()
        
        // 设置下拉刷新控件
        refreshControl = RefreshControl(frame: CGRectZero)
        refreshControl?.addTarget(self, action: #selector(HomeTableViewController.getList), forControlEvents: .ValueChanged)
        refreshControl?.beginRefreshing()
        getList()
        getCategories()
    }
    
    /*******  START *********/
    // OC中的方法都是运行时加载, 是属于动态的, 用的时候才加载
    // SWift中的方法都是编译时加载, 属于静态的. 
    // 如果使用addTarget, 且是private修饰的, 就需要告诉编辑器, 我这个方法是objc的, 属于动态加载
    @objc private func toTop()
    {
       navigationController?.pushViewController(TopViewController(), animated: true)
    }
    
    @objc private func selectedCategory(btn: UIButton)
    {
        btn.selected = !btn.selected
        // 如果是需要显示菜单, 先设置transform, 然后再动画取消, 就有一上一下的动画
        if btn.selected {
            // 添加高斯视图
            tableView.addSubview(blurView)
            // 添加约束
            blurView.snp_makeConstraints(closure: { (make) in
                make.left.equalTo(tableView)
                // 这儿的约束必须是设置tableView.contentOffset.y, 而不是设置为和tableView的top相等或者0
                // 因为添加到tableview上面的控件, 一滚动就没了...
                // 为什么+64呢? 因为默认的tableView.contentOffset是(0, -64)
                make.top.equalTo(tableView.contentOffset.y+64)
                make.size.equalTo(CGSize(width: ScreenWidth, height: ScreenHeight-49-64))
            })
            // 设置transform
            blurView.transform = CGAffineTransformMakeTranslation(0, -ScreenHeight)
        }
        
        UIView.animateWithDuration(0.5, animations: { 
            if btn.selected { // 循转
                btn.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
                self.blurView.transform = CGAffineTransformIdentity
                self.tableView.bringSubviewToFront(self.blurView)
                self.tableView.scrollEnabled = false
            }else{ // 回去
                btn.transform = CGAffineTransformIdentity
                self.blurView.transform = CGAffineTransformMakeTranslation(0, -ScreenHeight)
                self.tableView.scrollEnabled = true
            }
            }) { (_) in
                if !btn.selected{ // 如果是向上走, 回去, 需要removeFromSuperview
                    self.blurView.removeFromSuperview()
                }
        }
        
    }
    
    // MARK: 数据获取
    
    /**
     #1.获得专题的类型:(POST或者GET都行)
     http://m.htxq.net/servlet/SysCategoryServlet?action=getList
     */
    func getList()
    {
        // 如果是刷新的话.重置currentPage
        if refreshControl!.refreshing {
            reSet()
        }
        
        // 参数设置
        var paramters = [String : AnyObject]()
        paramters["currentPageIndex"] = "\(currentPage)"
        paramters["pageSize"] = "5"
        // 如果选择了分类就设置分类的请求ID
        if let categry = selectedCategry {
            paramters["cateId"] = categry.id
        }
        NetworkTool.sharedTools.getHomeList(paramters) { (articles, error, loadAll) in
            // 停止加载数据
            if self.refreshControl!.refreshing{
                self.refreshControl!.endRefreshing()
            }
            
            if loadAll{
               self.showHint("已经到最后了", duration: 2, yOffset: 0)
                self.currentPage -= 1
                return
            }
            
            // 显示数据
            if error == nil
            {
                if var _ = self.articles{
                    self.toLoadMore = false
                    self.articles! += articles!
                }else{
                    self.articles = articles!
                }
                self.tableView.reloadData()
            }else{
                // 获取数据失败后
                self.currentPage -= 1
                if self.toLoadMore{
                    self.toLoadMore = false
                }
                self.showHint("网络异常", duration: 2, yOffset: 0)
            }
        }
    }
    
    
    private func getCategories()
    {
        // 1. 获取本地保存的
        if let array = Category.loadLocalCategories()
        {
            self.categories = array
        }
        // 2. 获取网络数据
        NetworkTool.sharedTools.getCategories { (categories, error) in
            if error == nil{
                self.categories = categories
                // 3. 保存在本地(已在方法中实现了)
            }else{
                ALinLog(error?.domain)
            }
        }
    }
    
    /*******  END *********/

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return articles?.count ?? 0
    }
    
    // 是否加载更多
    private var toLoadMore = false
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(HomeArticleReuseIdentifier) as! HomeArticleCell
        cell.selectionStyle = .None
        let count = articles?.count ?? 0
        if count > 0 {
            let article = articles![indexPath.row]
            cell.article = article
            cell.clickHeadImage = {[weak self] article in
                let columnist = ColumnistViewController()
                columnist.author = article?.author
                self!.navigationController?.pushViewController(columnist, animated: true)
            }
        }
        
        // 为了增强用户体验, 我们可以学习新浪微博的做法, 当用户滚动到最后一个Cell的时候,自动加载下一页数据
        // 每次要用户手动的去加载更多, 就仿佛在告诉用户, 你在我这个APP已经玩了很久了, 该休息了...源源不断的刷新, 就会让用户一直停留在APP上
        if count > 0 && indexPath.row == count-1 && !toLoadMore{
            toLoadMore = true
            // 这儿写自增, 竟然有警告, swift语言更新确实有点快, 我记得1.2的时候还是可以的
            currentPage += 1
            getList()
        }
        return cell
    }
    
    // MARK: - Table view data delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let article = articles![indexPath.row]
        let detail = DetailViewController()
        detail.article = article
        self.navigationController!.pushViewController(detail, animated: true)
        
    }
    
    
    // MARK: - 懒加载
    private lazy var menuBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "menu"), forState: .Normal)
        btn.frame.size = CGSize(width: 20, height: 20)
        btn.addTarget(self, action: #selector(HomeTableViewController.selectedCategory(_:)), forControlEvents: .TouchUpInside)
        return btn
    }()
    
    private lazy var blurView : BlurView = {
        let blur = BlurView(effect: UIBlurEffect(style: .Light))
//        blur.alpha = 0.90
        blur.categories = self.categories
        blur.delegate = self
        return blur
    }()
    
    private lazy var titleBtn : TitleBtn = TitleBtn()

    
    // MARK: -BlurViewDelegate
    func blurView(blurView: BlurView, didSelectCategory category: AnyObject) {
        // 去掉高斯蒙版
        selectedCategory(menuBtn)
        // 设置选中的类型
        selectedCategry = category as? Category
        // 开始动画
        refreshControl!.beginRefreshing()
        // 请求数据
        getList()
    }
    
    // MARK: - 内部控制方法
    /**
     重置数据
     */
    private func reSet()
    {
        // 重置当前页
        currentPage = 0
        // 重置数组
        articles?.removeAll()
        articles = [Article]()
    }
}
