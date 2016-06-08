//
//  TopArticleCell.swift
//  Floral
//
//  Created by 孙林 on 16/5/1.
//  Copyright © 2016年 ALin. All rights reserved.
//  

import UIKit

// cell的重用标识符
enum TopArticleCellReuseIdentifier : String{
    // 1-3名的重用标识
    case normal = "TopArticleNormalCellReuseIdentifier"
    // 4-10名的重用标识
    case other = "TopArticleOtherCellReuseIdentifier"
}

class TopArticleCell: UITableViewCell {
    var article : Article?
    {
        didSet{
            if let art = article {
                smallIconView.opaque = false
                // 设置数据
                smallIconView.kf_setImageWithURL(NSURL(string: art.smallIcon!)!, placeholderImage: UIImage(named: "placehodler"), optionsInfo: [], progressBlock: nil, completionHandler: nil)
                titleLabel.text = art.title
            }

        }
    }
    
    // 名次
    var sort : Int = 1
        {
        didSet{
            sortLabel.text = "TOP " + "\(sort)"
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI()
    {
        // 使得整个cell的顶部, 有5个间距
        backgroundColor = UIColor.init(gray: 241.0)
        contentView.backgroundColor = UIColor.whiteColor()
        contentView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
        }
        
    }
    
        /// 缩略图
    lazy var smallIconView : UIImageView = UIImageView()
    
        // 蒙版
    lazy var coverView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.blackColor()
        view.alpha = 0.2
        return view
    }()
    
        /// 标题
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(15)
        label.textAlignment = .Center
        label.textColor = UIColor.whiteColor()
        return label
    }()
    
        /// 上面的白色分割线
    lazy var topLine : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        return view
    }()
    
        /// 下面的白色分割线
    lazy var underLine : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        return view
    }()
    
        /// 名次
    lazy var sortLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(11)
        label.textColor = UIColor.whiteColor()
        return label
    }()
        /// Logo
    lazy var logLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(10)
        label.textColor = UIColor.whiteColor()
        label.text = "FLORAL & FILE"
        return label
    }()
}
