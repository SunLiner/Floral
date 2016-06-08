//
//  TopArticleNormalCell.swift
//  Floral
//
//  Created by 孙林 on 16/5/2.
//  Copyright © 2016年 ALin. All rights reserved.
//  专题1-3名的cell

import UIKit

class TopArticleNormalCell: TopArticleCell {
    
    override func setupUI() {
        super.setupUI()
        
        contentView.addSubview(smallIconView)
        smallIconView.addSubview(coverView)
        contentView.addSubview(topLine)
        contentView.addSubview(underLine)
        contentView.addSubview(titleLabel)
        contentView.addSubview(sortLabel)
        contentView.addSubview(logLabel)
        
        smallIconView.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(contentView)
            make.left.equalTo(contentView).offset(10)
            make.right.equalTo(contentView).offset(-10)
        }
        
        coverView.snp_makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        titleLabel.snp_makeConstraints { (make) in
            make.center.equalTo(contentView)
        }
        
        underLine.snp_makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp_bottom).offset(15)
            make.centerX.equalTo(contentView)
            make.height.equalTo(1)
            make.width.equalTo(contentView.snp_height)
        }
        
        topLine.snp_makeConstraints { (make) in
            make.bottom.equalTo(titleLabel.snp_top).offset(-15)
            make.centerX.equalTo(contentView)
            make.size.equalTo(underLine.snp_size)
        }
        
        sortLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(topLine.snp_top).offset(-5)
            make.centerX.equalTo(contentView)
        }
        
        logLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(underLine.snp_bottom).offset(5)
        }

    }
}
