//
//  OlderViewCell.swift
//  Floral
//
//  Created by ALin on 16/6/2.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

class OlderViewCell: NormalParentCell {

    var goods : Goods?
    { 
        didSet{
            if let tempG = goods {
                // 设置数据
                attachment.kf_setImageWithURL(NSURL(string: tempG.fnAttachment!)!, placeholderImage: UIImage(named: "placehodler"), optionsInfo: [], progressBlock: nil, completionHandler: nil)
                priveLabel.text = "¥ \(tempG.fnMarketPrice)"
                titleLabel.text = tempG.fnName
            }
        }
    }
    
    override func setup()
    {
        super.setup();
        
        contentView.addSubview(attachment)
        contentView.addSubview(titleLabel)
        contentView.addSubview(tipLabel)
        contentView.addSubview(priveLabel)
        
        attachment.snp_makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(10)
            make.size.equalTo(CGSize(width: 70, height: 70))
        }
        
        titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(attachment).offset(5)
            make.left.equalTo(attachment.snp_right).offset(10)
        }
        
        tipLabel.snp_makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp_bottom).offset(10)
        }
        
        priveLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(attachment)
            make.left.equalTo(tipLabel)
        }
    }
    
    
    // MARK: - 懒加载
    /// 缩略图
    private lazy var attachment : UIImageView = UIImageView()
    
    /// 标题
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "CODE LIGHT", size: 12)
        label.textColor = UIColor.blackColor()
        return label
    }()
    
    /// tip
    private lazy var tipLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "CODE LIGHT", size: 11)
        label.text = "花田小憩默认72小时内为您送货"
        label.textColor = UIColor.lightGrayColor()
        return label
    }()
    
    /// 价格
    private lazy var priveLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.brownColor()
        return label
    }()
 
}
