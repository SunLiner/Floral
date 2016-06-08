//
//  ProtocolViewController.swift
//  Floral
//
//  Created by 孙林 on 16/5/5.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

class ProtocolViewController: UIViewController, UIWebViewDelegate {
    var HTM5Url : String?
    {
        didSet{
            if let url = HTM5Url {
                webView.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
            }
//            webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://m.htxq.net/servlet/SysContentServlet?action=getDetail&id=af50c0f4-d048-419b-a2de-47bb47fb99a5")!))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup()
    {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "close"), style: .Done, target: self, action: #selector(ProtocolViewController.dismiss))
        
//        navigationItem.title = "服务协议"
        view.addSubview(webView)
        webView.snp_makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        webView.delegate = self
    }
    
    // MARK : - 懒加载
    private lazy var webView = UIWebView()
    private lazy var HUD : MBProgressHUD = {
       let hud = MBProgressHUD()
        return hud
    }()
    
    // MARK: - 内部控制方法
    @objc  private func dismiss()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UIWebViewDelegate

    func webViewDidStartLoad(webView: UIWebView)
    {
        webView.addSubview(HUD)
        HUD.showAnimated(true)
    }
    
    func webViewDidFinishLoad(webView: UIWebView)
    {
        HUD.hideAnimated(true)
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?)
    {
        HUD.hideAnimated(true)
        showHint("网络异常", duration: 2, yOffset: 0)
    }
}
