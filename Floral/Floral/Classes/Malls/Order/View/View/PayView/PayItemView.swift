//
//  PayItemView.swift
//  Floral
//
//  Created by ALin on 16/6/3.
//  Copyright © 2016年 ALin. All rights reserved.
//  支付选项

import UIKit

class PayItemView: UIView {
    
    var selected : Bool = false
        {
        didSet{
            checkBox.selected = selected
        }
    }
    
    
    /// 支付信息
    var payInfo : Pay?
        {
        didSet{
            if let iPay = payInfo {
                payIcon.image = iPay.icon
                payTitle.text = iPay.title
                payDes.text = iPay.des
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
        addSubview(payIcon)
        addSubview(payTitle)
        addSubview(payDes)
        addSubview(underLine)
        addSubview(checkBox)
        
        payIcon.snp_makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
            make.size.equalTo(CGSizeMake(40, 40))
        }
        
        payTitle.snp_makeConstraints { (make) in
            make.top.equalTo(payIcon)
            make.left.equalTo(payIcon.snp_right).offset(15)
        }
        
        payDes.snp_makeConstraints { (make) in
            make.bottom.equalTo(payIcon)
            make.left.equalTo(payTitle)
        }
        
        underLine.snp_makeConstraints { (make) in
            make.right.left.equalTo(0)
            make.height.equalTo(1)
            make.bottom.equalTo(self)
        }
        
        checkBox.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-15)
        }
    }
    
    // MARK: - 懒加载
    /// 所用支付的icon
    private lazy var payIcon : UIImageView = UIImageView()
    
    /// 所用支付的名字
    private lazy var payTitle : UILabel = UILabel(textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(14))
    
    /// 所用支付的描述
    private lazy var payDes : UILabel = UILabel(textColor: UIColor.lightGrayColor(), font: UIFont.systemFontOfSize(14))
    
    /// 选择按钮
    private lazy var checkBox : UIButton = {
        let btn = UIButton(title: nil, imageName: "f_adressUnSel_18x18", target: nil, selector: nil, font: nil, titleColor: nil)
        btn.setImage(UIImage(named:"f_adressSel_17x17"), forState: .Selected)
        btn.userInteractionEnabled = false // 不让点击, 直接点击父视图进行选择
        return btn
    }()
    
    /// 下划线
    private lazy var underLine = UIImageView(image:UIImage(named: "underLine"))
}
