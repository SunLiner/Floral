//
//  DetailHeadCell.swift
//  Floral
//
//  Created by ALin on 16/4/27.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit
import SnapKit

class DetailHeadCell: UITableViewCell {
    var article : Article?
    {
        didSet{
            if let art = article {
                topImageView.kf_setImageWithURL(NSURL(string: art.smallIcon!)!, placeholderImage: UIImage(named: "placehodler"), optionsInfo: [], progressBlock: nil, completionHandler: nil)
                titleLabel.text = art.title
                if let category = art.category {
                    categoryLabel.text = "#\(category.name)#"
                }
                
            }
        }
    }
    
    // MARK: - 生命周期
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 设置且布局UI
    func setupUI()
    {
        // 添加子控件
        contentView.addSubview(topImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(shortLine)
        
        // 自动布局
        topImageView.snp_makeConstraints { (make) in
            make.left.right.top.equalTo(contentView)
            make.height.equalTo(160)
        }
        
        titleLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(topImageView.snp_bottom).offset(20)
        }
        
        categoryLabel.snp_makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp_bottom).offset(10)
            make.centerX.equalTo(contentView)
        }
        
        let shortLineWidth = ("家居庭院" as NSString).boundingRectWithSize(CGSizeMake(CGFloat.max, CGFloat.max), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.init(name: "CODE LIGHT", size: 13)!], context: nil).size.width
        shortLine.snp_makeConstraints { (make) in
            make.top.equalTo(categoryLabel.snp_bottom).offset(8)
            make.centerX.equalTo(contentView)
            make.width.equalTo(shortLineWidth)
        }
        
    }
    
    // MARK: - 懒加载
    // 顶部的缩略图
    private lazy var topImageView : UIImageView = UIImageView(image: UIImage(named: "20160425175259881847"))
    
    // 标题
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "初夏花清和"
        return label
    }()
    
    // 分类
    private lazy var categoryLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "CODE LIGHT", size: 13)
        label.text = "#家居庭院#"
        return label
    }()
    
    // 分割线(短)
    private lazy var shortLine : UIImageView = UIImageView(image: UIImage(named: "underLine"))
    
}
