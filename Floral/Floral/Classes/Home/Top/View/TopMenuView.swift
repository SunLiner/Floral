//
//  TopMenuView.swift
//  Floral
//
//  Created by 孙林 on 16/5/1.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

class TopMenuView: UIView {
    /// 代理
    weak var delegate : TopMenuViewDelegate?
    
    /// 标题数组
    var titles : [String]?
    
    
    // 给两个菜单按钮赋值
    var firstTitle : String?
    {
        didSet{
            if let first = firstTitle {
                articleBtn.setTitle(first, forState: .Normal)
            }
        }
    }
    var secondTitle : String?
    {
        didSet{
            if let second = secondTitle {
                authorBtn.setTitle(second, forState: .Normal)
            }
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
    
    // MARK: - 添加子控件和布局
    private func setupUI()
    {
        addSubview(underLine)
        addSubview(authorBtn)
        addSubview(articleBtn)
        addSubview(tipLine)
        
        underLine.snp_makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self).offset(-1)
            make.height.equalTo(1)
        }
        
        articleBtn.snp_makeConstraints { (make) in
            make.left.top.equalTo(self)
            make.height.equalTo(self)
            make.width.equalTo(authorBtn)
        }
        
        authorBtn.snp_makeConstraints { (make) in
            make.right.top.equalTo(self)
            make.left.equalTo(articleBtn.snp_right)
            make.size.equalTo(articleBtn)
        }

        
        // 计算tipLine的X值 = (屏幕宽度 * 0.5 - 文字的宽度) * 0.5
        let tipLineLeft = (ScreenWidth * 0.5 - (authorBtn.currentTitle! as NSString).boundingRectWithSize(CGSize(width: CGFloat.max, height: CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.init(name: "CODE LIGHT", size: 15)!], context: nil).size.width) * 0.5
        tipLine.snp_makeConstraints { (make) in
            make.left.equalTo(tipLineLeft)
            make.width.equalTo(articleBtn.titleLabel!)
            make.bottom.equalTo(underLine.snp_top)
            make.height.equalTo(2)
        }
    }
    
    // MARK: - 懒加载
        /// 底部的分割线
    private lazy var underLine : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.init(gray: 164.0)
        return view
    }()
    
        /// 作者按钮
    private lazy var authorBtn : UIButton = self.createBtn("作者")
        /// 文字按钮
    private lazy var articleBtn : UIButton = self.createBtn("专栏")
        /// 底部跟着滚动的tip线
    private lazy var tipLine : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.blackColor()
        return view
    }()
    
    // MARK: - 内部控制方法
    // 根据title创建一个btn
    private func createBtn(title: String) -> UIButton
    {
        let btn = UIButton (title: title, imageName: nil, target: self, selector: #selector(TopMenuView.clickbtn(_:)), font: UIFont.init(name: "CODE LIGHT", size: 15)
, titleColor: UIColor.blackColor())
        return btn
    }
    
    @objc private func clickbtn(btn: UIButton){
        
        let left = btn.frame.origin.x + btn.titleLabel!.frame.origin.x
        self.tipLine.snp_updateConstraints { (make) in
            make.left.equalTo(left)
        }
        
        UIView.animateWithDuration(0.25) {
            self.layoutIfNeeded()
        }
        
        delegate?.topMenuView!(self, selectedTopAction: btn == authorBtn ? TOP10Action.TopArticleAuthor.rawValue :  TOP10Action.TopContents.rawValue)
    }
    
}

// MARK: - 代理方法
@objc
protocol TopMenuViewDelegate: NSObjectProtocol {
    optional func topMenuView(topMenuView:TopMenuView, selectedTopAction action: TOP10Action.RawValue)
}
