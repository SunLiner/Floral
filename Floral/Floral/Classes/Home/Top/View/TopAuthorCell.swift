//
//  TopAuthorCell.swift
//  Floral
//
//  Created by 孙林 on 16/5/1.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

class TopAuthorCell: UITableViewCell {
    var author : Author?
    {
        didSet{
            if let person = author {
                headImgView.kf_setImageWithURL(NSURL(string: person.headImg!)!, placeholderImage: UIImage(named: "pc_default_avatar"), optionsInfo: [], progressBlock: nil, completionHandler: nil)
                authorLabel.text = person.userName ?? "佚名"
                authView.image = person.authImage
            }
        }
    }
    
    // 名次
    var sort : Int = 1
    {
        didSet{
            sortLabel.text = "\(sort)"
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI()
    {
        contentView.addSubview(headImgView)
        contentView.addSubview(authView)
        contentView.addSubview(authorLabel)
        contentView.addSubview(sortLabel)
        
        headImgView.snp_makeConstraints { (make) in
            make.left.equalTo(30)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: 51, height: 51))
        }
        
        authView.snp_makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 14, height: 14))
            make.bottom.right.equalTo(headImgView)
        }
        
        authorLabel.snp_makeConstraints { (make) in
            make.left.equalTo(headImgView.snp_right).offset(10)
            make.centerY.equalTo(self)
        }
        
        sortLabel.snp_makeConstraints { (make) in
            make.right.equalTo(self).offset(-20)
            make.centerY.equalTo(self)
        }
    }
    
    // MARK: - 懒加载
    /// 作者
    private lazy var authorLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "CODE LIGHT", size: 14.0)
        label.text = "花田小憩";
        return label
    }()
    
    /// 头像
    private lazy var headImgView : UIImageView = {
        let headimage = UIImageView()
        headimage.image = UIImage(named: "pc_default_avatar")
        headimage.layer.cornerRadius = 51 * 0.5
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

    /// 当前第几名
    private lazy var sortLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.blackColor()
        label.font = UIFont.systemFontOfSize(20)
        return label
    }()
}
