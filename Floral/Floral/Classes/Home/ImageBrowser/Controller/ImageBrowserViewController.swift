//
//  ImageBrowserViewController.swift
//  Floral
//
//  Created by ALin on 16/6/6.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit
private let ImageBrowserCellReuseIdentifier = "ImageBrowserCellReuseIdentifier"
class ImageBrowserViewController: UICollectionViewController, ImageBrowserViewCellDelegate, UIActionSheetDelegate {
    // 图片URL数组的
    var imageUrls : [NSURL]
    // 点击的当前图片的索引
    var indexPath : NSIndexPath
    init(urls: [NSURL], index: NSIndexPath)
    {
        imageUrls = urls
        indexPath = index
        super.init(collectionViewLayout: PhotoBrowserLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        // 滚动到指定位置
        collectionView!.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView!.registerClass(ImageBrowserViewCell.self, forCellWithReuseIdentifier: ImageBrowserCellReuseIdentifier)
        
        KeyWindow.addSubview(titleLabel)
        
        titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(30)
            make.centerX.equalTo(KeyWindow)
        }
        titleLabel.text = "\(indexPath.item+1)/\(imageUrls.count)"
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        titleLabel.removeFromSuperview()
    }
    
    
    // MARK: - UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ImageBrowserCellReuseIdentifier, forIndexPath: indexPath) as! ImageBrowserViewCell
        
        cell.imageURL = imageUrls[indexPath.item]
        cell.delegate = self
        
        return cell
    }
    
    
    // MARK: - PhotoBrowserViewCellDelegate
    func ImageBrowserViewCellDidClickImage(cell: ImageBrowserViewCell) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func ImageBrowserViewCellDidLongClickImage(cell: ImageBrowserViewCell) {
        UIActionSheet(title: "花田小憩", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "保存").showInView(collectionView!)
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / collectionView!.frame.width + 0.5)
        titleLabel.text = "\(index+1)/\(imageUrls.count)"
    }
    
    // MARK: - UIActionSheetDelegate
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        actionSheet.dismissWithClickedButtonIndex(buttonIndex, animated: true)
        if buttonIndex == 0 { // 点击了保存按钮
            saveImage()
        }
    }
    
    private func saveImage()
    {
        // 1.获取当前显示图片的索引, 注意不能使用传入的索引, 因为用户可能已经滚动过了
        let indexPath = collectionView!.indexPathsForVisibleItems().last!
        // 2.获取当前显示图片索引对应的cell, 然后从cell中取出图片
        let cell = collectionView!.cellForItemAtIndexPath(indexPath) as! ImageBrowserViewCell
        // 3. 保存图片
        if let image = cell.iconView.image
        {
            /*
             第一个参数: 需要保存的图片
             第二个参数: 谁类监听是否保存成功
             第三个参数: 哪个方法来监听是否保存成功
             第四个参数: 给回调方法传递的参数
             - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
             */
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(ImageBrowserViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        
    }
    
    func image(image: UIImage, didFinishSavingWithError error:NSError?, contextInfo: AnyObject)
    {
        if error != nil{
            showHint("保存失败", duration: 2.0, yOffset: 0)
        }else
        {
            showHint("保存成功", duration: 2.0, yOffset: 0)
        }
    }
    
    // MARK: - 懒加载
    private lazy var titleLabel = UILabel(textColor: UIColor.whiteColor(), font: UIFont.systemFontOfSize(22))

}



private class PhotoBrowserLayout: UICollectionViewFlowLayout
{
    private override func prepareLayout() {
        super.prepareLayout()
        
        // 1.设置layout
        itemSize = UIScreen.mainScreen().bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // 2.设置collectionView
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
    }
}
