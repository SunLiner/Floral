//
//  RemindNormalCell.swift
//  Floral
//
//  Created by ALin on 16/6/6.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

class RemindNormalCell: NormalParentCell {
    var title : String?{
        didSet{
            if let iTitle = title {
                nameLabel.text = iTitle
            }
        }
    }
    
    var index : Int = 0{
        didSet{
            if index == 2 {
                underLine.snp_updateConstraints(closure: { (make) in
                    make.left.equalTo(contentView)
                })
            }
        }
    }
    
    
    override func setup() {
        super.setup()
        // 右箭头
        accessoryType = .DisclosureIndicator
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(underLine)
        
        nameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(contentView)
        }
        
        underLine.snp_makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.right.equalTo(self)
            make.height.equalTo(1)
            make.bottom.equalTo(self)
        }
    }
    
    private lazy var nameLabel = UILabel(textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(14))
    private lazy var underLine = UIImageView(image:UIImage(named: "underLine"))
}
