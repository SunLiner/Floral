//
//  UITextField+Extension.swift
//  Floral
//
//  Created by 孙林 on 16/5/15.
//  Copyright © 2016年 ALin. All rights reserved.
//  swift2.0这儿的有点问题. 在stackoverflow里面也没有找到答案...返回的beginning一直是未初始化状态...

import UIKit

extension UITextField
{
//    func setSelectedRange(range: NSRange){
        // 获取文本开始位置
//        let beginning :UITextPosition = rang
//        if beginning {
//            beginning = UITextPosition()
//        }
        // 开始位置
//        let startPosition = positionFromPosition(beginning, offset: range.location)
//        // 结束位置
//        let endPosition = positionFromPosition(beginning, offset: range.location + range.length)
//        
//        let selectionRange = textRangeFromPosition(startPosition!, toPosition: endPosition!)
//        // 设置光标位置
//        selectedTextRange = selectionRange
        
//        let beginning = selectedTextRange;
//        startPosition = positionFromPosition(beginning?.start, offset: range.location)
//         start = [self.tvName positionFromPosition:range.start inDirection:UITextLayoutDirectionLeft offset:textField.text.length];
//        if (start)
//        {
//            [self.tvName setSelectedTextRange:[self.tvName textRangeFromPosition:start toPosition:start]];
//        }
//    }
    
    // 初始化的时候, 光标多出来一点间距, 原本在OC可以使用上面这个方法, 但是swift中貌似不行
    convenience init(frame: CGRect, isPlaceHolderSpace: Bool) {
        self.init(frame: frame)
        
        if isPlaceHolderSpace {
            let space = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
            leftView = space
            leftViewMode = .Always
        }
    }
    
    // 判断当前的textfiled的值是否为空
    func isNil() -> Bool {
        if text?.characters.count < 1 {
            return true
        }
        return false
    }
}
