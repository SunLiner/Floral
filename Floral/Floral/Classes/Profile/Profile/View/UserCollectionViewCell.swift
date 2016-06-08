//
//  UserCollectionViewCell.swift
//  Floral
//
//  Created by ALin on 16/5/24.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UserParentViewCell {
    override var author : Author?
        {
        didSet{
            if let _ = author {
                pointsNumLabel.text = "已获取\(author!.integral)个积分"
                levelBtn.setTitle("lv.\(author!.level)", forState: .Normal)
                empiricalBtn.setTitle("\(author!.experience)", forState: .Normal)
            }
        }
    }
    
    // 点击购物车的回调
    var clickShopCar : (()->())?
    // 点击提示🔔的回调
    var clickRemind : (()->())?
    
    // 这儿需要定义一个全局的self用来调用UIbutton扩展中的初始化方法.
    static var g_self : UserCollectionViewCell?
    
    override func setup()
    {
        super.setup()
        UserCollectionViewCell.g_self = self
        
        backgroundColor = UIColor.whiteColor()
        
        contentView.addSubview(shopCarBtn)
        contentView.addSubview(remindBtn)
        contentView.addSubview(levelBtn)
        contentView.addSubview(experienceLine)
        contentView.addSubview(experienceLabel)
        contentView.addSubview(empiricalBtn)
        contentView.addSubview(pointsLine)
        contentView.addSubview(pointsLabel)
        contentView.addSubview(pointsNumLabel)
        
        headImgView.snp_makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(30)
            make.size.equalTo(CGSize(width: 51, height: 51))
        }
        
        authorLabel.snp_makeConstraints { (make) in
            make.top.equalTo(headImgView).offset(5)
            make.left.equalTo(headImgView.snp_right).offset(10)
            make.width.lessThanOrEqualTo(250)
        }
        
        remindBtn.snp_makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-15)
            make.top.equalTo(authorLabel)
            make.size.equalTo(CGSize(width: 35, height: 35))
        }
        
        shopCarBtn.snp_makeConstraints { (make) in
            make.right.equalTo(remindBtn.snp_left).offset(-5)
            make.size.top.equalTo(remindBtn)
        }
        
        desLabel.snp_makeConstraints { (make) in
            make.left.equalTo(authorLabel)
            make.top.equalTo(authorLabel.snp_bottom).offset(10)
            make.right.equalTo(shopCarBtn.snp_left).offset(15)
        }
        
        pointsLabel.snp_makeConstraints { (make) in
            make.left.equalTo(headImgView)
            make.top.equalTo(headImgView.snp_bottom).offset(20)
            make.height.equalTo(15)
        }
        
        pointsLine.snp_makeConstraints { (make) in
            make.left.equalTo(pointsLabel.snp_right).offset(10)
            make.bottom.top.equalTo(pointsLabel)
            make.width.equalTo(1)
        }
        
        pointsNumLabel.snp_makeConstraints { (make) in
            make.left.equalTo(pointsLine.snp_right).offset(10)
            make.centerY.equalTo(pointsLine)
        }
        
        experienceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(pointsLabel)
            make.top.equalTo(pointsLabel.snp_bottom).offset(10)
            make.height.equalTo(pointsLabel)
        }
        
        experienceLine.snp_makeConstraints { (make) in
            make.left.equalTo(experienceLabel.snp_right).offset(10)
            make.top.equalTo(experienceLabel)
            make.height.equalTo(pointsLabel)
            make.width.equalTo(1)
        }
        
        levelBtn.snp_makeConstraints { (make) in
            make.left.equalTo(experienceLine.snp_right).offset(10)
            make.centerY.equalTo(experienceLine)
        }
        
        empiricalBtn.snp_makeConstraints { (make) in
            make.left.equalTo(levelBtn.snp_right).offset(10)
            make.top.equalTo(experienceLine)
            make.height.equalTo(pointsLabel)
            make.width.equalTo(80)
        }
    }
    
    
    // MARK - 懒加载
    
    /// 购物车
    private lazy var shopCarBtn = UIButton(title: nil, imageName: "shoppingCar_35x35", target:g_self! , selector: #selector(UserCollectionViewCell.clickCar), font: nil, titleColor: nil)
    
    /// 提醒
    private lazy var remindBtn = UIButton(title: nil, imageName: "setIcon_35x35", target: g_self!, selector: #selector(UserCollectionViewCell.clickRemindBtn), font: nil, titleColor: nil)
    
    /// 积分
    private lazy var pointsLabel : UILabel = {
       let label = UILabel(textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(11))
        label.text = "积分值"
        return label
    }()
    
    /// 已经获得的积分
    private lazy var pointsNumLabel : UILabel = UILabel(textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(11))
    
    /// 经验
    private lazy var experienceLabel : UILabel = {
        let label = UILabel(textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(11))
        label.text = "经验值"
        return label
    }()
    
    /// 等级
    private lazy var levelBtn : UIButton = {
        let btn = UIButton(title: "lv.1", imageName: nil, target: nil, selector: nil, font: UIFont.systemFontOfSize(8), titleColor: UIColor.whiteColor())
        btn.setBackgroundImage(UIImage(named:"pc_level_bg_33x10"), forState: .Normal)
        return btn
    }()
    
    /// 经验条
    private lazy var empiricalBtn : UIButton = {
       let btn = UIButton(title: "0", imageName: "empirical_57x9", target: nil, selector: nil, font: UIFont.systemFontOfSize(10), titleColor: UIColor.blackColor())
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        return btn
    }()
    
    // 两条分割线
    private lazy var pointsLine = UIImageView(image: UIImage(named: "f_loginfo_line_0x61"))
    private lazy var experienceLine = UIImageView(image: UIImage(named: "f_loginfo_line_0x61"))
    
    // MARK: - private method
    // 点击购物车
    func clickCar() {
        if let _ = clickShopCar {
            clickShopCar!()
        }
    }
    
    // 点击🔔
    func clickRemindBtn() {
        if let _ = clickRemind {
            clickRemind!()
        }
    }
}
