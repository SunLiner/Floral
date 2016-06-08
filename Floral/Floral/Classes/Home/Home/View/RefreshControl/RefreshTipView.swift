//
//  RefreshTipView.swift
//  Floral
//
//  Created by ALin on 16/4/18.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit
import SnapKit

class RefreshTipView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI()
    {
        addSubview(arrowView)
        addSubview(tipLabel)
        
        arrowView.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self).offset(-40)
            make.centerY.equalTo(self)
        }
        
        tipLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(arrowView.snp_right).offset(20)
            make.centerY.equalTo(arrowView)
        }
    }
    
    /// 旋转箭头, 改变文字
    func rotationRefresh(flag: Bool)
    {
        // transfrom的旋转默认是顺时针旋转
        // 如果设置了旋转的角度, 默认是就近原则, 离那边近, 就从哪个方向转
        let angle = flag ? -0.01 : 0.01
        UIView.animateWithDuration(0.5) { () -> Void in
            self.arrowView.transform = CGAffineTransformRotate(self.arrowView.transform, CGFloat(angle + M_PI))
            self.tipLabel.text = flag ? "释放刷新" : "下拉刷新"
        }
        
    }
    
    /// 开始转菊花
    func beginLoadingAnimator()
    {
        tipLabel.text = "正在加载..."
        arrowView.image = UIImage(named: "tableview_loading")
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.repeatCount = MAXFLOAT
        anim.duration = 0.25
        anim.toValue = 2 * M_PI
        // 默认removedOnCompletion后就会移除动画
        anim.removedOnCompletion = false
        arrowView.layer.addAnimation(anim, forKey: nil)
    }
    
    /// 停止菊花动画
    func stopLoadingAnimator()
    {
        tipLabel.text = "下拉刷新"
        arrowView.image = UIImage(named: "tableview_pull_refresh")
        arrowView.layer.removeAllAnimations()
    }

    let arrowView : UIImageView = {
       let arrow = UIImageView(image: UIImage(named: "tableview_pull_refresh"))
       return arrow
    }()
    
    let tipLabel : UILabel = {
        let tip = UILabel()
        tip.font = UIFont(name: "CODE LIGHT", size: 14)
        tip.text = "下拉刷新"
        return tip
    }()
}
