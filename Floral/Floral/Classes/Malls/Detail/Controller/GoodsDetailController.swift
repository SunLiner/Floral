//
//  GoodsDetailController.swift
//  Floral
//
//  Created by ALin on 16/5/26.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit
import Kingfisher

class GoodsDetailController: UIViewController, UIWebViewDelegate {

    var goodsId : String?
    {
        didSet{
            if let _ = goodsId {
                getGoodsInfo()
            }
        }
    }
    
    var goods : Goods?
    {
        didSet{
            if let g = goods {
                let H5Url = "http://m.htxq.net/shop/PGoodsAction/goodsDetail.do?goodsId=" + self.goodsId!
                self.detailWeb.loadRequest(NSURLRequest(URL: NSURL(string: H5Url)!))
                self.footer.goods = g
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        blur.removeFromSuperview()
    }
    
    private func getGoodsInfo()
    {
        NetworkTool.sharedTools.getGoodsInfo(goodsId!) { (goods, error) in
            if error != nil{
                self.showHint("网络异常", duration: 2.0, yOffset: 0)
            }else{
                self.goods = goods
            }
        }
    }
    
    private func setup()
    {
        view.addSubview(detailWeb)
        detailWeb.delegate = self
        view.addSubview(footer)
        detailWeb.backgroundColor = UIColor.init(gray: 241.0)
        
        footer.snp_makeConstraints { (make) in
            make.bottom.left.right.equalTo(view)
            make.height.equalTo(44)
        }
        
        detailWeb.snp_makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            make.bottom.equalTo(footer.snp_top)
        }
        
       navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ad_share"), style: .Done, target: self, action: #selector(GoodsDetailController.shareThread))
    }
    
    // MARK: - UIWebViewDelegate
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let urlstr = request.URL?.absoluteString
        let components : [String] = urlstr!.componentsSeparatedByString("::")
        if (components.count >= 1) {
            //判断是不是图片点击
            if (components[0] == "imageclick") {
                parentViewController?.presentViewController(ImageBrowserViewController(urls: [NSURL(string: components.last!)!], index: NSIndexPath(forItem: 0, inSection: 0)), animated: true, completion: nil)
                return false;
            }
            return true;
        }
        return true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        // 加载js文件
        webView.stringByEvaluatingJavaScriptFromString(try! String(contentsOfURL: NSBundle.mainBundle().URLForResource("image", withExtension: "js")!, encoding: NSUTF8StringEncoding))
        
        // 给图片绑定点击事件
        webView.stringByEvaluatingJavaScriptFromString("setImageClick()")
        
    }

    
    //MARK: - 懒加载
    /// 货品详情
    private lazy var detailWeb = UIWebView()
    /// 最底部
    private lazy var footer : DetailFooter = {
       let footer = DetailFooter()
        footer.clickBuyBlock = {
            let older = OrderViewController()
            older.olderID = self.goodsId
            self.navigationController?.pushViewController(older, animated: true)
        }
        return footer
    }()
    
    /// 分享视图
    private lazy var blur : ShareBlurView = {
        let blur = ShareBlurView(effect:  UIBlurEffect(style: .Dark))
        // 点击视图, 退出分享界面
        blur.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(GoodsDetailController.hideShareView)))
        blur.shareBlock = { type in
            ShareTool.sharedInstance.share(type, shareText: "我在#花田小憩#发现好东西啦! \(self.goods!.fnName!)冰点价: ¥ \(self.goods!.fnMarketPrice)", shareImage: Kingfisher.ImageCache.defaultCache.retrieveImageInDiskCacheForKey(self.goods!.fnAttachment!), shareUrl: "http://m.htxq.net/shop/PGoodsAction/goodsDetail.do?goodsId=" + self.goodsId!, handler: self, finished: {
                self.hideShareView()
            })
            
        }
        return blur
    }()

    
    // MARK: - 内部控制方法
    private var isShowShared = false
    // 分享
    func shareThread() {
        if !isShowShared {
            isShowShared = true
            KeyWindow.addSubview(blur)
            blur.snp_makeConstraints { (make) in
                make.top.equalTo(64)
                make.left.right.bottom.equalTo(KeyWindow)
            }
            blur.startAnim()
        }else{
            hideShareView()
        }
        
    }
    
    @objc private func hideShareView()
    {
        blur.endAnim()
        isShowShared = false
    }

}
