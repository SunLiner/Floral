//
//  OlderBottomView.swift
//  Floral
//
//  Created by 孙林 on 16/6/3.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

class OlderBottomView: UIView {
    /// 总价
    var totalPrice : String?
    {
        didSet{
            if let _ = totalPrice {
                totalPriceLabel.text = "合计: ¥" + totalPrice!
            }
        }
    }
    
    /// 点击购买的block
    var entryToBuy : ((totalPrice: String)->())?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var g_self : OlderBottomView?
    private func setup()
    {
        OlderBottomView.g_self = self
        
        addSubview(leftView)
        leftView.addSubview(totalPriceLabel)
        leftView.backgroundColor = UIColor.whiteColor()
        addSubview(entryBtn)
        
        entryBtn.snp_makeConstraints { (make) in
            make.top.bottom.right.equalTo(self)
            make.width.equalTo(100)
        }
        
        leftView.snp_makeConstraints { (make) in
            make.top.bottom.left.equalTo(self)
            make.right.equalTo(entryBtn.snp_left)
        }
        
        totalPriceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(leftView)
        }
    }
    
    // MARK: - 懒加载
     /// 总价
    private lazy var totalPriceLabel = UILabel(textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(15))
    
    // 左边的视图
    private lazy var leftView = UIView()
    
    /// 确认按钮
    private lazy var entryBtn : UIButton = {
       let btn = UIButton(title: "确认", imageName: nil, target: g_self, selector: #selector(OlderBottomView.clickEntry), font: UIFont.systemFontOfSize(15), titleColor: UIColor.whiteColor())
        btn.backgroundColor = UIColor.blackColor()
        return btn
    }()
    
    // MARK: - 点击事件
    func clickEntry()  {
        entryToBuy?(totalPrice: totalPrice!)
    }
}
