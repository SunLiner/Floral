//
//  TopArticleOtherCell.swift
//  Floral
//
//  Created by 孙林 on 16/5/2.
//  Copyright © 2016年 ALin. All rights reserved.
//  专题, 4-10名的Cell

import UIKit

class TopArticleOtherCell: TopArticleCell {
    override func setupUI()
    {
        super.setupUI()
        contentView.addSubview(smallIconView)
        smallIconView.addSubview(coverView)
        contentView.addSubview(logoView)
        logoView.addSubview(sortLabel)
        contentView.addSubview(topLine)
        contentView.addSubview(underLine)
        contentView.addSubview(titleLabel)
        
        sortLabel.textColor = UIColor.blackColor()
        underLine.backgroundColor = UIColor.blackColor()
        topLine.backgroundColor = UIColor.blackColor()
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.font = UIFont.systemFontOfSize(12)
        
        smallIconView.snp_makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.left.equalTo(contentView).offset(10)
            make.height.equalTo(contentView)
            make.width.equalTo(contentView.snp_height)
        }
        
        coverView.snp_makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        
        // logo的x应该是除去缩略图之后, 剩下的一半的位置
        logoView.snp_makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 97, height: 58))
            make.top.equalTo(10)
            make.left.equalTo(smallIconView.snp_right).offset((ScreenWidth-120 - 97) * 0.5)
        }
        
        sortLabel.snp_makeConstraints { (make) in
            make.center.equalTo(logoView)
        }
        
        topLine.snp_makeConstraints { (make) in
            make.top.equalTo(logoView.snp_bottom).offset(10)
            make.left.equalTo(logoView)
            make.height.equalTo(1)
            make.width.equalTo(logoView.snp_width)
        }
        
        titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(topLine.snp_bottom).offset(5)
            make.left.width.equalTo(topLine)
        }
        
        underLine.snp_makeConstraints { (make) in
            make.left.equalTo(topLine)
            make.size.equalTo(topLine)
            make.top.equalTo(titleLabel.snp_bottom).offset(5)
        }
        
        
    }

    /// Logo
    private lazy var logoView : UIImageView = UIImageView(image: UIImage(named: "f_top"))
}
