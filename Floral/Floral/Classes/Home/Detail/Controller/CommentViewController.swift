//
//  CommentViewController.swift
//  Floral
//
//  Created by 孙林 on 16/5/29.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

private let CommentCellReuseIdentifier = "CommentCellReuseIdentifier"
class CommentViewController: UITableViewController, CommentViewCellDelegate, CommentBottomViewDelegate{

    var bbsID : String?
    
    // 评论列表
    var comments : [Comment]?
    {
        didSet{
            if let _ = comments {
                tipLabel.removeFromSuperview()
                tableView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        getList()
    }
   
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideBottomView()
        inputBottomView.removeFromSuperview()
    }
    
    /// 基本设置
    private func setup()
    {
        navigationItem.title = "评论"
        tableView.registerClass(CommentViewCell.self, forCellReuseIdentifier: CommentCellReuseIdentifier)
        tableView.separatorStyle = .None
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 200
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
        KeyWindow.addSubview(inputBottomView)
        inputBottomView.snp_makeConstraints { (make) in
            make.left.right.bottom.equalTo(KeyWindow)
            make.height.equalTo(44)
        }
        
    }
    
    
    /// 获取网络数据
    private func getList()
    {
        NetworkTool.sharedTools.getCommentList(["action":"getList", "bbsId":bbsID!, "currentPageIndex":"0", "pageSize":"10"]) {[unowned self] (comments, error, isNotComment) in
            if error != nil{
                self.showHint("网络异常", duration: 2.0, yOffset: 0)
            }else{
                if isNotComment{
                    self.view.addSubview(self.tipLabel)
                    self.tipLabel.snp_makeConstraints(closure: { (make) in
                        make.top.equalTo(60)
                        make.centerX.equalTo(self.view)
                    })
                }else{
                    self.comments = comments
                }
                
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let count = comments?.count ?? 0
        return count > 0 ? comments![indexPath.row].rowHeight : 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CommentCellReuseIdentifier, forIndexPath: indexPath) as! CommentViewCell
        let count = comments?.count ?? 0
        if count > 0 {
            cell.comment = comments![indexPath.row]
        }
        cell.delegate = self
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let comment = comments![indexPath.row]
        reply(comment)
    }
    
    // MARK: - CommentViewCellDelegate
    func commentViewCell(commentViewCell:CommentViewCell, didClickBtn type:CommentBtnType.RawValue,ReplyComment comment: Comment) {
        if type == CommentBtnType.More.rawValue {
            let action = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            action.addAction(UIAlertAction(title: "举报", style: .Default, handler: { (_) in
                self.showErrorMessage("举报成功")
                self.inputBottomView.hidden = false
            }))
            action.addAction(UIAlertAction(title: "拉黑", style: .Default, handler: { (_) in
                self.showErrorMessage("拉黑成功")
                self.inputBottomView.hidden = false
            }))
            action.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: { (_) in
                action.dismissViewControllerAnimated(true, completion: nil)
                self.inputBottomView.hidden = false
            }))
            // ActionSheet 弹起来的时候, 需要隐藏输入框
            inputBottomView.hidden = true
            presentViewController(action, animated: true, completion: nil)
        }else if(type == CommentBtnType.Reply.rawValue){
            reply(comment)
        }
    }
    
    // MARK: - CommentBottomViewDelegate
    func commentBottomView(commentBottomView: CommentBottomView, keyboradFrameChange userInfo: [NSObject : AnyObject]) {
        let rect : CGRect = userInfo["UIKeyboardFrameEndUserInfoKey"]!.CGRectValue()
        inputBottomView.snp_updateConstraints { (make) in
            make.bottom.equalTo(rect.origin.y-ScreenHeight)
        }
        UIView.animateWithDuration(0.25) {
            KeyWindow.layoutIfNeeded()
        }
        
        if rect.origin.y < ScreenHeight{ // 升起键盘
            KeyWindow.insertSubview(HUDView, belowSubview: inputBottomView)
            HUDView.snp_makeConstraints(closure: { (make) in
                make.top.equalTo(64)
                make.left.right.bottom.equalTo(KeyWindow)
            })
        }
        
    }
    
    func commentBottomView(commentBottomView: CommentBottomView, sendMessage message: String, replyComment comment: Comment?) {
        
        // 0. 键盘下去, 蒙版去掉
        hideBottomView()
        
        // 1. 防止当前没有任何评论, 需要初始化评论数组
        let count = comments?.count ?? 0
        if count < 1 {
            comments = [Comment]()
        }
        
        // 2. 显示结果
        if let com = comment {
            comments?.append(Comment.quickBuild(message, toUserName: com.writer!.userName))
            showHint("回复成功", duration: 2.0, yOffset: 0.0)
        }else{
            comments?.append(Comment.quickBuild(message, toUserName: nil))
            showHint("评论成功", duration: 2.0, yOffset: 0.0)
        }
        
        // 3. 刷新界面
        tableView.reloadData()
        
        // 4. 滑动到评论页
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.comments!.count - 1, inSection: 0), atScrollPosition: .None, animated: true)
        })
        
    }
    
    // MARK: - private method
    private func reply(comment: Comment)
    {
        inputBottomView.placeHolderStr = comment.anonymous ? "匿名用户" : comment.writer?.userName
        inputBottomView.comment = comment
    }
    
    @objc private func hideBottomView()
    {
        inputBottomView.endEditing(true)
        HUDView.removeFromSuperview()
    }
    
    // MARK: - 懒加载
    // 回复的视图
    private lazy var inputBottomView : CommentBottomView = {
        let comment = CommentBottomView()
        comment.delegete = self
        return comment
    }()
    
    // 没有任何评论的提醒label
    private lazy var tipLabel : UILabel = {
       let tip = UILabel(textColor: UIColor.lightGrayColor(), font: UIFont.systemFontOfSize(14))
        tip.text = "尚未发表任何评论"
        return tip
    }()
    
    // 蒙版
    private lazy var HUDView : UIView = {
        let hud = UIView()
        hud.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        hud.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CommentViewController.hideBottomView)))
        return hud
    }()
    
    deinit{
        ALinLog("----deinit....")
        hideBottomView()
        inputBottomView.removeFromSuperview()
    }
}
