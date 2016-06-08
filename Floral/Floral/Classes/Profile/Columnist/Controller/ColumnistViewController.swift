//
//  ColumnistViewController.swift
//  Floral
//
//  Created by 孙林 on 16/5/19.
//  Copyright © 2016年 ALin. All rights reserved.
//  专栏/用户的控制器

import UIKit

let ArticlesreuseIdentifier = "ArticlesCollectionViewCell"
// 专栏头部的重用标识符
//private let headerReuseIdentifier = "headerReuseIdentifier"
// 用户头部的重用标识符
private let UserHeaderReuseIdentifier = "UserHeaderReuseIdentifier"
// 专栏简介的cell重用标识符
private let AuthorIntroReuseIdentifier = "AuthorIntroViewCell"
// 作者简介的cell重用标识符
private let UserCellReuseIdentifier = "UserCollectionCell"

class ColumnistViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var author : Author?
    
    // 是否是用户(用户和专栏是不一样的)
    var isUser : Bool = false
        {
        didSet{
            if isUser {
                collectionView?.registerClass(UserCollectionViewCell.self, forCellWithReuseIdentifier: UserCellReuseIdentifier)
//                collectionView?.registerNib(UINib.init(nibName: "UserHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: UserHeaderReuseIdentifier)
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "pc_setting_40x40"), style: .Plain, target: self, action: #selector(ColumnistViewController.gotoSetting))
            }
        }
    }
    
    var articles : [Article]?
    {
        didSet{
            if let _ = articles {
                collectionView!.reloadData()
            }
        }
    }
    
    init() {
        super.init(collectionViewLayout: CollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - view
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setup()
        getList()
    }
    
    deinit
    {
        ALinLog("deinit...")
    }
    
    // MARK: - private method
    
    // 数据获取
    private func getList()
    {
        NetworkTool.sharedTools.getUserDetail(author!.id!) { (author, error) in
            self.author = author
            self.collectionView?.reloadSections(NSIndexSet(index: 0))
        }
        
        NetworkTool.sharedTools.columnistDetails(["currentPageIndex":"0", "userId":author!.id!]) { (articles, error, isLoadAll) in
            if error == nil
            {
                if isLoadAll{
                    self.showHint("已经到最后了", duration: 2.0, yOffset: 0)
                }else{
                    self.articles = articles
                }
                
            }else{
                self.showHint("网络异常", duration: 2.0, yOffset: 0)
            }
        }

    }
    
    // 基本设置
    func setup()
    {
        collectionView?.backgroundColor = UIColor.init(gray: 241.0)
        navigationItem.title = "个人中心"
        
        collectionView!.registerClass(ArticlesCollectionViewCell.self, forCellWithReuseIdentifier: ArticlesreuseIdentifier)
        
        collectionView?.registerClass(AuthorIntroViewCell.self, forCellWithReuseIdentifier: AuthorIntroReuseIdentifier)
        
//        collectionView?.registerClass(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        collectionView?.registerNib(UINib.init(nibName: "UserHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: UserHeaderReuseIdentifier)
    }
    
    // 跳转到设置按钮
    func gotoSetting() {
        let setting = UIStoryboard.init(name: "SettingViewController", bundle: nil).instantiateInitialViewController()
        setting?.navigationItem.title = "设置"
        navigationController?.pushViewController(setting!, animated: true)
    }

    // MARK: - UICollectionView Datasource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return articles?.count ?? 0
        }
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if isUser {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(UserCellReuseIdentifier, forIndexPath: indexPath) as!  UserCollectionViewCell
                cell.author = author
                cell.clickShopCar = {
                    ALinLog("点击了购物车")
                }
                cell.clickRemind = {
                    self.navigationController?.pushViewController(RemindViewController(), animated: true)
                }
                cell.parentViewController = self
                return cell
            }else{
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(AuthorIntroReuseIdentifier, forIndexPath: indexPath) as!  AuthorIntroViewCell
                cell.author = author
                cell.parentViewController = self
                return cell
            }
        }
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ArticlesreuseIdentifier, forIndexPath: indexPath) as! ArticlesCollectionViewCell
        let count = articles?.count ?? 0
        if count > 0 {
            cell.article = articles![indexPath.item]
        }
        return cell
        
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView
    {
        var header : UICollectionReusableView?
        
//        if isUser {
            header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: UserHeaderReuseIdentifier, forIndexPath: indexPath)
//        }
//        else{ // 这儿应该分两种情况的, 有一个接口没有获取到, 后期补上
//            header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: headerReuseIdentifier, forIndexPath: indexPath)
//            header!.backgroundColor = (indexPath.section % 2 == 0) ? UIColor.purpleColor() : UIColor.orangeColor()
//        }
        return header!
    }
    
    // MARK: - UICollectionView Delegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            let detail = DetailViewController()
            detail.article = articles![indexPath.row]
            navigationController?.pushViewController(detail, animated: true)
        }
    }
    
    
    // MAKR: - UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        if indexPath.section == 0 {
            if isUser {
                return CGSizeMake(UIScreen.mainScreen().bounds.width
                    , 160);
            }else{
                return CGSizeMake(UIScreen.mainScreen().bounds.width
                    , 130);
            }
        }else{
            return CGSizeMake((UIScreen.mainScreen().bounds.width - 24)/2, 230);
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        if section == 0 {
            return CGSizeZero
        }
        return CGSize(width: UIScreen.mainScreen().bounds.width
            , height: 40)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        if section == 0 {
            return UIEdgeInsetsZero
        }
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
    
}

class CollectionViewFlowLayout: LevitateHeaderFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        
        collectionView?.alwaysBounceVertical = true
        scrollDirection = .Vertical
        minimumLineSpacing = 5
        minimumInteritemSpacing = 0
    }
}
