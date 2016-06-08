//
//  DetailHeaderView.swift
//  Floral
//
//  Created by ALin on 16/4/28.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

class DetailHeaderView: UIView {
    var article : Article?
        {
        didSet{
            if let art = article {
                if let author = art.author {
                    headImgView.kf_setImageWithURL(NSURL(string: author.headImg!)!, placeholderImage: UIImage(named: "p_avatar"), optionsInfo: [], progressBlock: nil, completionHandler: nil)
                    authorLabel.text = author.userName!
                    identityLabel.text = author.identity!
                    subscriberLabel.text = "已有\(author.subscibeNum)人订阅"
                    authView.image = author.authImage
                }
                
            }
        }
    }
    
    // MARK: - 声明周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 基本设置
    func setupUI()
    {
        backgroundColor = UIColor.whiteColor()
        addSubview(authorLabel)
        addSubview(headImgView)
        addSubview(authView)
        addSubview(identityLabel)
        addSubview(subscriberBtn)
        addSubview(subscriberLabel)
        
        headImgView.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: 31, height: 31))
        }
        
        authView.snp_makeConstraints { (make) in
            make.right.equalTo(headImgView)
            make.bottom.equalTo(headImgView)
            make.size.equalTo(CGSize(width: 8, height: 8))
        }
        
        authorLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(headImgView.snp_right).offset(5)
        }
        
        identityLabel.snp_makeConstraints { (make) in
            make.left.equalTo(authorLabel.snp_right).offset(8)
            make.centerY.equalTo(self)
        }
        
        subscriberBtn.snp_makeConstraints { (make) in
            make.right.equalTo(self).offset(-10)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: 50, height: 25))
        }
        
        subscriberLabel.snp_makeConstraints { (make) in
            make.right.equalTo(subscriberBtn.snp_left).offset(-8)
            make.centerY.equalTo(self)
        }
        
    }
    
    // MARK: - 懒加载
    /// 作者
    private lazy var authorLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "CODE LIGHT", size: 13.0)
        return label
    }()
    
    /// 称号
    private lazy var identityLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "CODE LIGHT", size: 12.0)
        label.textColor = UIColor.blackColor().colorWithAlphaComponent(0.9)
        return label
    }()
    
    /// 头像
    private lazy var headImgView : UIImageView = {
        let headimage = UIImageView()
        headimage.image = UIImage(named: "p_avatar")
        headimage.layer.cornerRadius = 31 * 0.5
        headimage.layer.masksToBounds = true
        headimage.layer.borderWidth = 0.5
        headimage.layer.borderColor = UIColor.lightGrayColor().CGColor
        return headimage
    }()
    
    /// 认证
    private lazy var authView : UIImageView = {
        let auth = UIImageView()
        auth.image = UIImage(named: "personAuth")
        return auth
    }()

    /// 订阅数
    private lazy var subscriberLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "CODE LIGHT", size: 12.0)
        label.text = "已有0人订阅";
        label.textColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        return label
    }()
    
    /// 定义按钮
    private lazy var subscriberBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(r: 255, g: 211, b: 117)
        btn.setTitle("订阅", forState: .Normal)
        btn.setTitleColor(UIColor.blackColor().colorWithAlphaComponent(0.8), forState: .Normal)
        btn.titleLabel?.font = UIFont.init(name: "CODE LIGHT", size: 12.0)
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
        return btn
    }()
}
