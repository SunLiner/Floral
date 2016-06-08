//
//  ShareBlurView.swift
//  Floral
//
//  Created by ALin on 16/5/31.
//  Copyright © 2016年 ALin. All rights reserved.
//  分享的高斯蒙版

import UIKit

// 分享的图片宽/高度
private let DefaultImageWh : CGFloat = 66.0
// 分享视图的父视图的高度
private let DefaultShareH : CGFloat = 70.0

class ShareBlurView: UIVisualEffectView {
    // 分享的block
    var shareBlock : ((type : String)->())?
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        
        // 设置高斯模糊度
        alpha = 0.77
        
//        // 点击视图, 退出分享界面
//        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ShareBlurView.endAnim)))
        
        contentView.addSubview(shareView)
        
        shareView.snp_makeConstraints { (make) in
            make.top.equalTo(DefaultMargin20)
            make.left.right.equalTo(self)
            make.height.equalTo(DefaultShareH)
        }
     
        // 实际开发中需要先判断一下是否安装客服端了, 如果没有安装, 就不要显示该按钮,有利用审核通过
//        if WXApi.isWXAppInstalled() {
//            
//        }
        
        shareView.addSubview(wechat)
        shareView.addSubview(wesseion)
        shareView.addSubview(weibo)
        shareView.addSubview(qq)
        
        let margin = (ScreenWidth - DefaultMargin20 * 2 - DefaultImageWh * 4) / 3.0
        
        wechat.snp_makeConstraints { (make) in
            make.left.equalTo(DefaultMargin20)
            make.centerY.equalTo(shareView)
            make.size.equalTo(CGSize(width: DefaultImageWh, height: DefaultImageWh))
        }
        
        wesseion.snp_makeConstraints { (make) in
            make.left.equalTo(wechat.snp_right).offset(margin)
            make.centerY.equalTo(shareView)
            make.size.equalTo(wechat)
        }
        
        weibo.snp_makeConstraints { (make) in
            make.left.equalTo(wesseion.snp_right).offset(margin)
            make.centerY.equalTo(shareView)
            make.size.equalTo(wechat)
        }
        
        qq.snp_makeConstraints { (make) in
            make.left.equalTo(weibo.snp_right).offset(margin)
            make.centerY.equalTo(shareView)
            make.size.equalTo(wechat)
        }
        
        // 通常情况下, 要根据真机上是否安装了该应用来决定是否显示该图标, 不然可能审核被拒
        // 由于分享通常都是使用第三方, 比如友盟. 这儿我们简单用一下系统的分享
        weibo.userInteractionEnabled = true
        weibo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ShareBlurView.shareToSina)))
    }
    
    // MARK: - 动画相关
    func startAnim()  {
        shareView.transform = CGAffineTransformMakeTranslation(0, -DefaultShareH)
        UIView.animateWithDuration(0.5) {
            self.shareView.transform = CGAffineTransformIdentity
        }
    }
    
    func endAnim()  {
        UIView.animateWithDuration(0.5, animations: { 
            self.shareView.transform = CGAffineTransformMakeTranslation(0, -DefaultShareH)
            }) { (_) in
                self.removeFromSuperview()
        }
    }
    
    // 分享按钮的父视图
    private lazy var shareView = UIView()
    // 微信
    private lazy var wechat = UIImageView(image: UIImage(named: "s_weixin_50x50"))
    // 朋友圈
    private lazy var wesseion = UIImageView(image: UIImage(named: "s_pengyouquan_50x50"))
    // 微博
    private lazy var weibo = UIImageView(image: UIImage(named: "s_weibo_50x50"))
    // QQ
    private lazy var qq = UIImageView(image: UIImage(named: "s_qq_50x50"))
    
    // MARK: - 分享
    func shareToSina() {
        shareBlock?(type: UMShareToSina)
    }
}
