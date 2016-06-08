//
//  AddressViewCell.swift
//  Floral
//
//  Created by 孙林 on 16/6/4.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

class AddressViewCell: NormalParentCell {

    var address : Address?{
        didSet{
            if let iAddress = address {
                addressLabel.text = iAddress.fnConsigneeArea! + iAddress.fnConsigneeAddress! + "大法师的法师打发的说法是打发发生地方"
                phoneLabel.text = "\(iAddress.fnMobile)"
                nameLabel.text = iAddress.fnUserName!
            }
        }
    }
    
    // 是否选中当前的地址
    var selectedAddress : Bool = false {
        didSet{
            checkBox.selected = selectedAddress
        }
    }
    
    
    override func setup()
    {
        super.setup()
        
        contentView.addSubview(undelLine)
        contentView.addSubview(checkBox)
        contentView.addSubview(addressLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(phoneLabel)
        
        nameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(DefaultMargin20)
            make.top.equalTo(DefaultMargin15)
        }
        
        checkBox.snp_makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-DefaultMargin15)
            make.size.equalTo(CGSize(width: 17, height: 17))
        }
        
        addressLabel.snp_makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp_bottom).offset(DefaultMargin10)
            make.left.equalTo(nameLabel)
            make.right.equalTo(checkBox.snp_left).offset(-DefaultMargin15)
        }
        
        phoneLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(nameLabel)
            make.right.equalTo(checkBox.snp_left).offset(-DefaultMargin10)
        }
        
        undelLine.snp_makeConstraints { (make) in
            make.bottom.equalTo(contentView)
            make.left.equalTo(nameLabel)
            make.right.equalTo(contentView)
            make.height.equalTo(1)
        }
    }
    
    
    // MARK: - 懒加载
    
    /// 收货地址
    private lazy var addressLabel : UILabel = {
        let label = UILabel()
        label.font = defaultFont14
        label.textColor = UIColor.blackColor()
        label.text = "请填写您的收货地址"
        label.numberOfLines = 0
        return label
    }()
    
    /// 收货人
    private lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = defaultFont14
        label.textColor = UIColor.blackColor()
        return label
    }()
    
    /// 电话
    private lazy var phoneLabel : UILabel = {
        let label = UILabel()
        label.font = defaultFont14
        label.textColor = UIColor.blackColor()
        return label
    }()
    
    /// underline
    private lazy var undelLine = UIImageView(image: UIImage(named: "underLine"))
    
    /// 选择按钮
    private lazy var checkBox : UIButton = {
        let btn = UIButton(title: nil, imageName: "f_adressUnSel_18x18", target: nil, selector: nil, font: nil, titleColor: nil)
        btn.setImage(UIImage(named:"f_adressSel_17x17"), forState: .Selected)
        return btn
    }()
}
