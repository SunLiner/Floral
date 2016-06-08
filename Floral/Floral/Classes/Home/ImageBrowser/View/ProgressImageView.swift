//
//  ProgressImageView.swift
//  Floral
//
//  Created by ALin on 16/6/7.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

class ProgressImageView: UIImageView {

    var progress: CGFloat = 0{
        didSet{
            if progress == 1 {
                progressView.removeFromSuperview()
                return
            }
            progressView.hidden = false
            progressView.progress = progress
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        KeyWindow.addSubview(progressView)
        progressView.hidden = true
        progressView.snp_makeConstraints { (make) in
            make.center.equalTo(0)
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
    }
    
    deinit{
        progressView.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var progressView: ProgressView =
        {
            let pv = ProgressView()
            pv.backgroundColor = UIColor.clearColor()
            return pv
    }()

}

private class ProgressView: UIView {
    // 进度值 0.0~1.0
    var progress: CGFloat = 0{
        didSet{
            setNeedsDisplay()
        }
    }
    
    // 只要调用setNeedsDisplay就会调用drawRect方法重新绘制
    // 传入的rect就是当前控件的bounds
    override func drawRect(rect: CGRect) {
        
        if progress >= 1
        {
            return
        }
        
        // 画圆弧
        // 准备数据
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        let radius = min(rect.width * 0.45, rect.height * 0.45)
        let startAngle = -CGFloat(M_PI_2)
        let endAngle = CGFloat(M_PI) * 2 * progress + startAngle
        
        // 创建路径
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.lineWidth = 3
        // 和圆心连接一条直线
//        path.addLineToPoint(center)
        
        // 设置填充颜色
        UIColor.whiteColor().setStroke()
        
        // 绘制图片
        path.stroke()
    }
    
}
