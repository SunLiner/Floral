//
//  AddAddressInputView.swift
//  Floral
//
//  Created by 孙林 on 16/6/5.
//  Copyright © 2016年 ALin. All rights reserved.
//  新增视图

import UIKit

class AddAddressInputView: UIView {
    
    init(frame: CGRect, title: String, isNum: Bool) {
        super.init(frame: frame)
        // 基本设置
        setup()
        // 设置名称
        titleLabel.text = title + ":"
        inputFiled.keyboardType = isNum ? .NumberPad : .Default
        inputFiled.placeholder = "*请输入" + title
        
        let inputAccessoryView = InputAccessoryView()
        inputAccessoryView.frame = CGRectMake(0, 0, ScreenWidth, 40)
        inputAccessoryView.filed = inputFiled
        inputFiled.inputAccessoryView = inputAccessoryView
        
        if (title as NSString).isEqualToString("所在地区") {
            let areaInputView = AreaInputView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 216))
            areaInputView.locationFiled = inputFiled
            inputFiled.inputView = areaInputView
        }
        
        if (title as NSString).isEqualToString("收货人") {
            inputFiled.becomeFirstResponder()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup()
    {
        backgroundColor = UIColor.whiteColor()
        inputFiled.font = defaultFont14
        titleLabel.textAlignment = .Right
        
        addSubview(titleLabel)
        addSubview(inputFiled)
        addSubview(underLine)
        
        titleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(10)
            make.width.equalTo(60)
        }
        
        inputFiled.snp_makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp_right).offset(5)
            make.bottom.top.equalTo(titleLabel)
            make.right.equalTo(-15)
        }
        
        underLine.snp_makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.bottom.right.equalTo(self)
            make.height.equalTo(1)
        }
    }

    // MARK: - 懒加载
     ///  名称
    private lazy var titleLabel = UILabel(textColor: UIColor.blackColor(), font: defaultFont14)
    
     /// 输入框
    lazy var inputFiled : UITextField = UITextField(frame: CGRectZero, isPlaceHolderSpace: true)
    
     /// 分割线
    private lazy var underLine = UIImageView(image: UIImage(named: "underLine"))

}
