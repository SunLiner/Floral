//
//  GoodsCollectionViewCell.swift
//  Floral
//
//  Created by ALin on 16/5/13.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

class GoodsCollectionViewCell: UICollectionViewCell {
    var goods : Goods?
    {
        didSet{
            if let _ = goods {
                bgView.kf_setImageWithURL(NSURL(string: goods!.fnAttachmentSnap!)!, placeholderImage: UIImage(named: "placeholder"), optionsInfo: [], progressBlock: nil, completionHandler: nil)
                typeLabel.text = goods?.fnEnName
                nameLabel.text = goods?.fnName
                priceLabel.text = "¥ \(goods!.fnMarketPrice)"
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
    
    private func  setup()
    {
        contentView.addSubview(bgView)
        bgView.addSubview(coverView)
        contentView.addSubview(typeLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        
        bgView.snp_makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        coverView.snp_makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        priceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(contentView).offset(10)
            make.bottom.equalTo(contentView).offset(-5)
        }
        
        nameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(priceLabel)
            make.bottom.equalTo(priceLabel.snp_top).offset(-6)
            make.right.equalTo(contentView).offset(-10)
        }
        
        typeLabel.snp_makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.bottom.equalTo(nameLabel.snp_top).offset(-3)
        }
    }
    
    // MARK: - 懒加载
    ///缩略图
    private lazy var bgView : UIImageView = UIImageView()
    /// 蒙版
    private lazy var coverView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blackColor()
        view.alpha = 0.3
        return view
    }()
    /// 类型
    private lazy var typeLabel : UILabel = self.creatLabel(UIFont.systemFontOfSize(13))
    /// 商品名称
    private lazy var nameLabel : UILabel = self.creatLabel(UIFont.systemFontOfSize(13))
    /// 商品价格
    private lazy var priceLabel : UILabel = self.creatLabel(UIFont.systemFontOfSize(11))
    
    private func creatLabel(font: UIFont) -> UILabel
    {
        let label = UILabel()
        label.font = font
        label.textColor = UIColor.whiteColor()
        return label
    }
}
