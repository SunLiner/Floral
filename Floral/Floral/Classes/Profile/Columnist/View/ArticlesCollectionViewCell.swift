//
//  ArticlesCollectionViewCell.swift
//  Floral
//
//  Created by 孙林 on 16/5/21.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

class ArticlesCollectionViewCell: UICollectionViewCell {
    var article : Article?
    {
        didSet{
            if let art = article {
                // 设置数据
                thumbnail.kf_setImageWithURL(NSURL(string: art.smallIcon!)!, placeholderImage: UIImage(named: "placehodler"), optionsInfo: [], progressBlock: nil, completionHandler: nil)
                nameLabel.text = art.title
                descLabel.text = art.desc
                zanBtn.setTitle("\(art.favo)", forState: .Normal)
                seeBtn.setTitle("\(art.read)", forState: .Normal)
            }

        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup()
    {
        contentView.backgroundColor = UIColor.whiteColor()
        
        contentView.addSubview(thumbnail)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descLabel)
        contentView.addSubview(underLine)
        contentView.addSubview(zanBtn)
        contentView.addSubview(seeBtn)
        
        thumbnail.snp_makeConstraints { (make) in
            make.left.right.top.equalTo(contentView)
            make.height.equalTo(140)
        }
        
        nameLabel.snp_makeConstraints { (make) in
            make.top.equalTo(thumbnail.snp_bottom).offset(10)
            make.left.equalTo(contentView).offset(10)
            make.right.equalTo(contentView).offset(-10)
        }
        
        descLabel.snp_makeConstraints { (make) in
            make.left.right.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp_bottom).offset(5)
        }
        
        underLine.snp_makeConstraints { (make) in
            make.left.equalTo(contentView).offset(5)
            make.right.equalTo(contentView).offset(-5)
            make.height.equalTo(1)
            make.top.equalTo(descLabel.snp_bottom).offset(15)
        }
        
        zanBtn.snp_makeConstraints { (make) in
            make.left.equalTo(underLine).offset(5)
            make.width.equalTo(contentView).multipliedBy(0.4)
            make.top.equalTo(underLine.snp_bottom).offset(5)
        }
        
        seeBtn.snp_makeConstraints { (make) in
            make.left.equalTo(contentView.snp_centerX).multipliedBy(0.8)
            make.width.top.equalTo(zanBtn)
        }
    }
    
    // MARK: - 懒加载
     /// 缩略图
    private lazy var thumbnail = UIImageView()
    
     /// 标题
    private lazy var nameLabel = UILabel(textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(13))
    
     /// 描述信息
    private lazy var descLabel = UILabel(textColor: UIColor.lightGrayColor(), font: UIFont.systemFontOfSize(11))
    
     /// 分割线
    private lazy var underLine = UIImageView(image: UIImage(named: "underLine"))
    
     /// 赞的数量
    private lazy var zanBtn : UIButton = self.createBtn("p_zan")
    /// 查看的数量
    private lazy var seeBtn : UIButton = self.createBtn("hp_count")
    
    // MARK: - 内部控制方法
    // 创建一个button
    private func createBtn(imageName: String) -> UIButton
    {
        let btn = UIButton(title: nil, imageName: imageName, target: nil, selector: nil, font: UIFont.systemFontOfSize(11), titleColor: UIColor.lightGrayColor())
        btn.contentHorizontalAlignment = .Left
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        btn.userInteractionEnabled = false
        return btn
    }
}
