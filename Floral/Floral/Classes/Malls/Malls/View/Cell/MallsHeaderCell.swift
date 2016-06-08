//
//  MallsHeader.swift
//  Floral
//
//  Created by 孙林 on 16/5/10.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

class MallsHeaderCell: UITableViewCell {
    // 图片路径
    var imageUrl : String?
    {
        didSet{
            if let _ = imageUrl {
                topImageView.kf_setImageWithURL(NSURL(string: imageUrl!)!, placeholderImage: UIImage(named: "placehodler"), optionsInfo: [], progressBlock: nil, completionHandler: nil)
            }
        }
    }
    
    var parentVc : MallsTableViewController?
    {
        didSet{
            if let _ = parentVc {
                 topMenuView.delegate = parentVc
            }
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    private func setup()
    {
        // 基本设置
        selectionStyle = .None
        
        // 添加子控件
        addSubview(topImageView)
        addSubview(topMenuView)
        
        // 布局
        topImageView.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(224)
        }
        
        topMenuView.snp_makeConstraints { (make) in
            make.top.equalTo(topImageView.snp_bottom)
            make.left.right.equalTo(self)
            make.height.equalTo(40)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK - 懒加载
    // 顶部的图片
    private lazy var topImageView = UIImageView()
    private lazy var topMenuView : TopMenuView = {
       let top = TopMenuView()
        top.firstTitle = "精选"
        top.secondTitle = "商城"
        return top
    }()

}
