//
//  RemindNotifyView.swift
//  Floral
//
//  Created by ALin on 16/6/6.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

class RemindNotifyView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.init(gray: 53)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var g_self : RemindNotifyView?
    private func setup()
    {
        RemindNotifyView.g_self = self
        
        addSubview(redPackage)
        addSubview(closeBtn)
        addSubview(titleLabel)
        addSubview(goBtn)
        addSubview(ruleDesLabel)
        redPackage.addSubview(valueLabel)
        
        redPackage.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-DefaultMargin10)
            make.size.equalTo(CGSize(width: 167, height: 194))
        }
        
        titleLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(redPackage.snp_top).offset(-DefaultMargin20-DefaultMargin10)
            make.centerX.equalTo(self)
        }
        
        closeBtn.snp_makeConstraints { (make) in
            make.right.equalTo(redPackage).offset(5)
            make.size.equalTo(CGSize(width: 25, height: 29))
            make.top.equalTo(ScreenHeight / 6.5)
        }
        
        
        ruleDesLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).offset(-50)
        }
        
        goBtn.snp_makeConstraints { (make) in
            make.bottom.equalTo(ruleDesLabel.snp_top).offset(-DefaultMargin10)
            make.centerX.equalTo(self)
        }
        
        valueLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(redPackage)
            make.top.equalTo(194 * 0.35)
        }
        
        titleLabel.text = "恭喜你获得系统红包, 100积分"
        valueLabel.text = "100积分"
    }

    // MARK: - 懒加载
    /// 红包
    private lazy var redPackage = UIImageView(image: UIImage(named: "c_redPackage_167x194"))
    /// 关闭按钮
    private lazy var closeBtn = UIButton(title: nil, imageName: "c_close_25x29", target: g_self!, selector: #selector(RemindNotifyView.close), font: nil, titleColor: nil)
    /// 红包名称
    private lazy var titleLabel = UILabel(textColor: UIColor.whiteColor(), font: UIFont.systemFontOfSize(15))
    /// 立即领取按钮
    private lazy var goBtn = UIButton(title: nil, imageName: "c_recBtn_206x39", target: g_self!, selector: #selector(RemindNotifyView.goNow), font: nil, titleColor: nil)
    /// 规则描述信息
    private lazy var ruleDesLabel : UILabel = {
        let rule = UILabel(textColor: UIColor.init(r: 178, g: 157, b: 102), font: defaultFont14)
        rule.text = "点击查看积分红包规则"
        return rule
    }()
    /// 积分数量
    private lazy var valueLabel = UILabel(textColor: UIColor.whiteColor(), font: defaultFont14)
    
    // MARK: - 点击事件
    @objc private func close()  {
        removeFromSuperview()
    }
    
    @objc private func goNow()
    {
        removeFromSuperview()
        showErrorMessage("恭喜您,领取成功!")
    }
}
