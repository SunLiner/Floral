//
//  CommentBottomView.swift
//  Floral
//
//  Created by ALin on 16/5/30.
//  Copyright © 2016年 ALin. All rights reserved.
//  评论列表底部的评论视图

import UIKit

class CommentBottomView: UIView {
    /// placeholder
    var placeHolderStr : String?
    {
        didSet{
            if let _ = placeHolderStr {
                textFiled.placeholder = "回复:"+placeHolderStr!
                textFiled.becomeFirstResponder()
            }else{
                textFiled.placeholder = "评论"
            }
        }
    }
    
    var comment : Comment?
    
    
    /// 代理
    weak var delegete :CommentBottomViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    static var g_self : CommentBottomView?
    private func setup()
    {
        CommentBottomView.g_self = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CommentBottomView.keyboardDidChangeFrame(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        backgroundColor = UIColor.whiteColor()
        
        addSubview(textFiled)
        addSubview(sendBtn)
        addSubview(underLine)
        
        underLine.snp_makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(1)
        }
        
        sendBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-10)
            make.width.equalTo(40)
        }
        
        textFiled.snp_makeConstraints { (make) in
            make.height.equalTo(30)
            make.centerY.equalTo(sendBtn)
            make.left.equalTo(15)
            make.right.equalTo(sendBtn.snp_left).offset(-10)
        }
    }
    
    @objc private func keyboardDidChangeFrame(notify : NSNotification)
    {
        let rect : CGRect = notify.userInfo!["UIKeyboardFrameEndUserInfoKey"]!.CGRectValue()
        if rect.origin.y == ScreenHeight { // 隐藏键盘
            placeHolderStr = nil
            comment = nil
        }
        delegete?.commentBottomView!(self, keyboradFrameChange: notify.userInfo!)
    }
    
    private lazy var textFiled : UITextField = {
       let text = UITextField(frame: CGRectZero, isPlaceHolderSpace: true)
        text.background = UIImage(named: "s_bg_3rd_292x43")
        text.placeholder = "评论"
        text.font = UIFont.systemFontOfSize(12)
        // 设置placeholder的字体
        text.setValue(UIFont.systemFontOfSize(12), forKeyPath: "_placeholderLabel.font")
        return text
    }()
    private lazy var sendBtn = UIButton(title: "发送", imageName: nil, target: g_self!, selector: #selector(CommentBottomView.sendMessage), font: UIFont.systemFontOfSize(13), titleColor: UIColor.blackColor())
    
    /// 分割线
    private lazy var underLine = UIImageView(image: UIImage(named:"underLine"))

    // MARK: - 点击事件
    func sendMessage() {
        let message = textFiled.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) ?? ""
        if textFiled.text?.characters.count < 1 || message.characters.count < 1 {
            showErrorMessage("不能发送空消息")
            return
        }
        delegete?.commentBottomView!(self, sendMessage: textFiled.text!, replyComment: comment)
        // 评论/回复完成后, 置空
        textFiled.text = ""
    }
}

@objc
protocol CommentBottomViewDelegate : NSObjectProtocol {
    /// 键盘监听的代理
    optional func commentBottomView(commentBottomView: CommentBottomView, keyboradFrameChange userInfo:[NSObject : AnyObject])
    /// 点击评论/回复
    optional func commentBottomView(commentBottomView: CommentBottomView, sendMessage message:String, replyComment comment: Comment?)
}
