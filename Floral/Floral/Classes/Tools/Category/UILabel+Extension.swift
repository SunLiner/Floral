//
//  UILabel+Extension.swift
//  Floral
//
//  Created by 孙林 on 16/5/21.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

extension UILabel
{
    convenience init(textColor: UIColor, font: UIFont) {
        self.init()
        self.font = font
        self.textColor = textColor
    }
}