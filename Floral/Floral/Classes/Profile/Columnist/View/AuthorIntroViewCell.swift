//
//  AuthorIntroViewCell.swift
//  Floral
//
//  Created by 孙林 on 16/5/21.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

class AuthorIntroViewCell: UserParentViewCell {
    override var author : Author?
    {
        didSet{
            if let _ = author {
                identityLabel.text = author!.identity!
                authView.image = author!.authImage
                dingyueLabel.text = "已有\(author!.subscibeNum)人订阅"
            }
        }
    }
    

    
    override func setup()
    {
        super.setup()
        backgroundColor = UIColor.whiteColor()
        contentView.addSubview(dingyueBtn)
        contentView.addSubview(dingyueLabel)
        contentView.addSubview(identityLabel)
        contentView.addSubview(authView)
        
        headImgView.snp_makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(10)
            make.size.equalTo(CGSize(width: 51, height: 51))
        }
        
        authView.snp_makeConstraints { (make) in
            make.bottom.right.equalTo(headImgView)
            make.size.equalTo(CGSize(width: 14, height: 14))
        }
        
        authorLabel.snp_makeConstraints { (make) in
            make.top.equalTo(headImgView).offset(2)
            make.left.equalTo(headImgView.snp_right).offset(10)
        }
        
        identityLabel.snp_makeConstraints { (make) in
            make.top.equalTo(authorLabel).offset(2)
            make.left.equalTo(authorLabel.snp_right).offset(15)
        }
        
        desLabel.snp_makeConstraints { (make) in
            make.top.equalTo(authorLabel.snp_bottom).offset(10)
            make.left.equalTo(authorLabel)
        }
        
        dingyueLabel.snp_makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-10)
            make.top.equalTo(desLabel).offset(3)
        }
        
        dingyueBtn.snp_makeConstraints { (make) in
            make.top.equalTo(headImgView.snp_bottom).offset(10)
            make.left.equalTo(headImgView)
            make.right.equalTo(dingyueLabel)
            make.height.equalTo(30)
        }
    }
    
    // MARK - 懒加载
    /// 称号
    private lazy var identityLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "CODE LIGHT", size: 12.0)
        label.text = "资深专家";
        label.textColor = UIColor.blackColor().colorWithAlphaComponent(0.9)
        return label
    }()
    
    /// 认证
    private lazy var authView : UIImageView = {
        let auth = UIImageView()
        auth.image = UIImage(named: "personAuth")
        return auth
    }()
    
    /// 订阅数
    private lazy var dingyueLabel : UILabel = UILabel(textColor: UIColor.lightGrayColor(), font: UIFont.systemFontOfSize(12))
    /// 定义按钮
    private lazy var dingyueBtn : UIButton = {
       let btn = UIButton(title: "订阅", imageName: nil, target: nil, selector: nil, font: defaultFont14, titleColor: UIColor.blackColor())
        btn.setBackgroundImage(UIImage(named:"loginBtn"), forState: .Normal)
        return btn
    }()


}
