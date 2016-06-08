//
//  MallGoodsCell.swift
//  Floral
//
//  Created by 孙林 on 16/5/12.
//  Copyright © 2016年 ALin. All rights reserved.
//  商城的cell, 非精选

import UIKit

// 商品格的重用标示符
let GoodsCellIdentfy = "GoodsCellIdentfy"

class MallGoodsCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    // 代理
    weak var delegate : MallGoodsCellDelegate?
    
    var mallsGoods : MallsGoods?
    {
        didSet{
            if let _ = mallsGoods {
                var count = mallsGoods!.goodsList!.count
                // 最多只显示4个
                count = count < 4 ? count : 4
                let height = (CGFloat((count % 2 == 0) ? count / 2 : count / 2 + 1)) * (ScreenWidth / 2.0)
                // 更新高度
                goodListView.snp_updateConstraints(closure: { (make) in
                    make.height.equalTo(height)
                })
                topView.malls = mallsGoods
                goodListView.reloadData()
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup()
    {
        selectionStyle = .None
        
        addSubview(topView)
        addSubview(goodListView)
        
        topView.snp_makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(60)
        }
        
        goodListView.snp_makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(topView.snp_bottom).offset(10)
        }
    }
    
    // MARK: - 懒加载
    private lazy var topView : CategoryInfoView = {
       let infoView = CategoryInfoView()
        infoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MallGoodsCell.toLookAll)))
        return infoView
    }()
    private lazy var goodListView : UICollectionView  = {
       let list = UICollectionView(frame: CGRectZero, collectionViewLayout: MallFlowLayout())
        list.dataSource = self
        list.delegate = self
        list.alwaysBounceHorizontal = false
        list.alwaysBounceVertical = false
        list.registerClass(GoodsCollectionViewCell.self, forCellWithReuseIdentifier: GoodsCellIdentfy)
        return list
    }()
    
    // MARK: - UICollectionViewDataSource
   
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        let count = mallsGoods?.goodsList?.count ?? 0
        return count > 4 ? 4 : count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(GoodsCellIdentfy, forIndexPath: indexPath) as! GoodsCollectionViewCell
        if let _ = mallsGoods?.goodsList {
            cell.goods = mallsGoods?.goodsList![indexPath.row]
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        delegate?.mallGoodsCellDidSelectedGoods!(self, goods: mallsGoods!.goodsList![indexPath.item])
    }
    
    // MARK: - 点击事件
    func toLookAll() {
        delegate?.mallGoodsCellDidSelectedCategory!(self, malls: mallsGoods!.goodsList!)
    }
}


@objc
protocol MallGoodsCellDelegate : NSObjectProtocol {
    // 选中了类型, 去查看所有的类型
    optional func mallGoodsCellDidSelectedCategory(mallGoodsCell: MallGoodsCell, malls:[Goods])
    // 点击单独一个, 去查看详情
    optional func mallGoodsCellDidSelectedGoods(mallGoodsCell: MallGoodsCell, goods:Goods)
}
