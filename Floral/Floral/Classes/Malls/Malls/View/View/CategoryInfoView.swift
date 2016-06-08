//
//  CategoryInfoView.swift
//  Floral
//
//  Created by 孙林 on 16/5/12.
//  Copyright © 2016年 ALin. All rights reserved.
//  商城顶部的分类信息, 用于跳转到分类中去

import UIKit

class CategoryInfoView: UIView {
    var malls : MallsGoods?
    {
        didSet{
                DescLabel.text = malls!.fnDesc
                titleLabel.text = malls!.fnName
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
        addSubview(DescLabel)
        addSubview(titleLabel)
        addSubview(gotoBtn)
        
        DescLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(self).offset(12)
        }
        
        titleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(DescLabel)
            make.top.equalTo(DescLabel.snp_bottom).offset(5)
        }
        
        gotoBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-20)
        }
    }
    
    /// 描述信息
    private lazy var DescLabel : UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFontOfSize(14)
        label.textColor = UIColor.blackColor()
        label.text = "A SURPRISE"
        return label
    }()
    
    /// 名称
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(14)
        label.textColor = UIColor.blackColor()
        label.text = "华彩和"
        return label
    }()
    
    /// goto图标
    private lazy var gotoBtn : UIButton = {
       let btn = UIButton()
        btn.setImage(UIImage(named:"goto"), forState: .Normal)
        btn.userInteractionEnabled = false
        return btn
    }()
}
