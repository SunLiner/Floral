//
//  ThirdLoginView.swift
//  Floral
//
//  Created by ALin on 16/5/4.
//  Copyright © 2016年 ALin. All rights reserved.
//  第三方登陆

import UIKit

class ThirdLoginView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI设置和布局
    private func setupUI()
    {
        addSubview(titleLabel)
        addSubview(leftLine)
        addSubview(rightLine)
        addSubview(weixinBtn)
        addSubview(weiboBtn)
        addSubview(qqBtn)
        
        titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.centerX.equalTo(self)
        }
        
        leftLine.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.centerY.equalTo(titleLabel)
            make.size.equalTo(CGSize(width: 50, height: 1))
        }
        
        rightLine.snp_makeConstraints { (make) in
            make.right.equalTo(self)
            make.centerY.equalTo(titleLabel)
            make.size.equalTo(leftLine)
        }
        
        weixinBtn.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(5)
            make.top.equalTo(titleLabel.snp_bottom).offset(15)
        }
        
        weiboBtn.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(weixinBtn)
        }
        
        qqBtn.snp_makeConstraints { (make) in
            make.right.equalTo(self).offset(-5)
            make.top.equalTo(weixinBtn)
        }
        
    }
    
    // MARK: - 懒加载
        /// title
    private lazy var titleLabel : UILabel = {
       let label = UILabel()
        label.text = "第三方账号登陆"
        label.textColor = UIColor.blackColor()
        label.font = UIFont.init(name: "CODE LIGHT", size: 13)
        return label
    }()
    
        // 左右分割线
    private lazy var leftLine = UIImageView(image: UIImage(named: "underLine"))
    private lazy var rightLine = UIImageView(image: UIImage(named: "underLine"))
    
        /// 微信登陆
    private lazy var weixinBtn : UIButton = self.creatBtn("s_weixin_50")
        /// 微博登陆
    private lazy var weiboBtn : UIButton = self.creatBtn("s_weibo_50")
        /// QQ登陆
    private lazy var qqBtn : UIButton = self.creatBtn("s_qq_50")
    
    private func creatBtn(imageName: String) -> UIButton
    {
        let btn = UIButton()
        btn.setImage(UIImage.imageWithColor(imageName, color: UIColor.blackColor()), forState: .Normal)
        return btn
    }
    
}
