//
//  ImageBrowserViewCell.swift
//  Floral
//
//  Created by ALin on 16/6/6.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

class ImageBrowserViewCell: UICollectionViewCell {
    weak var delegate: ImageBrowserViewCellDelegate?
    
    var imageURL: NSURL?{
        didSet{
            // 重置cell所有属性
            resetScrollview()
            
            iconView.kf_setImageWithURL(imageURL!, placeholderImage: nil, optionsInfo: [], progressBlock: { (receivedSize, totalSize) in
//                ALinLog(CGFloat(receivedSize)/CGFloat(totalSize))
                // 绘制进度
                self.iconView.progress =  CGFloat(receivedSize)/CGFloat(totalSize)
                }) { (image, error, cacheType, imageURL) in
                     // 重新调整图片的frame
                    self.setupImagePostion()
            }
            
        }
    }
    
    private func resetScrollview()
    {
        iconView.transform = CGAffineTransformIdentity
        
        scrollview.contentInset = UIEdgeInsetsZero
        scrollview.contentOffset = CGPointZero
        scrollview.contentSize = CGSizeZero
    }
    
    
    private func setupImagePostion()
    {
        // 0.安全校验
        guard let _ = iconView.image else
        {
            return
        }
        
        // 1.拿到图片宽高比
        let s = iconView.image!.size.height / iconView.image!.size.width
        // 2.按照图片的宽高比缩放图片, 保证能够显示整张图片
        let screenWidth = UIScreen.mainScreen().bounds.width
        let screenHeight = UIScreen.mainScreen().bounds.height
        let height = s * screenWidth
        
        iconView.frame = CGRect(origin: CGPointZero, size: CGSize(width: screenWidth, height: height))
        
        // 3.判断当前是长图还是短图
        if height > screenHeight
        {
            scrollview.contentSize = iconView.bounds.size
        }else{
            // 3.计算Y值
            let y = (UIScreen.mainScreen().bounds.height - height) * 0.5
            scrollview.contentInset = UIEdgeInsetsMake(y, 0, 0, y)
        }
    }
    
    // MARK: - 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 内部控制方法
    private func setupUI()
    {
        // 1.添加子控件
        contentView.addSubview(scrollview)
        scrollview.addSubview(iconView)
        
        // 2.布局子控件
        scrollview.frame = bounds
        iconView.frame = scrollview.frame
    }
    
    // MARK: - 触摸事件
    /// 关闭图片浏览器
    @objc private func closePhotoBrowser()
    {
        // 通知控制器关闭浏览器
        delegate?.ImageBrowserViewCellDidClickImage!(self)
    }
    
    /// 长按图片
    @objc private func longclickImage(longPress:UILongPressGestureRecognizer)
    {
        // 必须判断不然会调用多次
        if longPress.state == UIGestureRecognizerState.Ended {
            // 通知控制器关闭浏览器
            delegate?.ImageBrowserViewCellDidLongClickImage!(self)
        }
        
    }
    
    // MARK: - 懒加载
    lazy var iconView: ProgressImageView = {
        let iv = ProgressImageView(frame: CGRectZero)
        iv.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(ImageBrowserViewCell.closePhotoBrowser))
        iv.addGestureRecognizer(tap)
        let longtap = UILongPressGestureRecognizer(target: self, action: #selector(ImageBrowserViewCell.longclickImage))
        iv.addGestureRecognizer(longtap)
        
        return iv
    }()
    private lazy var scrollview: UIScrollView = {
        let sc = UIScrollView()
        sc.delegate = self
        
        sc.maximumZoomScale = 2.0
        sc.minimumZoomScale = 0.5
        return sc
    }()
}

@objc
protocol ImageBrowserViewCellDelegate : NSObjectProtocol
{
    optional func ImageBrowserViewCellDidClickImage(cell: ImageBrowserViewCell)
    optional func ImageBrowserViewCellDidLongClickImage(cell: ImageBrowserViewCell)
}


extension ImageBrowserViewCell: UIScrollViewDelegate
{
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
    {
        return iconView
    }
    
    // 该方法传入的view就是被缩放的view
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        
        // 注意: scrollview缩放内部的实现原理其实是利用transform实现的,
        // 如果是利用transform缩放控件, 那么bounds不会改变, 只有frame会改变
        
        // 重新调整图片的位置
        let screenWidth = UIScreen.mainScreen().bounds.width
        let screenHeight = UIScreen.mainScreen().bounds.height
        var offsetY = (screenHeight - view!.frame.height) * 0.5
        
        // 注意: 如果offsetY是负数, 会导致高度显示不完整
        offsetY = offsetY < 0 ? 0 : offsetY
        
        var offsetX = (screenWidth - view!.frame.width) * 0.5
        
        // 注意: 如果offsetX负数, 会导致高度显示不完整
        offsetX = offsetX < 0 ? 0 : offsetX
        
        scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, offsetY, offsetX)
    }
    
}

