//
//  NSObject+Extension.swift
//  Floral
//
//  Created by ALin on 16/5/24.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

extension NSObject
{
    // 显示错误信息
    func showErrorMessage(message: String) {
        // 只有UIView和UIViewController才能显示错误信息
        if self.isKindOfClass(UIView.self) || self.isKindOfClass(UIViewController.self) {
            UIAlertView(title: "花田小憩", message: message, delegate: nil, cancelButtonTitle: "好的").show()
        }
    }
    
}

