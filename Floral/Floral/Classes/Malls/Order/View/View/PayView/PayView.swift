//
//  PayView.swift
//  Floral
//
//  Created by ALin on 16/6/3.
//  Copyright © 2016年 ALin. All rights reserved.
//  支付界面

import UIKit

class PayView: UIView {
    /// 总价
    var totalPrice : String?
    {
        didSet{
            if let iPrice = totalPrice {
                priceLabel.text = "¥" + iPrice
            }
        }
    }
    
    private var selectedPayItem : PayItemView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var g_self : PayView?
    
    private func setup()
    {
        PayView.g_self = self
        
        backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
        payView.backgroundColor = UIColor.whiteColor()
        
        addSubview(payView)
        payView.addSubview(needpayText)
        payView.addSubview(priceLabel)
        payView.addSubview(underLine)
        payView.addSubview(weichat)
        payView.addSubview(alipay)
        payView.addSubview(entryPay)
        
        payView.snp_makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(350)
        }
        
        needpayText.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(15)
        }
        
        priceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(needpayText.snp_right).offset(15)
            make.top.equalTo(needpayText)
        }
        
        underLine.snp_makeConstraints { (make) in
            make.top.equalTo(needpayText.snp_bottom).offset(5)
            make.left.equalTo(needpayText)
            make.right.equalTo(0)
            make.height.equalTo(1)
        }
        
        alipay.snp_makeConstraints { (make) in
            make.top.equalTo(underLine.snp_bottom).offset(5)
            make.left.equalTo(needpayText)
            make.right.equalTo(0)
            make.height.equalTo(60)
        }
        
        weichat.snp_makeConstraints { (make) in
            make.top.equalTo(alipay.snp_bottom).offset(5)
            make.left.equalTo(alipay)
            make.right.equalTo(0)
            make.height.equalTo(60)
        }
        
        entryPay.snp_makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 278, height: 39))
            make.centerX.equalTo(self)
            make.bottom.equalTo(-20)
        }
        
        payView.transform = CGAffineTransformMakeTranslation(0, 350)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PayView.endAnim)))
    }
    
    // MARK: - 动画
    /// 开始动画
    func startAnim() {
        UIView.animateWithDuration(0.5) { 
            self.payView.transform = CGAffineTransformIdentity
        }
    }
    
    /// 结束动画
    func endAnim() {
        UIView.animateWithDuration(0.5, animations: { 
            self.payView.transform = CGAffineTransformMakeTranslation(0, 350)
            }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    
    // MARK: - 懒加载
    /// 总视图
    private lazy var payView = UIView()
    
    /// "需支付"
    private lazy var needpayText : UILabel = {
       let text = UILabel(textColor: UIColor.blackColor(), font: defaultFont14)
        text.text = "需支付:"
        return text
    }()
    
    /// 价格
    private lazy var priceLabel = UILabel(textColor: UIColor.orangeColor(), font: defaultFont14)
    
    /// 下划线
    private lazy var underLine = UIImageView(image: UIImage(named: "underLine"))
    
    /// 支付宝
    private lazy var alipay : PayItemView = {
        let bao = PayItemView()
        bao.payInfo = Pay(dict: ["icon" : UIImage(named:"f_alipay_26x26")!,
                                "title" : "支付宝支付",
                                  "des" : "推荐有支付宝账号的用户使用"])
        bao.selected = true
        bao.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PayView.selectPayItem(_:))))
        return bao
    }()
    
    /// 微信
    private lazy var weichat : PayItemView = {
        let wchat = PayItemView()
        wchat.payInfo = Pay(dict: ["icon" : UIImage(named:"f_wechat_26x26")!,
            "title" : "微信支付",
            "des" : "推荐安装微信5.0及以上版本使用"])
        wchat.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PayView.selectPayItem(_:))))
        return wchat
    }()
    
    /// 确认支付
    private lazy var entryPay = UIButton(title: nil, imageName: "f_okPay_278x39", target: g_self!, selector: #selector(PayView.entryBuy), font: nil, titleColor: nil)
    
    // MARK: - 点击事件
    /// 选择支付项
    @objc private func selectPayItem(tap : UITapGestureRecognizer)
    {
        selectedPayItem = tap.view as? PayItemView
        if tap.view! == weichat { // 选中微信
            weichat.selected = true
            alipay.selected = false
        }else{
            weichat.selected = false
            alipay.selected = true
        }
    }
    
    /// 点击确认支付
    @objc private func entryBuy()
    {
        endAnim()
        if selectedPayItem == weichat {
            showErrorMessage("恭喜您使用微信支付了" + totalPrice! + "元")
        }else{
            showErrorMessage("恭喜您使用支付宝支付了" + totalPrice! + "元")
        }
        
    }
}
