//
//  OlderMessageViewCell.swift
//  Floral
//
//  Created by ALin on 16/6/2.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

// 默认的12号字体
let DefaultFont12 = UIFont.systemFontOfSize(12)

class OlderMessageViewCell: NormalParentCell, UITextViewDelegate {

    override func setup() {
        super.setup()
        
        contentView.addSubview(numLabel)
        contentView.addSubview(numBtn)
        contentView.addSubview(underLine)
        contentView.addSubview(tipLabel)
        contentView.addSubview(messageView)
        
        numLabel.snp_makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(15)
        }
        
        numBtn.snp_makeConstraints { (make) in
            make.top.equalTo(numLabel)
            make.right.equalTo(contentView).offset(-15)
        }
        
        underLine.snp_makeConstraints { (make) in
            make.top.equalTo(numLabel.snp_bottom).offset(15)
            make.left.equalTo(numLabel)
            make.right.equalTo(0)
        }
        
        tipLabel.snp_makeConstraints { (make) in
            make.left.equalTo(underLine)
            make.top.equalTo(underLine.snp_bottom).offset(10)
        }
        
        messageView.snp_makeConstraints { (make) in
            make.left.equalTo(tipLabel)
            make.right.equalTo(contentView).offset(-20)
            make.top.equalTo(tipLabel.snp_bottom).offset(10)
            make.height.equalTo(60)
        }
    }
    
    // MARK: - 懒加载
    // 文字:"购买数量"
    private lazy var numLabel : UILabel = {
        let label = UILabel(textColor: UIColor.blackColor(), font: DefaultFont12)
        label.text = "购买数量"
        return label
    }()
    
    // 购买数量
    private lazy var numBtn : NumButton = {
        let btn = NumButton(title: nil, imageName: nil, target: nil, selector: nil, font: defaultFont14, titleColor: UIColor.blackColor())
        btn.num = 1
        btn.setBackgroundImage(UIImage(named:"f_count_83x25"), forState: .Normal)
        return btn
    }()
    
    /// 分割线
    private lazy var underLine = UIImageView(image: UIImage(named: "underLine"))
    
    /// 卡牌留言
    private lazy var tipLabel : UILabel = {
        let label = UILabel(textColor: UIColor.blackColor(), font: DefaultFont12)
        label.text = "卡片留言"
        return label
    }()
    
    /// 留言板
    private lazy var messageView : PlaceHolderTextView = {
        let field = PlaceHolderTextView()
        field.placeHolderLabel.text = "请在此处留下您想要的卡片内容, 限70汉字以内."
        field.delegate = self
        return field
    }()
    
    // MARK: - UITextViewDelegate
    func textViewDidChange(textView: UITextView) {
        if textView.text.characters.count > 0 {
            messageView.placeHolderLabel.hidden = true
        }else{
            messageView.placeHolderLabel.hidden = false
        }
        
        // 超过140就不管了...
        if textView.text.characters.count > 140 {
            messageView.text = (textView.text! as NSString).substringToIndex(140)
        }
    }
    
}
