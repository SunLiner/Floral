//
//  JingGoodsCell.swift
//  Floral
//
//  Created by ALin on 16/5/12.
//  Copyright © 2016年 ALin. All rights reserved.
//  精选的cell

import UIKit

class JingGoodsCell: UITableViewCell {

    // 商品
    var commodity : Goods?
    {
        didSet{
            if let com = commodity {
                // 设置数据
                attachment.kf_setImageWithURL(NSURL(string: com.fnAttachment!)!, placeholderImage: UIImage(named: "placehodler"), optionsInfo: [], progressBlock: nil, completionHandler: nil)
                categoryLabel.text = com.fnEnName
                priveLabel.text = "\(com.fnMarketPrice)"
                titleLabel.text = com.fnName
                typeBtn.setBackgroundImage(com.fnjianIcon, forState: .Normal)
                typeBtn.setTitle(com.fnjianTitle, forState: .Normal)
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup()
    {
        // 基本设置
        selectionStyle = .None
        // 设置背景颜色
        backgroundColor = UIColor(gray: 241)
        contentView.backgroundColor = UIColor.whiteColor()
        
        // 添加子控件
        contentView.addSubview(attachment)
        contentView.addSubview(typeBtn)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priveLabel)
        
        // 布局
        // 设置间距
        contentView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(10, 10, 0, -10))
        }
        
        attachment.snp_makeConstraints { (make) in
            make.left.right.top.equalTo(self.contentView)
            make.height.equalTo(190)
        }
        
        typeBtn.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(attachment.snp_bottom).offset(20)
            make.size.equalTo(CGSize(width: 28, height: 25.5))
        }
        
        categoryLabel.snp_makeConstraints { (make) in
            make.left.equalTo(typeBtn.snp_right).offset(15)
            make.top.equalTo(attachment.snp_bottom).offset(10)
        }
        
        titleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(categoryLabel)
            make.top.equalTo(categoryLabel.snp_bottom).offset(5)
        }
        
        priveLabel.snp_makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp_bottom).offset(8)
        }
    }
    
    
    // MAKR: - 懒加载
        /// 缩略图
    private lazy var attachment : UIImageView = UIImageView()
    
        /// 类型: 最热/推荐
    private lazy var typeBtn : UIButton = {
        let type = UIButton()
        type.setBackgroundImage(UIImage(named:"f_jian_56x51"), forState: .Normal)
        type.setTitle("推荐", forState: .Normal)
        type.userInteractionEnabled = false
        type.titleLabel?.font = UIFont.systemFontOfSize(10)
        return type
    }()
        /// 所属分类
    private lazy var categoryLabel : UILabel = {
       let label = UILabel()
        label.font = UIFont.init(name: "CODE LIGHT", size: 14)
        return label
    }()
        /// 标题
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "CODE LIGHT", size: 15)
        label.textColor = UIColor.blackColor()
        return label
    }()
    
        /// 价格
    private lazy var priveLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(15)
        label.textColor = UIColor.brownColor()
        return label
    }()
}
