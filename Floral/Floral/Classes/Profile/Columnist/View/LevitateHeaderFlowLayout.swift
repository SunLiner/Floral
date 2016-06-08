//
//  LevitateHeaderFlowLayout.swift
//  Floral
//
//  Created by ALin on 16/5/20.
//  Copyright © 2016年 ALin. All rights reserved.
//  可以让header悬浮的流水布局

import UIKit

class LevitateHeaderFlowLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        // 即使界面内容没有超过界面大小,也要竖直方向滑动
        collectionView?.alwaysBounceVertical = true
        // sectionHeader停留
        if #available(iOS 9.0, *) {
            sectionHeadersPinToVisibleBounds = true
        }
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // 1. 获取父类返回的UICollectionViewLayoutAttributes数组
        var answer = super.layoutAttributesForElementsInRect(rect)!
        
        // 2. 如果是iOS9.0以上, 直接返回父类的即可. 不用执行下面的操作了. 因为我们直接设置sectionHeadersPinToVisibleBounds = true即可
        if #available(iOS 9.0, *) {
            return answer
        }
        
        // 3. 如果是iOS9.0以下的系统
        
        // 以下代码来源:http://stackoverflow.com/questions/13511733/how-to-make-supplementary-view-float-in-uicollectionview-as-section-headers-do-i%3C/p%3E
        // 目的是让collectionview的header可以像tableview的header一样, 可以停留
        
        // 创建一个索引集.(NSIndexSet:唯一的，有序的，无符号整数的集合)
        let missingSections = NSMutableIndexSet()
        // 遍历, 获取当前屏幕上的所有section
        for layoutAttributes in answer {
            // 如果是cell类型, 就加入索引集里面
            if (layoutAttributes.representedElementCategory == UICollectionElementCategory.Cell) {
                missingSections.addIndex(layoutAttributes.indexPath.section)
            }
        }
        
        // 遍历, 将屏幕中拥有header的section从索引集中移除
        for layoutAttributes in answer {
            // 如果是header, 移掉所在的数组
            if (layoutAttributes.representedElementKind == UICollectionElementKindSectionHeader) {
                missingSections .removeIndex(layoutAttributes.indexPath.section)
            }
        }
        
        // 遍历当前屏幕没有header的索引集
        missingSections.enumerateIndexesUsingBlock { (idx, _) in
            // 获取section中第一个indexpath
            let indexPath = NSIndexPath(forItem: 0, inSection: idx)
            // 获取其UICollectionViewLayoutAttributes
            let layoutAttributes = self.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, atIndexPath: indexPath)
            // 如果有值, 就添加到UICollectionViewLayoutAttributes数组中去
            if let _ = layoutAttributes{
                answer.append(layoutAttributes!)
            }
        }
        
        // 遍历UICollectionViewLayoutAttributes数组, 更改header的值
        for layoutAttributes in answer {
            // 如果是header, 改变其参数
            if (layoutAttributes.representedElementKind==UICollectionElementKindSectionHeader) {
                // 获取header所在的section
                let section = layoutAttributes.indexPath.section
                // 获取section中cell总数
                let numberOfItemsInSection = collectionView!.numberOfItemsInSection(section)
                // 获取第一个item的IndexPath
                let firstObjectIndexPath = NSIndexPath(forItem: 0, inSection: section)
                // 获取最后一个item的IndexPath
                let lastObjectIndexPath = NSIndexPath(forItem: max(0, (numberOfItemsInSection - 1)), inSection: section)
                
                // 定义两个变量来保存第一个和最后一个item的layoutAttributes属性
                var firstObjectAttrs : UICollectionViewLayoutAttributes
                var lastObjectAttrs : UICollectionViewLayoutAttributes
                
                // 如果当前section中cell有值, 直接取出来即可
                if (numberOfItemsInSection > 0) {
                    firstObjectAttrs =
                        self.layoutAttributesForItemAtIndexPath(firstObjectIndexPath)!
                    lastObjectAttrs = self.layoutAttributesForItemAtIndexPath(lastObjectIndexPath)!
                } else { // 反之, 直接取header和footer的layoutAttributes属性
                    firstObjectAttrs = self.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, atIndexPath: firstObjectIndexPath)!
                    lastObjectAttrs = self.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionFooter, atIndexPath: lastObjectIndexPath)!
                }
                // 获取当前header的高和origin
                let headerHeight = CGRectGetHeight(layoutAttributes.frame)
                var origin = layoutAttributes.frame.origin
                
                origin.y = min(// 2. 要保证在即将消失的临界点跟着消失
                    max( // 1. 需要保证header悬停, 所以取最大值
                        collectionView!.contentOffset.y  + collectionView!.contentInset.top,
                        (CGRectGetMinY(firstObjectAttrs.frame) - headerHeight)
                    ),
                    (CGRectGetMaxY(lastObjectAttrs.frame) - headerHeight)
                )
                
                // 默认的层次关系是0. 这儿设置大于0即可.为什么设置成1024呢?因为我们是程序猿...
                layoutAttributes.zIndex = 1024
                layoutAttributes.frame = CGRect(origin: origin, size: layoutAttributes.frame.size)
                
            }
            
        }
        
        return answer;
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        // 返回true, 表示一旦进行滑动, 就实时调用上面的-layoutAttributesForElementsInRect:方法
        return true
    }

}
