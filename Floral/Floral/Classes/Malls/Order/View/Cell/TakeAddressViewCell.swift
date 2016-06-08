//
//  TakeAddressViewCell.swift
//  Floral
//
//  Created by ALin on 16/6/2.
//  Copyright © 2016年 ALin. All rights reserved.
//  收货地址

import UIKit

class TakeAddressViewCell: NormalParentCell {
    var address : Address?{
        didSet{
            if let iAddress = address {
                addressLabel.text = "收货地址: " + iAddress.fnConsigneeArea! + iAddress.fnConsigneeAddress!
                phoneLabel.text = "\(iAddress.fnMobile)"
                nameLabel.text = "收货人: " + iAddress.fnUserName!
            }
        }
    }
    
    override func setup()
    {
        super.setup()
        accessoryType = .DisclosureIndicator
        contentView.addSubview(localView)
        contentView.addSubview(addressLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(phoneLabel)
        
        localView.snp_makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(15)
            make.size.equalTo(CGSize(width: 16, height: 20))
        }
        
        addressLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(localView)
            make.left.equalTo(localView.snp_right).offset(15)
            make.right.equalTo(contentView).offset(-15)
        }
        
        nameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(addressLabel)
            make.top.equalTo(localView.snp_bottom).offset(15)
        }
        
        phoneLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(nameLabel)
            make.right.equalTo(contentView).offset(-15)
        }
    }
    
    
    // MARK: - 懒加载
    /// 地址图标
    private lazy var localView : UIImageView = UIImageView(image: UIImage(named: "local"))
    
    /// 收货地址
    private lazy var addressLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "CODE LIGHT", size: 12)
        label.textColor = UIColor.blackColor()
        label.text = "请填写您的收货地址"
        label.numberOfLines = 0
        return label
    }()
    
    /// 收货人
    private lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "CODE LIGHT", size: 12)
        label.textColor = UIColor.blackColor()
        return label
    }()
    
    /// 电话
    private lazy var phoneLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.blackColor()
        return label
    }()

}
