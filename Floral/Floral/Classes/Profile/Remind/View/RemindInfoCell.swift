//
//  RemindInfoCell.swift
//  Floral
//
//  Created by ALin on 16/6/6.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

class RemindInfoCell:  NormalParentCell{
    override func setup() {
        super.setup()
        
        contentView.addSubview(remindIcon)
        contentView.addSubview(timeLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contenLabel)
        contentView.addSubview(underline)
        
        remindIcon.snp_makeConstraints { (make) in
            make.left.equalTo(DefaultMargin20)
            make.top.equalTo(DefaultMargin15)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        titleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(remindIcon.snp_right).offset(DefaultMargin10)
            make.centerY.equalTo(remindIcon)
        }
        
        timeLabel.snp_makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-DefaultMargin20)
            make.centerY.equalTo(titleLabel)
        }
        
        contenLabel.snp_makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(remindIcon.snp_bottom).offset(15)
        }
        
        underline.snp_makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(1)
        }
        
        // 设置数据
        titleLabel.text = "花田小憩通知"
        timeLabel.text = "10天前"
        contenLabel.text = "您获得一个100积分的系统红包"
    }
   
    // MARK: - 懒加载
    /// 消息类型的icon
    private lazy var remindIcon = UIImageView(image: UIImage(named: "m_message_s_30x30"))
    /// 消息名称
    private lazy var titleLabel = UILabel(textColor: UIColor.blackColor(), font: defaultFont14)
    /// 时间
    private lazy var timeLabel = UILabel(textColor: UIColor.lightGrayColor(), font: DefaultFont12)
    /// 内容
    private lazy var contenLabel = UILabel(textColor: UIColor.lightGrayColor(), font: DefaultFont12)
    /// 分割线
    private lazy var underline = UIImageView(image: UIImage(named: "underLine"))
}
