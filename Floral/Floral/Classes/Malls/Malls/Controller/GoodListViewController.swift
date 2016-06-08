//
//  GoodListViewController.swift
//  Floral
//
//  Created by 孙林 on 16/5/15.
//  Copyright © 2016年 ALin. All rights reserved.
//  商城模块, 所有的商品列表

import UIKit


class GoodListViewController: UICollectionViewController {
    var goodList : [Goods]?
    {
        didSet{
            if let _ = goodList {
                collectionView?.reloadData()
            }
        }
    }
    
    init() {
        super.init(collectionViewLayout: MallFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView!.registerClass(GoodsCollectionViewCell.self, forCellWithReuseIdentifier: GoodsCellIdentfy)
        collectionView?.alwaysBounceVertical = true
    }


    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goodList?.count ?? 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(GoodsCellIdentfy, forIndexPath: indexPath) as! GoodsCollectionViewCell
        if let _ = goodList {
            cell.goods = goodList![indexPath.item]
        }
        return cell
    }
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let goodsDetail = GoodsDetailController()
        goodsDetail.navigationItem.title = goodList![indexPath.item].fnName
        goodsDetail.goodsId = goodList![indexPath.item].fnId
        navigationController?.pushViewController(goodsDetail, animated: true)
    }
}
