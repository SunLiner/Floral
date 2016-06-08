//
//  MallsTableViewController.swift
//  Floral
//
//  Created by ALin on 16/4/25.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

// 精选cell的重用标示符
private let JingCellReuseIdentifier = "JingCellReuseIdentifier"

// 商城cell的重用标示符
private let MallsCellReuseIdentifier = "MallsCellReuseIdentifier"

// 头部cell的重用标示符
private let MallsHeaderCellIdentifier = "MallsHeaderCellIdentifier"

class MallsTableViewController: UITableViewController, BlurViewDelegate, TopMenuViewDelegate, SearchBarDelegate, MallGoodsCellDelegate{
    // 商城分类
    var categories: [MallsCategory]?
    
    // 当前页码
    var currentPage : Int = 0
    // 商品数组(非精选项)
    var malls : [MallsGoods]?
    {
        didSet{
            if let _ = malls {
                ALinLog(malls?.count)
                tableView.reloadData()
            }
        }
    }
    
    // 置顶的商品
    var topAD : ADS?
    {
        didSet{
            if let _ = topAD {
                tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.None)
            }
        }
    }
    
    /// 精选商品列表
    var goodses : [Goods]?
    {
        didSet{
            if let _ = goodses {
                tableView.reloadData()
            }
        }
    }
    
    var identify : MallIdentity = MallIdentity.MallJingxuan
    
    // 选中的分类
    var selectedCategry : MallsCategory?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    // MARK: - 基本设置
    private func setup()
    {
        // 设置下拉刷新控件
        refreshControl = RefreshControl(frame: CGRectZero)
        refreshControl?.addTarget(self, action: #selector(HomeTableViewController.getList), forControlEvents: .ValueChanged)
        refreshControl?.beginRefreshing()
        
        // 设置左右item
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuBtn)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "f_search"), style: .Done, target: self, action: #selector(MallsTableViewController.search))
        navigationItem.title = "商城"
        
        // 注册cell
        tableView.registerClass(JingGoodsCell.self, forCellReuseIdentifier: JingCellReuseIdentifier)
        tableView.registerClass(MallsHeaderCell.self, forCellReuseIdentifier: MallsHeaderCellIdentifier)
        tableView.registerClass(MallGoodsCell.self, forCellReuseIdentifier: MallsCellReuseIdentifier)
        
        // 设置tableview相关
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .None
        
        getWebData()
    }
    
    // MARK: - 数据获取
    private func getWebData()
    {
        getList()
        getMallsCategory()
        gettopAD()
    }

    func getList()
    {
        // 如果是刷新的话.重置currentPage
        if refreshControl!.refreshing {
            reSet()
        }
        
        NetworkTool.sharedTools.getMalls(identify, parameters: nil) { (objs, error) in
            if self.refreshControl!.refreshing // 如果是正在刷新, 取消刷新
            {
                self.refreshControl?.endRefreshing()
            }
            if error == nil{
                if self.identify == MallIdentity.MallJingxuan
                {
                    self.goodses = objs as? [Goods]
                }else{
                    self.malls = objs as? [MallsGoods]
                }
                
            }else{
                self.showHint("网络异常", duration: 2.0, yOffset: 0)
            }
        }
    }

    private func getMallsCategory()
    {
        // 1. 先取本地的
        categories = MallsCategory.loadLocalCategories()
        ALinLog(categories)
        // 2. 然后获取网络的, 然后保存到本地
        NetworkTool.sharedTools.getMallsCategories { (categories, error) in
            self.categories = categories
        }
    }
    
    private func gettopAD()
    {
        NetworkTool.sharedTools.getTopMalls { (goods, error) in
            if error != nil
            {
                self .showHint("网络异常", duration: 2.0, yOffset: 0)
            }else{
                self.topAD = goods
            }
            
        }
    }
    
    // MARK: - 内部控制方法
    // 重置数据
    private func reSet()
    {
        // 重置当前页
        currentPage = 0
        if identify == MallIdentity.MallJingxuan {
            goodses?.removeAll()
            goodses = [Goods]()
        }else{
            // 重置数组
            malls?.removeAll()
            malls = [MallsGoods]()
        }
        
    }
    
    // 搜索
    func search()
    {
        KeyWindow.addSubview(searchBar)
        
        view.addSubview(searchBlur)
        searchBlur.frame.origin.y = tableView.contentOffset.y
        tableView.scrollEnabled = false
        
        searchBar.snp_makeConstraints { (make) in
            make.top.equalTo(-44)
            make.left.width.equalTo(KeyWindow)
            make.height.equalTo(44)
        }
        
        UIView.animateWithDuration(0.25) { 
            self.searchBar.transform = CGAffineTransformMakeTranslation(0, 64)
        }
        
        
    }
    
    // 跳转到详情页
    private func gotoDetail(goodId: String, fnName: String)
    {
        let goodsDetail = GoodsDetailController()
        goodsDetail.navigationItem.title = fnName
        goodsDetail.goodsId = goodId
        navigationController?.pushViewController(goodsDetail, animated: true)
    }

    // MARK: - Table view data source and delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        // 根据选择的不同类型, 来返回个数
        return identify == MallIdentity.MallJingxuan ? goodses?.count ?? 0 :  malls?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 264
        }
        var height : CGFloat = 0.0
        let count = malls?.count ?? 0
        if count > 0 && identify == MallIdentity.MallTheme{
            let mallsGoods = malls![indexPath.row]
            var goodscount = mallsGoods.goodsList!.count
            // 最多只显示4个
            goodscount = goodscount < 4 ? goodscount : 4
            height += CGFloat((goodscount % 2 == 0) ? goodscount / 2 : goodscount / 2 + 1) * (ScreenWidth / 2.0)
            height += 70 // 加上头部60+10的间距
        }
        
        return identify == MallIdentity.MallJingxuan ? 280 : height
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 { // 顶部的广告
            let cell = tableView.dequeueReusableCellWithIdentifier(MallsHeaderCellIdentifier) as! MallsHeaderCell
            cell.parentVc = self
            cell.imageUrl = topAD?.fnImageUrl
            return cell
        }
        
        // 非精选, 商城的cell
        if identify == MallIdentity.MallTheme {
            let cell = tableView.dequeueReusableCellWithIdentifier(MallsCellReuseIdentifier) as! MallGoodsCell
            let count = malls?.count
            if count > 0 {
                cell.mallsGoods = malls![indexPath.row]
                cell.delegate = self
            }
            return cell
        }
        
        // 精选的cell
        let cell = tableView.dequeueReusableCellWithIdentifier(JingCellReuseIdentifier) as! JingGoodsCell
        let count = goodses?.count ?? 0
        if count > 0 {
            cell.commodity = goodses![indexPath.row]
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {// 点击的是顶部的广告
            gotoDetail(topAD!.fnUrl!, fnName: topAD!.fnTitle!)
        }else if identify == MallIdentity.MallJingxuan {
            gotoDetail(goodses![indexPath.row].fnId!, fnName: goodses![indexPath.row].fnName!)
        }
    }
    
    // MARK: - 懒加载
    private lazy var menuBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "menu"), forState: .Normal)
        btn.frame.size = CGSize(width: 20, height: 20)
        btn.addTarget(self, action: #selector(MallsTableViewController.selectedCategory(_:)), forControlEvents: .TouchUpInside)
        return btn
    }()
    
    // 蒙版
    private lazy var blurView : BlurView = {
        let blur = BlurView(effect: UIBlurEffect(style: .Light))
        blur.categories = self.categories
        blur.delegate = self
        blur.isMalls = true
        return blur
    }()
    
    // 搜索框
    private lazy var searchBar :SearchBar = {
        let search = SearchBar()
        search.delegate = self
        return search
    }()
    // 搜索时候的蒙版
    private lazy var searchBlur : UIView = {
        let blur : UIView = UIView(frame: self.view.bounds)
        blur.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
        return blur
    }()
    
    // MARK: - 私有方法
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
    // MARK: - BlurViewDelegate
    func blurView(blurView: BlurView, didSelectCategory category: AnyObject) {
        // 去掉高斯蒙版
        selectedCategory(menuBtn)
        // 设置选中的类型
        selectedCategry = category as? MallsCategory
        NetworkTool.sharedTools.selectedCategory(selectedCategry!.fnId!) { (goodsList, error) in
            if error != nil
            {
                self.showHint("网络异常", duration: 2.0, yOffset: 0)
            }else{
                let goodlistVc = GoodListViewController()
                goodlistVc.goodList = goodsList
                goodlistVc.navigationItem.title = self.selectedCategry!.fnName
                self.navigationController?.pushViewController(goodlistVc, animated: true)
            }
        }
    }

    // MARK: - TopMenuViewDelegate
    func topMenuView(topMenuView: TopMenuView, selectedTopAction action: TOP10Action.RawValue) {
        if action == TOP10Action.TopContents.rawValue {
            identify = MallIdentity.MallJingxuan
        }else{
            identify = MallIdentity.MallTheme
        }
        // 清空数组
        reSet()
        getList()
    }
    
    // MARK: - SearchBarDelegate
    func searchBarDidCancel(searchBar: SearchBar) {
        hideSearBar()
    }
    
    func searchBar(searchBar: SearchBar, search: String) {
        NetworkTool.sharedTools.search(search) { (goodlist, error) in
            if error != nil
            {
                self.showErrorMessage("服务器异常")
            }else{
                let count = goodlist?.count ?? 0
                if count > 0{
                    self.hideSearBar()
                    let goodlistVc = GoodListViewController()
                    goodlistVc.goodList = goodlist
                    goodlistVc.navigationItem.title = "搜索结果"
                    self.navigationController?.pushViewController(goodlistVc, animated: true)
                }else{
                    self.showErrorMessage("没有相关数据")
                }
            }
        }
    }
    
    // 隐藏searchBar
    private func hideSearBar()
    {
        UIView.animateWithDuration(0.25, animations: {
            self.searchBar.transform = CGAffineTransformIdentity
            self.searchBar.endEditing(true)
        }) { (_) in
            self.tableView.scrollEnabled = true
            self.searchBar.clearText()
            self.searchBar.removeFromSuperview()
            self.searchBlur.removeFromSuperview()
        }
    }
    
    // MARK: - MallGoodsCellDelegate
    func mallGoodsCellDidSelectedGoods(mallGoodsCell: MallGoodsCell, goods: Goods) {
        gotoDetail(goods.fnId!, fnName: goods.fnName!)
    }
    
    func mallGoodsCellDidSelectedCategory(mallGoodsCell: MallGoodsCell, malls: [Goods]) {
        let goodlistVc = GoodListViewController()
        goodlistVc.goodList = malls
        goodlistVc.navigationItem.title = mallGoodsCell.mallsGoods?.fnName
        navigationController?.pushViewController(goodlistVc, animated: true)
    }
}
