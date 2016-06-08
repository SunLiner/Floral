//
//  CommentViewCell.swift
//  Floral
//
//  Created by ALin on 16/5/30.
//  Copyright © 2016年 ALin. All rights reserved.
//  评论的cell

import UIKit

// 默认头像宽高
let DefaultHeadHeight : CGFloat = 51.0
// 默认15间距
let DefaultMargin15 : CGFloat = 15.0
// 默认10间距
let DefaultMargin10 : CGFloat = 10.0
// 默认20间距
let DefaultMargin20 : CGFloat = 20.0

// 评论的cell的按钮类型
enum CommentBtnType : Int {
    case More // 更多
    case Reply // 回复
}

class CommentViewCell: UITableViewCell {
    
    var comment : Comment?
    {
        didSet{
            if let com = comment {
                headImageView.kf_setImageWithURL(NSURL(string: com.writer!.headImg!)!, placeholderImage: UIImage(named: "p_avatar"), optionsInfo: [], progressBlock: nil, completionHandler: nil)
                userNameLable.text = com.anonymous  ?  "匿名用户" : com.writer!.userName
                timeLable.text = com.createDateDesc
                if com.toUser!.id?.characters.count > 0 { // 说明是回复他人的评论, 需要加上@XXX
                    let userName = com.toUser?.userName?.characters.count > 0 ? com.toUser!.userName! : "匿名用户"
                    let content = "@\(userName) " + com.content!
                    let range = (content as NSString).rangeOfString("@\(userName)")
                    let attr = NSMutableAttributedString(string: content)
                    attr.addAttributes([NSForegroundColorAttributeName : UIColor.init(r: 203, g: 47, b: 34)], range: range)
                    contentLable.attributedText = attr
                }else{
                    contentLable.text = com.content
                }
            }
        }
    }
    
    weak var delegate : CommentViewCellDelegate?
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var g_self : CommentViewCell?
    private func setup()
    {
        CommentViewCell.g_self = self
        selectionStyle = .None
        
        contentView.addSubview(headImageView)
        contentView.addSubview(userNameLable)
        contentView.addSubview(timeLable)
        contentView.addSubview(contentLable)
        contentView.addSubview(replyBtn)
        contentView.addSubview(moreBtn)
        contentView.addSubview(underLine)
        
        headImageView.snp_makeConstraints { (make) in
            make.left.equalTo(contentView).offset(DefaultMargin15)
            make.top.equalTo(contentView).offset(DefaultMargin10)
            make.size.equalTo(CGSize(width: DefaultHeadHeight, height: DefaultHeadHeight))
        }
        
        userNameLable.snp_makeConstraints { (make) in
            make.left.equalTo(headImageView.snp_right).offset(DefaultMargin10)
            make.top.equalTo(headImageView).offset(DefaultMargin10)
        }
        timeLable.textAlignment = .Right
        timeLable.snp_makeConstraints { (make) in
            make.centerY.equalTo(userNameLable)
            make.right.equalTo(contentView).offset(-DefaultMargin15)
        }
        
        contentLable.snp_makeConstraints { (make) in
            make.left.equalTo(userNameLable)
            make.right.equalTo(contentView).offset(-DefaultMargin20)
            make.top.equalTo(headImageView.snp_bottom)
        }
        
        moreBtn.snp_makeConstraints { (make) in
            make.right.equalTo(timeLable)
            make.top.equalTo(contentLable.snp_bottom).offset(DefaultMargin10)
            make.width.equalTo(40)
        }
        
        replyBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(moreBtn)
            make.right.equalTo(moreBtn.snp_left)
        }
        
        underLine.snp_makeConstraints { (make) in
//            make.top.equalTo(replyBtn.snp_bottom).offset(DefaultMargin10 * 0.5)
            make.left.equalTo(headImageView)
            make.right.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
    }
    
    // MARK: - 懒加载
    /// 头像
    private lazy var headImageView : UIImageView = {
       let headImage = UIImageView()
        headImage.layer.cornerRadius = DefaultHeadHeight * 0.5
        headImage.layer.masksToBounds = true
        return headImage
    }()
    
    /// 用户名
    private lazy var userNameLable = UILabel(textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(14))
    
    /// 时间
    private lazy var timeLable = UILabel(textColor: UIColor.lightGrayColor(), font: UIFont.systemFontOfSize(11))
    
    /// 内容
    private lazy var contentLable : UILabel = {
       let content = UILabel(textColor: UIColor.lightGrayColor(), font: UIFont.systemFontOfSize(12))
        content.numberOfLines = 0
        return content
    }()
    
    /// 回复按钮
    private lazy var replyBtn = UIButton(title: "回复", imageName: nil, target: g_self!, selector: #selector(CommentViewCell.click(_:)), font: UIFont.systemFontOfSize(12), titleColor: UIColor.orangeColor())
    
    /// 更多操作按钮
    private lazy var moreBtn = UIButton(title: nil, imageName: "p_more_19x15", target: g_self!, selector: #selector(CommentViewCell.click(_:)), font: nil, titleColor: nil)
    
    /// 分割线
    private lazy var underLine = UIImageView(image: UIImage(named:"underLine"))
    
    // MARK: - 点击事件
    func click(btn: UIButton) {
        if btn == replyBtn {
            delegate?.commentViewCell!(self, didClickBtn: CommentBtnType.Reply.rawValue, ReplyComment: comment!)
        }else if(btn == moreBtn){
            delegate?.commentViewCell!(self, didClickBtn: CommentBtnType.More.rawValue, ReplyComment: comment!)
        }
        
    }
}

@objc
protocol CommentViewCellDelegate : NSObjectProtocol {
    optional func commentViewCell(commentViewCell:CommentViewCell, didClickBtn type:CommentBtnType.RawValue,ReplyComment comment: Comment)
}
