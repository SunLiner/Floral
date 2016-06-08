//
//  UserParentViewCell.swift
//  Floral
//
//  Created by ALin on 16/6/7.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

class UserParentViewCell: UICollectionViewCell {
    var author : Author?
        {
        didSet{
            if let _ = author {
                headImgView.kf_setImageWithURL(NSURL(string: author!.headImg!)!, placeholderImage: UIImage(named: "pc_default_avatar"), optionsInfo: [], progressBlock: nil, completionHandler: nil)
                authorLabel.text = author!.userName ?? "佚名"
                desLabel.text = author!.content ?? "这家伙很懒, 什么也没留下..."
            }
        }
    }
    
    weak var parentViewController : UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup()
    {
        contentView.addSubview(authorLabel)
        contentView.addSubview(headImgView)
        contentView.addSubview(desLabel)
    }
    
    
    /// 作者
    lazy var authorLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "CODE LIGHT", size: 14.0)
        label.text = "花田小憩";
        return label
    }()
    
    
    /// 头像
    lazy var headImgView : UIImageView = {
        let headimage = UIImageView()
        headimage.image = UIImage(named: "pc_default_avatar")
        headimage.layer.cornerRadius = 51 * 0.5
        headimage.layer.masksToBounds = true
        headimage.layer.borderWidth = 0.5
        headimage.layer.borderColor = UIColor.lightGrayColor().CGColor
        headimage.userInteractionEnabled = true
        headimage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UserParentViewCell.clickHeadImage)))
        return headimage
    }()
    
    /// 个性签名
    lazy var desLabel  = UILabel(textColor: UIColor.lightGrayColor(), font: UIFont.init(name: "CODE LIGHT", size: 11)!)

    // MARK: - 点击事件
    func clickHeadImage() {
        guard let _ = author else{
            return
        }
        parentViewController?.presentViewController(ImageBrowserViewController(urls: [NSURL(string: author!.headImg!)!], index: NSIndexPath(forItem: 0, inSection: 0)), animated: true, completion: nil)
    }
}
