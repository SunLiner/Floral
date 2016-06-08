//
//  DetailWebViewCell.swift
//  Floral
//
//  Created by ALin on 16/4/27.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

// 详情页的webviewCell的高度改变的通知
let DetailWebViewCellHeightChangeNoti = "DetailWebViewCellHeightChangeNoti"
let DetailWebViewCellHeightKey = "DetailWebCellHeightKey"

class DetailWebViewCell: UITableViewCell, UIWebViewDelegate {
    var article : Article?
        {
        didSet{
            if let art = article {
                let H5Url = art.pageUrl ?? ("http://m.htxq.net//servlet/SysArticleServlet?action=preview&artId=" + art.id!)
                webView.loadRequest(NSURLRequest(URL: NSURL(string: H5Url)!))
                
            }
        }
    }
    
    // 父视图所在控制器
    weak var parentViewController : UIViewController?
    
    var cellHeigth : CGFloat = 0
    {
        didSet{
            if cellHeigth > 0  {
                isFinishLoad = true
                NSNotificationCenter.defaultCenter().postNotificationName(DetailWebViewCellHeightChangeNoti, object: nil, userInfo: [DetailWebViewCellHeightKey : Float(cellHeigth)])
            }  
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(webView)
//        webView.addSubview(HUD)
        
        webView.snp_makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // 浏览器
    private lazy var webView : UIWebView = {
       let web = UIWebView()
        web.scrollView.scrollEnabled = false
        web.delegate = self
        
//        let str = try! String(contentsOfURL: NSBundle.mainBundle().URLForResource("image", withExtension: "js")!, encoding: NSUTF8StringEncoding)
//        ALinLog(str)
        
        return web
    }()
    
//    private lazy var HUD: MBProgressHUD = {
//       let hud = MBProgressHUD()
//        hud.showAnimated(true)
//        return hud
//    }()
    
    
    // 是否加载完毕的flag
    private var isFinishLoad = false
    // MARK: - UIWebViewDelegate
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let urlstr = request.URL?.absoluteString
        let components : [String] = urlstr!.componentsSeparatedByString("::")
        if (components.count >= 1) {
            //判断是不是图片点击
            if (components[0] == "imageclick") {
//                let alert = UIAlertView.init(title: "提示", message: components.last, delegate: nil, cancelButtonTitle: "好的")
//                alert.show()
                
                // , NSURL(string: components.last!)!, NSURL(string: components.last!)!
                parentViewController?.presentViewController(ImageBrowserViewController(urls: [NSURL(string: components.last!)!], index: NSIndexPath(forItem: 0, inSection: 0)), animated: true, completion: nil)
                return false;
            }
            return true;
        }
        return true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
//        HUD.hideAnimated(true)
        // 加载js文件
        webView.stringByEvaluatingJavaScriptFromString(try! String(contentsOfURL: NSBundle.mainBundle().URLForResource("image", withExtension: "js")!, encoding: NSUTF8StringEncoding))
        
        // 给图片绑定点击事件
      webView.stringByEvaluatingJavaScriptFromString("setImageClick()")
        
        // 只需要获得scrollView.contentSize一次即可
        if !isFinishLoad && webView.scrollView.contentSize.height > 0{
            isFinishLoad = true
             cellHeigth = webView.scrollView.contentSize.height ?? 0.0
        }
    }
    

}
