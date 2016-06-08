//
//  DetailFooter.swift
//  Floral
//
//  Created by ALin on 16/5/26.
//  Copyright © 2016年 ALin. All rights reserved.
//  商城详情页的最底部

import UIKit

class DetailFooter: UIView {
    var goods : Goods?
    {
        didSet{
            if let _ = goods {
                priceLabel.text = "¥\(goods!.fnMarketPrice)"
                
                let data = NSData(contentsOfURL: NSURL(string: goods!.fnAttachment!)!)
                if let _ = data {
                    animLayer.contents = UIImage(data: data!)!.CGImage
                }else{
                    animLayer.contents = UIImage(named: "20160425175259881847")!.CGImage
                }
                
            }
        }
    }
    
    // 点击购买的block
    var clickBuyBlock : (()->())?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var g_self : DetailFooter?
    // 基本设置
    private func setup()
    {
        DetailFooter.g_self = self
        
        backgroundColor = UIColor.whiteColor()
        addSubview(shopCarBtn)
        addSubview(priceLabel)
        addSubview(addtoCar)
        addSubview(buyNow)
        
        shopCarBtn.snp_makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(self)
        }
        
        priceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(shopCarBtn.snp_right).offset(20)
            make.centerY.equalTo(shopCarBtn)
            make.width.equalTo(100)
        }
        
        addtoCar.snp_makeConstraints { (make) in
            make.left.equalTo(priceLabel.snp_right)
            make.top.bottom.equalTo(self)
            make.width.equalTo(buyNow)
        }
        
        buyNow.snp_makeConstraints { (make) in
            make.left.equalTo(addtoCar.snp_right)
            make.right.equalTo(self)
            make.top.bottom.equalTo(self)
            make.width.equalTo(addtoCar)
        }
        
    }
    
    // MARK: - 懒加载
    // 购物车
    private lazy var shopCarBtn : ShopCarBtn = ShopCarBtn(title: nil, imageName: "f_cart_23x21", target: nil, selector: nil, font: nil, titleColor: nil)
    
    // 价格
    private lazy var priceLabel = UILabel(textColor: UIColor.blackColor(), font:UIFont.systemFontOfSize(16))
   
    // 加入购物车
    private lazy var addtoCar : UIButton = {
        let btn = UIButton(title: "加入购物车", imageName: nil, target: g_self!, selector: #selector(DetailFooter.gotoShopCar), font: UIFont.systemFontOfSize(14), titleColor: UIColor.whiteColor())
        btn.backgroundColor = UIColor.lightGrayColor()
        return btn
    }()
    
    // 购买
    private lazy var buyNow : UIButton = {
        let btn = UIButton(title: "购买", imageName: nil, target: self, selector: #selector(DetailFooter.clickBtn(_:)), font: UIFont.systemFontOfSize(14), titleColor: UIColor.whiteColor())
        btn.backgroundColor = UIColor.blackColor()
        return btn
    }()
    
    // MARK: - 点击事件
    func clickBtn(btn: UIButton) {
        if btn == buyNow {
            clickBuyBlock?()
        }
    }
    
    
    // MARK : - 动画相关懒加载
    /// layer
    private lazy var animLayer : CALayer = {
        let layer = CALayer()
        layer.contentsGravity = kCAGravityResizeAspectFill;
        layer.bounds = CGRectMake(0, 0, 50, 50);
        layer.cornerRadius = CGRectGetHeight(layer.bounds) / 2
        layer.masksToBounds = true;
        return layer
    }()
    
    /// 贝塞尔路径
    private lazy var animPath = UIBezierPath()
    
    /// 动画组
    private lazy var groupAnim : CAAnimationGroup = {
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = self.animPath.CGPath
        animation.rotationMode = kCAAnimationRotateAuto
        
        let expandAnimation = CABasicAnimation(keyPath: "transform.scale")
        expandAnimation.duration = 1
        expandAnimation.fromValue = 0.5
        expandAnimation.toValue = 2
        expandAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        let narrowAnimation = CABasicAnimation(keyPath: "transform.scale")
        // 先执行上面的, 然后再开始
        narrowAnimation.beginTime = 1
        narrowAnimation.duration = 0.5
        narrowAnimation.fromValue = 2
        narrowAnimation.toValue = 0.5
        narrowAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        let groups = CAAnimationGroup()
        groups.animations = [animation,expandAnimation,narrowAnimation]
        groups.duration = 1.5
        groups.removedOnCompletion = false
        groups.fillMode = kCAFillModeForwards
        groups.delegate = self
        return groups
    }()
    
    
    // MARK: - 点击事件处理
    private var num = 0
    func gotoShopCar() {
        if num >= 99 {
            self.showErrorMessage("亲, 企业采购请联系我们客服")
            return
        }
        addtoCar.userInteractionEnabled = false
        
        // 设置layer
        // 贝塞尔弧线的起点
        animLayer.position = addtoCar.center
        layer.addSublayer(animLayer)
        // 设置path
        animPath.moveToPoint(animLayer.position)
        
        let controlPointX = CGRectGetMaxX(addtoCar.frame) * 0.5
        
        // 弧线, controlPoint基准点, endPoint结束点
        animPath.addQuadCurveToPoint(shopCarBtn.center, controlPoint: CGPointMake(controlPointX, -frame.size.height * 5))
        
        // 添加并开始动画
        animLayer.addAnimation(groupAnim, forKey: "groups")
    }
    
    // MARK: - 动画的代理
    // 动画停止的代理
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if anim ==  animLayer.animationForKey("groups")!{
            animLayer.removeFromSuperlayer()
            animLayer.removeAllAnimations()
            
            num += 1
            shopCarBtn.num = num
            
            let animation = CATransition()
            animation.duration = 0.25
            
            shopCarBtn.layer.addAnimation(animation, forKey: nil)
            
            let shakeAnimation = CABasicAnimation(keyPath: "transform.translation.y")
            shakeAnimation.duration = 0.25
            shakeAnimation.fromValue = -5
            shakeAnimation.toValue = 5
            shakeAnimation.autoreverses = true
            
            shopCarBtn.layer .addAnimation(shakeAnimation, forKey: nil)
            addtoCar.userInteractionEnabled = true

        }
    }

}
