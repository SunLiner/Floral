//
//  TotalInfoViewCell.swift
//  Floral
//
//  Created by 孙林 on 16/6/2.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

class TotalInfoViewCell: NormalParentCell {

    // 商品信息
    var goods : Goods?
    
    // 购买数量
    var num : Int = 1
        {
        didSet{
            if let tempGoods = goods {
                totalNumLabel.text = "共\(num)件产品"
                totalPriceLabel.text = "¥ \(tempGoods.fnMarketPrice * Float(num))"
                luggagePriceLabel.text = "¥ 0"
                priceLabel.text = "¥ \(tempGoods.fnMarketPrice * Float(num))"
            }
        }
    }
    
    
    
    override func setup() {
        super.setup()
        
        contentView.backgroundColor = UIColor.whiteColor()
        
        contentView.addSubview(totalLabel)
        contentView.addSubview(totalNumLabel)
        contentView.addSubview(luggageLabel)
        contentView.addSubview(luggagePriceLabel)
        contentView.addSubview(totalPriceLabel)
        contentView.addSubview(priceLabel)
        
        totalNumLabel.snp_makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(15)
        }
        
        totalPriceLabel.snp_makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-10)
            make.top.equalTo(totalNumLabel)
        }
        
        luggageLabel.snp_makeConstraints { (make) in
            make.left.equalTo(totalNumLabel)
            make.top.equalTo(totalNumLabel.snp_bottom).offset(15)
        }
        
        luggagePriceLabel.snp_makeConstraints { (make) in
            make.right.equalTo(totalPriceLabel)
            make.top.equalTo(luggageLabel)
        }
        
        totalLabel.snp_makeConstraints { (make) in
            make.left.equalTo(luggageLabel)
            make.top.equalTo(luggageLabel.snp_bottom).offset(15)
        }
        
        priceLabel.snp_makeConstraints { (make) in
            make.right.equalTo(luggagePriceLabel)
            make.top.equalTo(totalLabel)
        }
        
    }

    /// 总共多少件产品
    private lazy var totalNumLabel = UILabel(textColor: UIColor.darkGrayColor(), font: defaultFont14)
    /// 总价
    private lazy var totalPriceLabel = UILabel(textColor: UIColor.blackColor(), font: defaultFont14)
    /// 运费
    private lazy var luggageLabel : UILabel = {
       let luggage = UILabel(textColor: UIColor.darkGrayColor(), font: defaultFont14)
        luggage.text = "运费"
        return luggage
    }()
    /// 运费的总价
    private lazy var luggagePriceLabel = UILabel(textColor: UIColor.blackColor(), font: defaultFont14)
    /// 总计
    private lazy var totalLabel : UILabel = {
        let total = UILabel(textColor: UIColor.darkGrayColor(), font: defaultFont14)
        total.text = "总计"
        return total
    }()
    
    /// 总价
    private lazy var priceLabel = UILabel(textColor: UIColor.orangeColor(), font: defaultFont14)
}
