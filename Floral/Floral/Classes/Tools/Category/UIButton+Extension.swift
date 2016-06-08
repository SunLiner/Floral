//
//  UIButton+Extension.swift
//  Floral
//
//  Created by ALin on 16/4/25.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

extension UIButton
{
    convenience init(title: String?, imageName: String?, target: AnyObject? ,selector: Selector?, font: UIFont?, titleColor: UIColor?) {
        self.init()
        if let imageN = imageName {
            setImage(UIImage(named:imageN), forState: .Normal)
        }
        setTitleColor(titleColor, forState: .Normal)
        titleLabel?.font = font
        setTitle(title, forState: .Normal)
        if let sel = selector {
            addTarget(target, action: sel, forControlEvents: .TouchUpInside)
        }
        
    }
}