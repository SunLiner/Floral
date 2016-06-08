//
//  NewFeatureCell.swift
//  Floral
//
//  Created by ALin on 16/4/25.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit
import SnapKit

class NewFeatureCell: UICollectionViewCell {
    // 显示的image
    var image : UIImage?
    {
        didSet{
            if let img = image {
                imageView.image = img
            }
        }
    }
    
    // MARK: - 内部控制方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup()
    {
        contentView.addSubview(imageView)
        
        imageView.snp_makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    // MARK: - 懒加载
    private lazy var imageView : UIImageView = UIImageView()
}
