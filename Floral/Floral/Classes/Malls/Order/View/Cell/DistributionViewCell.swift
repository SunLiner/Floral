//
//  DistributionViewCell.swift
//  Floral
//
//  Created by 孙林 on 16/6/2.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

class DistributionViewCell: NormalParentCell {

    override func setup() {
        super.setup()
        
        contentView.addSubview(anonymousCheckBox)
        contentView.addSubview(anonymousLabel)
        contentView.addSubview(invoiceLabel)
        contentView.addSubview(invoiceCheckBox)
        
        anonymousCheckBox.snp_makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(20)
        }
        
        anonymousLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(anonymousCheckBox)
            make.left.equalTo(anonymousCheckBox.snp_right).offset(20)
            make.right.equalTo(contentView).offset(-20)
        }
        
        invoiceCheckBox.snp_makeConstraints { (make) in
            make.left.equalTo(anonymousCheckBox)
            make.top.equalTo(anonymousCheckBox.snp_bottom).offset(20)
        }
        
        invoiceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(anonymousLabel)
            make.centerY.equalTo(invoiceCheckBox)
        }
    }
    
    
    ///  匿名选择框
    private lazy var anonymousCheckBox : UIButton = {
       let btn = UIButton(title: nil, imageName: "f_check_12x12", target: self, selector: #selector(DistributionViewCell.checkit(_:)), font: nil, titleColor: nil)
        btn.setImage(UIImage(named:"f_check_s_15x12"), forState: .Selected)
        return btn
    }()
    
    ///  匿名配送
    private lazy var anonymousLabel : UILabel = {
       let label = UILabel(textColor: UIColor.blackColor(), font: DefaultFont12)
        label.numberOfLines = 0
        label.text = "匿名配送(我们将为您的购买信息保密, 以花田小憩的名义将宝贝送出)"
        return label
    }()
    
    ///  发票
    private lazy var invoiceLabel : UILabel = {
        let label = UILabel(textColor: UIColor.blackColor(), font: DefaultFont12)
        label.text = "需要发票"
        return label
    }()
    
    /// 发票选择框
    private lazy var invoiceCheckBox : UIButton = {
        let btn = UIButton(title: nil, imageName: "f_check_12x12", target: self, selector: #selector(DistributionViewCell.checkit(_:)), font: nil, titleColor: nil)
        btn.setImage(UIImage(named:"f_check_s_15x12"), forState: .Selected)
        return btn
    }()
    
    // MARK: - 点击事件
    func checkit(btn : UIButton) {
        btn.selected = !btn.selected
    }
}
