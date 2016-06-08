//
//  ShopCarBtn.swift
//  Floral
//
//  Created by ALin on 16/5/26.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

class ShopCarBtn: UIButton {
    // 购物车里面商品的数量
    var num : Int = 0{
        didSet{
            if num == 0 {
                numLabel.hidden = true
            }else{
                numLabel.hidden = false
                numLabel.text = "\(num)"
            }
        }
    }
    
    static let labelWidth : CGFloat = 12
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(numLabel)
        numLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self.snp_right).offset(-3)
            make.size.equalTo(CGSize(width: ShopCarBtn.labelWidth, height: ShopCarBtn.labelWidth))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var numLabel : UILabel = {
        let label =  UILabel(textColor: UIColor.whiteColor(), font: UIFont.systemFontOfSize(9))
        label.layer.cornerRadius = labelWidth * 0.5
        label.layer.masksToBounds = true
        label.backgroundColor = UIColor.redColor()
        label.textAlignment = .Center
        label.hidden = true
        return label
    }()

}
