//
//  OlderParentCell.swift
//  Floral
//
//  Created by ALin on 16/6/2.
//  Copyright © 2016年 ALin. All rights reserved.
//  older的所有cell的父视图

import UIKit

class NormalParentCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup()
    {
        selectionStyle = .None
//        backgroundColor = UIColor(gray: 241)
//        contentView.backgroundColor = UIColor.whiteColor()
//        contentView.snp_makeConstraints { (make) in
//            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
//        }
    }

}
