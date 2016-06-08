//
//  ToolBottomView.swift
//  Floral
//
//  Created by ALin on 16/4/26.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit
import SnapKit

enum ToolBarBtnType : Int {
    case See // 查看数
    case Zan // 点赞
    case Comment //评论
}

class ToolBottomView: UIView{
    var article : Article?
    {
        didSet{
            seeBtn .setTitle("\(article!.read)", forState: .Normal)
            commentBtn.setTitle("\(article!.fnCommentNum)", forState: .Normal)
            zanBtn.setTitle("\(article!.favo)", forState: .Normal)
            
            if article!.isNotHomeList {
                if let time = article!.createDateDesc {
                    timeBtn.hidden = false
                    timeBtn.setTitle(time, forState: .Normal)
                    commentBtn.userInteractionEnabled = true
                }else{
                    timeBtn.hidden = true
                }
            }else{
               timeBtn.hidden = true
            }
        }
    }
    
    weak var delegate : ToolBottomViewDelegate?
    
    // MARK: 生命周期方法
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI设置和布局
    
    private func setupUI()
    {
        addSubview(seeBtn)
        addSubview(commentBtn)
        addSubview(zanBtn)
        addSubview(timeBtn)
        
        commentBtn.snp_makeConstraints { (make) in
            make.right.equalTo(self).offset(-20)
            make.centerY.equalTo(self)
        }
        
        zanBtn.snp_makeConstraints { (make) in
            make.right.equalTo(commentBtn.snp_left).offset(-10)
            make.centerY.equalTo(self)
        }
        
        seeBtn.snp_makeConstraints { (make) in
            make.right.equalTo(zanBtn.snp_left).offset(-10)
            make.centerY.equalTo(self)
        }
        
        timeBtn.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.centerY.equalTo(self)
        }
    }
    
    // MARK: - 懒加载
    
    /// 查看数
    private lazy var seeBtn: UIButton = self.createBtn("hp_count")
    /// 评论数
    private lazy var commentBtn: UIButton = self.createBtn("p_comment")
    
    /// 点赞数
    private lazy var zanBtn: UIButton = self.createBtn("p_zan")
    /// 时间
    private lazy var timeBtn: UIButton =  self.createBtn("ad_time")
    
    // MARK: 内部方法
    /**
     创建一个按钮
     
     - parameter imageName: 图片名
     
     - returns: 按钮
     */
    private func createBtn(imageName: String) -> UIButton
    {
        let btn = UIButton(title: "10", imageName: imageName, target: nil, selector: nil, font:UIFont.systemFontOfSize(12) , titleColor: UIColor.blackColor().colorWithAlphaComponent(0.5))
        btn.userInteractionEnabled = false
        btn.sizeToFit()
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10)
        btn.addTarget(self, action: #selector(ToolBottomView.click(_:)), forControlEvents: .TouchUpInside)
        return btn
    }
    
    // 点击事件
    func click(btn: UIButton) {
        if btn == seeBtn {
            delegate?.toolBottomView!(self, type: ToolBarBtnType.See.rawValue)
        }else if(btn == zanBtn){
             delegate?.toolBottomView!(self, type: ToolBarBtnType.Zan.rawValue)
        }else if(btn == commentBtn){
             delegate?.toolBottomView!(self, type: ToolBarBtnType.Comment.rawValue)
        }
    }
}

@objc
protocol ToolBottomViewDelegate : NSObjectProtocol {
     optional func toolBottomView(toolBottomView:ToolBottomView, type:ToolBarBtnType.RawValue)
}
