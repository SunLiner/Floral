//
//  MallsCategoryHeader.swift
//  Floral
//
//  Created by ALin on 16/5/10.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

class MallsCategoryHeader: UIView {

    /// 是否显示
    var isShow : Bool = false
    
    /// 显示的父标题
    var title : String?
    {
        didSet{
            if let _ = title {
                btn.setTitle(title! + "     ", forState: .Normal)
            }
        }
    }
    
    /// 代理
    weak var delegate : MallsCategoryHeaderDelagate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(btn)
        
        btn.snp_makeConstraints { (make) in
            make.width.equalTo(self)
            make.height.equalTo(44)
            make.centerY.equalTo(self)
            make.left.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 懒加载
    private lazy var btn: TitleBtn = {
       let title = TitleBtn()
        title.addTarget(self, action: #selector(MallsCategoryHeader.click(_:)), forControlEvents: .TouchUpInside)
        return title
    }()
    
    // MARK: - 点击事件
    @objc private func click(button: TitleBtn) {
        isShow = button.selected
        button.selected = !button.selected
        delegate?.mallsCategoryHeaderchick!(self)
    }
}

// MARK: - 协议
@objc
protocol MallsCategoryHeaderDelagate : NSObjectProtocol {
    optional func mallsCategoryHeaderchick(header:MallsCategoryHeader)
}
