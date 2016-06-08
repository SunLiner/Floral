//
//  NetworkTool.swift
//  Floral
//
//  Created by ALin on 16/4/26.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit
import Alamofire

// 每周Top10的action的枚举
enum TOP10Action : String {
    // 作者
    case TopArticleAuthor = "topArticleAuthor"
    // 专栏
    case TopContents = "topContents"
}

// 商城列表的identity的枚举
enum MallIdentity : String{
    case MallJingxuan = "jingList/1"
    case MallTheme = "theme"
}

class NetworkTool: Alamofire.Manager {
    // MARK: - 单例
    internal static let sharedTools: NetworkTool = {
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        var header : Dictionary =  Manager.defaultHTTPHeaders
        configuration.HTTPAdditionalHeaders = Manager.defaultHTTPHeaders
        return NetworkTool(configuration: configuration)
        
    }()
    
    // MARK: - 首页的数据请求
    /**
     获取所有的主题分类
     
     - parameter finished: 返回的block闭包
     */
    func getCategories(finished: (categories: [Category]?, error: NSError?)->()) {
        request(.GET, "http://m.htxq.net/servlet/SysCategoryServlet?action=getList", parameters: nil, encoding: .URL, headers: nil).responseJSON { (response) in
            if response.result.isSuccess{
                if let dictValue = response.result.value{
                    if let resultValue = dictValue["result"]{
                        var categories = [Category]()
                        for  dict in resultValue as! [[String : AnyObject]]
                        {
                            categories.append(Category(dict: dict))
                        }
                        finished(categories: categories, error: nil)
                        // 保存在本地
                        Category.savaCategories(categories)
                    }else{
                         finished(categories: nil, error: NSError.init(domain: "数据异常", code: 44, userInfo: nil))
                    }
                }else{
                    finished(categories: nil, error: NSError.init(domain: "服务器异常", code: 44, userInfo: nil))
                }
            }else{
                finished(categories: nil, error: response.result.error)
            }
        }
    }
    
    /**
     获取首页的文章列表
     
     - parameter paramters: 参数字典
        - 必传:currentPageIndex,pageSize(当currentPageIndex=0时,该参数无效, 但是必须传)
        - 根据情景传:  
            - isVideo	true (是否是获取视频列表)
            - cateId	a56aa5d0-aa6b-42b7-967d-59b77771e6eb(专题的类型, 不传的话是默认)
     - parameter finished:  回传的闭包
     */
    func getHomeList(paramters: [String : AnyObject]?, finished:(articles: [Article]?, error: NSError?, loadAll: Bool)->()) {
        request(.POST, "http://m.htxq.net/servlet/SysArticleServlet?action=mainList", parameters: paramters, encoding: .URL, headers: nil).responseJSON(queue: dispatch_get_main_queue(), options: .MutableContainers) { (response) in
            ALinLog(response.result.value)
            if response.result.isSuccess{
                if let value = response.result.value{
                    if (value["msg"] as! NSString).isEqualToString("已经到最后"){
                         finished(articles: nil, error: response.result.error, loadAll:true)
                    }
                    else if let result = value["result"]
                        {
                            var arcicles = [Article]()
                            for dict in result as! [[String:AnyObject]]
                            {
                                arcicles.append(Article(dict: dict))
                            }
                            finished(articles: arcicles, error: nil, loadAll:false)
                       
                    }
                }
            }else{
                finished(articles: nil, error: response.result.error, loadAll:false)
            }
        }
    }
    
    // MARK: - 每周TOP10的获取
    /**
     获取每周TOP10
     
     - parameter action:   具体获取"专栏"还是"作者"
     - parameter finished: 返回的block
     */
    func getTop10(action: TOP10Action, finished:(objs: [AnyObject]?, error: NSError?)->()) {
       request(.POST, "http://ec.htxq.net/servlet/SysArticleServlet?currentPageIndex=0&pageSize=10", parameters: ["action" : action.rawValue], encoding: .URLEncodedInURL, headers: nil).responseJSON { (response) in
            ALinLog(response.result.value)
            if let result = response.result.value{
                // 如果是作者
                if action.rawValue == TOP10Action.TopArticleAuthor.rawValue{
                    var authors = [Author]()
                    for dict in result["result"] as! [[String:AnyObject]]
                    {
                        authors.append(Author(dict: dict))
                    }
                    finished(objs: authors, error: nil)
                }else{ // 是专栏
                    var articles = [Article]()
                    for dict in result["result"] as! [[String:AnyObject]]
                    {
                        articles.append(Article(dict: dict))
                    }
                    finished(objs: articles, error: nil)
                }
            }else{
               finished(objs: nil, error: response.result.error)
            }
        }
    }
    
    // MARK: - 文章详情
    /**
     获取文章详情
     
     - parameter paramters: 参数
     - parameter finished:  返回的闭包
     */
    func getArticleDetail(paramters: [String : AnyObject]?, finished:(article: Article?, error: NSError?)->()) {
        request(.POST, "http://m.htxq.net/servlet/SysArticleServlet?action=getArticleDetail", parameters: paramters, encoding: .URL, headers: nil).responseJSON { (response) in
            if response.result.isSuccess{
                ALinLog(response.result.value)
                if let dictValue = response.result.value{
                    if let resultValue = dictValue["result"]{
                        finished(article: Article.init(dict: resultValue as! [String : AnyObject]), error: nil)
                    }else{
                      finished(article: nil , error: NSError(domain: "数据异常", code: 44, userInfo: nil))
                    }
                }else{
                   finished(article: nil , error: NSError(domain: "数据异常", code: 44, userInfo: nil))
                }
            }else{
                finished(article: nil , error: response.result.error)
            }
        }
    }
    
    /**
     获取评论列表
     
     - parameter parameters: 参数
     - parameter finished:   评论列表
     */
    func getCommentList(parameters:[String: AnyObject], finished:(comments:[Comment]?, error: NSError?, isNotComment: Bool)->()) {
        request(.POST, "http://m.htxq.net/servlet/UserCommentServlet", parameters: parameters, encoding: .URL, headers: nil).responseJSON(queue: dispatch_get_main_queue(), options: .MutableContainers) { (response) in
            if response.result.isSuccess{
                ALinLog(response.result.value)
                if response.result.value!["msg"] as! String == "还没有发布任何评论。"
                {
                    finished(comments: nil, error: nil, isNotComment: true)
                }else{
                    if let result = response.result.value!["result"]{
                        var comments = [Comment]()
                        for dict in result  as! [[String:AnyObject]]
                        {
                            comments.append(Comment(dict: dict))
                        }
                        finished(comments: comments, error: nil, isNotComment: false)
                    }else{
                        finished(comments: nil, error: NSError(domain: "服务器异常", code: 502, userInfo: nil), isNotComment: false)
                    }
                }
            }else{
                finished(comments: nil, error: response.result.error, isNotComment: false)
            }
        }
    }
    
    // MARK: -  商城相关网络请求
    /**
     获取商城的分类
     
     - parameter finished: 结果的闭包
     */
    func getMallsCategories(finished:(categories:[MallsCategory]?, error:NSError?)->()) {
        request(.GET, "http://ec.htxq.net/rest/htxq/item/tree", parameters: nil, encoding: .URL, headers: nil).responseJSON(queue: dispatch_get_main_queue(), options: NSJSONReadingOptions.MutableContainers) { (response) in
            if response.result.isSuccess{
                if let result = response.result.value!["result"]{
                    var categories = [MallsCategory]()
                    for dict in result as! [[String : AnyObject]]
                    {
                        categories.append(MallsCategory(dict: dict))
                    }
                    finished(categories: categories, error: nil)
                    // 保存在本地
                    MallsCategory.savaCategories(categories)
                }else{
                    finished(categories: nil , error: NSError(domain: "数据异常", code: 44, userInfo: nil))
                }
            }else{
               finished(categories: nil, error: response.result.error!)
            }
        }

    }
    
    /**
     获得置顶的商品
     
     - parameter finished: 回调的闭包
     */
    func getTopMalls(finished:(goods:ADS?, error:NSError?)->()) {
        request(.GET, "http://ec.htxq.net/rest/htxq/index/carousel", parameters: nil, encoding: .URL, headers: nil).responseJSON(queue: dispatch_get_main_queue(), options: NSJSONReadingOptions.MutableContainers) { (response) in
            ALinLog(response.result.value)
            if response.result.isSuccess
            {
                if let result = response.result.value!["result"]
                {
                    let dict = (result as! Array).first! as [String : AnyObject]
                    finished(goods: ADS(dict:dict), error: nil)
                }else{
                    finished(goods: nil, error: NSError(domain: "数据有误", code: 44, userInfo: nil))
                }
            }else{
                finished(goods: nil, error: response.result.error)
            }
        }
    }
    
    /**
     获取商城的商品列表(GET)
     
     - parameter identify:   标记符, 精选:jingList/1 商城:theme
     - parameter parameters: 参数
     - parameter finished:   回调的闭包
     */
    func getMalls(identify: MallIdentity, parameters: [String : AnyObject]?, finished:(objs:[AnyObject]?, error: NSError?)->()) {
        request(.GET, "http://ec.htxq.net/rest/htxq/index/" + identify.rawValue, parameters: parameters, encoding: .URL, headers: nil).responseJSON(queue: dispatch_get_main_queue(), options: NSJSONReadingOptions.MutableContainers) { (resopnse) in
            if resopnse.result.isSuccess{
                if let result = resopnse.result.value!["result"]
                {
                    if identify == MallIdentity.MallJingxuan // 精选返回一个数组(全部是商品)
                    {
                        var goodses = [Goods]()
                        for dict in result as! [[String : AnyObject]]
                        {
                            goodses.append(Goods(dict: dict))
                        }
                        finished(objs: goodses, error: nil)
                    }else{ // 商品返回了多个数组, 每个数组里面是商品
                        var mallsgoods = [MallsGoods]()
                        for dict in result as! [[String: AnyObject]]
                        {
                            mallsgoods.append(MallsGoods(dict: dict))
                        }
                        finished(objs: mallsgoods, error: nil)
                    }
                }else{
                   finished(objs: nil, error: NSError(domain: "数据异常", code: 44, userInfo: nil))
                }
            }else{
                finished(objs: nil, error: resopnse.result.error)
            }
        }
    }
    
    /**
     商场搜索(POST)
     参数:"fnName": "花"
     - parameter keyword:  搜索关键字
     - parameter finished: 返回的闭包
     */
    func search(keyword: String, finished:(goodlist:[Goods]?, error: NSError?)->()) {
        request(.POST, "http://ec.htxq.net/rest/htxq/goods/search", parameters: ["fnName": keyword], encoding: .JSON, headers: nil) // 这儿是个大坑啊!这儿的encoding转换格式不能是.URL, 服务器要求传一个JSON过去...
            .responseJSON(queue: dispatch_get_main_queue(), options: NSJSONReadingOptions.AllowFragments) { (response) in
                ALinLog(response.result.value)
            if response.result.isSuccess
            {
                if let result = response.result.value!["result"]
                {
                    if let goodResult = result!["result"] // 有数据返回
                    {
                        var goodlist = [Goods]()
                        for dict in goodResult as! [[String:AnyObject]]
                        {
                            goodlist.append(Goods(dict: dict))
                        }
                        finished(goodlist: goodlist, error: nil)
                    }else{ // 没有数据返回
                        finished(goodlist: nil, error: NSError(domain: "未知错误", code: 44, userInfo: nil))
                    }
                }else{
                    finished(goodlist: nil, error: NSError(domain: "请求格式错误", code: 415, userInfo: nil))
                }
            }else{
                finished(goodlist: nil, error: response.result.error)
            }
        }
    }
    
    /**
     选择商城的分类
     
     - parameter itemID: 分类id
     */
    func selectedCategory(itemID: String, finished:(goodsList:[Goods]?, error: NSError?)->()) {
        request(.GET, "http://ec.htxq.net/rest/htxq/goods/itemGoods", parameters: ["itemId" : itemID], encoding: .URL, headers: nil).responseJSON(queue: dispatch_get_main_queue(), options: NSJSONReadingOptions.MutableContainers) { (response) in
            if response.result.isSuccess
            {
                if let result = response.result.value!["result"]!!["result"]
                {
                    ALinLog(response.result.value)
                    var goodList = [Goods]()
                    for dict in result as! [[String : AnyObject]]
                    {
                        goodList.append(Goods(dict: dict))
                    }
                    finished(goodsList: goodList, error: nil)
                }else{
                    finished(goodsList: nil, error: NSError(domain: "数据错误", code: 44, userInfo: nil))
                }
            }else{
                finished(goodsList: nil, error: response.result.error)
            }
        }
    }
    
    /**
     获得商品详情
     
     - parameter goodsId: 商品id
     */
    func getGoodsInfo(goodsId: String, finished:(goods:Goods?, error: NSError?)->()) {
        request(.GET, "http://ec.htxq.net/rest/htxq/goods/detail/" + goodsId, parameters: nil, encoding: .URL, headers: nil).responseJSON(queue: dispatch_get_main_queue(), options: NSJSONReadingOptions.MutableContainers) { (response) in
            ALinLog(response.result.value)
            if response.result.isSuccess{
                if let result = response.result.value!["result"]{
                    if let goodsDic = result!["goods"]{
                        finished(goods: Goods(dict: goodsDic as! [String : AnyObject]), error: nil)
                    }else{
                        finished(goods: nil, error: NSError(domain: "数据异常", code: 44, userInfo: nil))
                    }
                }else{
                    finished(goods: nil, error: NSError(domain: "服务器异常", code: 502, userInfo: nil))
                }
            }else{
                finished(goods: nil, error: response.result.error)
            }
        }
    }
    
    /**
     获得订单详情
     http://ec.htxq.net/rest/htxq/goods/orderConfirm/041a470b-79ee-4c0b-b870-9356f15f6a8b/df277edb-a0c6-43fb-919a-cf2a9ac7e952
     前面是用户id(由于没有做登录, 所以id直接写死), 后面是商品id
     - parameter goodsId: 商品id
     */
    func getOlder(goodsId: String, finished:(goods:Goods?, error: NSError?)->()) {
        request(.GET, "http://ec.htxq.net/rest/htxq/goods/orderConfirm/041a470b-79ee-4c0b-b870-9356f15f6a8b/" + goodsId, parameters: nil, encoding: .URL, headers: nil).responseJSON(queue: dispatch_get_main_queue(), options: NSJSONReadingOptions.MutableContainers) { (response) in
            ALinLog(response.result.value)
            if response.result.isSuccess{
                if let result = response.result.value!["result"]{
                    finished(goods: Goods(dict: result as! [String : AnyObject]), error: nil)
                }else{
                    finished(goods: nil, error: NSError(domain: "服务器异常", code: 502, userInfo: nil))
                }
            }else{
                finished(goods: nil, error: response.result.error)
            }
        }

    }
    
    /**
     获取收货地址列表
     http://ec.htxq.net/rest/htxq/address/list/041a470b-79ee-4c0b-b870-9356f15f6a8b
     */
    func getAddressList(finished:(addresses : [Address]?, error: NSError?)->()) {
        request(.GET, "http://ec.htxq.net/rest/htxq/address/list/041a470b-79ee-4c0b-b870-9356f15f6a8b", parameters: nil, encoding: .URL, headers: nil).responseJSON { (response) in
            if response.result.isSuccess{
                if let result = response.result.value!["result"]
                {
                    var addresses = [Address]()
                    for dict in result as! [[String : AnyObject]]{
                        addresses.append(Address(dict: dict))
                    }
                    finished(addresses: addresses, error: nil)
                }
            }else{
                finished(addresses: nil, error: response.result.error)
            }
        }
    }
    
    /**
     删除地址
     
     - parameter addressID: 地址ID
     
     - returns: 是否删除成功
     */
    func deleteAddress(addressID: String, finished:(Bool)->()) {
        request(.GET, "http://ec.htxq.net/rest/htxq/address/delete/" + addressID, parameters: nil, encoding: .URL, headers: nil).responseJSON(queue: dispatch_get_main_queue(), options: []) { (response) in
            ALinLog(response.result.value)
            if response.result.isSuccess{
                if let msg = response.result.value!["msg"]{
                    if (msg as! NSString).isEqualToString("操作成功"){
                        finished(true)
                    }else{
                        finished(false)
                    }
                }else{
                    finished(false)
                }
            }else{
                finished(false)
            }
        }
    }
    
    /**
     设置默认的收货地址
     
     - parameter addressID: 地址id
     */
    func setDefaultAddress(addressID: String, finished:(Bool)->()) {
        request(.GET, "http://ec.htxq.net/rest/htxq/address/setDefault/041a470b-79ee-4c0b-b870-9356f15f6a8b/" + addressID, parameters: nil, encoding: .URL, headers: nil).responseJSON(queue: dispatch_get_main_queue(), options: []) { (response) in
            ALinLog(response.result.value)
            if response.result.isSuccess{
                if let msg = response.result.value!["msg"]{
                    if (msg as! NSString).isEqualToString("操作成功"){
                        finished(true)
                    }else{
                        finished(false)
                    }
                }else{
                    finished(false)
                }
            }else{
                finished(false)
            }
        }

    }
    
    /**
     新增/修改地址(同一个接口)
     
     - parameter parameters: 参数
     */
    func updateAddress(parameters:[String : AnyObject], finished:(status : Bool)->()) {
        request(.POST, "http://ec.htxq.net/rest/htxq/address/add", parameters: parameters, encoding: .JSON, headers: nil).responseJSON(queue: dispatch_get_main_queue(), options: []) { (response) in
            if response.result.isSuccess{
                if let msg = response.result.value!["msg"]{
                    if (msg as! NSString).isEqualToString("操作成功"){
                        finished(status: true)
                    }else{
                        finished(status: false)
                    }
                }else{
                    finished(status: false)
                }
            }else{
                finished(status: false)
            }
        }
    }
    
    // MARK: - profile相关网络请求
    // http://m.htxq.net/servlet/UserCenterServlet?action=getMyContents&currentPageIndex=1&pageSize=15&userId=4a3dab7f-1168-4a61-930c-f6bc0f989f32
    
    func columnistDetails(parameters:[String : AnyObject]?, finished:(articles: [Article]?, error: NSError?, loadAll: Bool)->()) {
        request(.GET, "http://m.htxq.net/servlet/UserCenterServlet?action=getMyContents&pageSize=15", parameters: parameters, encoding: .URL, headers: nil).responseJSON(queue: dispatch_get_main_queue(), options: NSJSONReadingOptions.MutableContainers) { (response) in
            ALinLog(response.result.value)
            if response.result.isSuccess{
                if let value = response.result.value{
                    if (value["msg"] as! NSString).isEqualToString("已经到最后"){
                        finished(articles: nil, error: response.result.error, loadAll:true)
                    }
                    else if let result = value["result"]
                    {
                        var arcicles = [Article]()
                        for dict in result as! [[String:AnyObject]]
                        {
                            arcicles.append(Article(dict: dict))
                        }
                        finished(articles: arcicles, error: nil, loadAll:false)
                        
                    }
                }
            }else{
                finished(articles: nil, error: response.result.error, loadAll:false)
            }
        }
    }
    
    /**
     获取用户详情
     
     - parameter userID:   用户id
     - parameter finished: 完成之后的回调
     */
    func getUserDetail(userID: String, finished:(author: Author?, error: NSError?)->()) {
        request(.GET, "http://m.htxq.net/servlet/UserCustomerServlet?action=getUserDetail", parameters: ["userId": userID], encoding: .URL, headers: nil).responseJSON(queue: dispatch_get_main_queue(), options: []) { (response) in
            if response.result.isSuccess
            {
                if let result = response.result.value!["result"]
                {
                    finished(author: Author(dict: result as! [String : AnyObject]), error: nil)
                }else{
                    finished(author: nil, error: NSError(domain: "数据异常", code: 44, userInfo: nil))
                }
            }else{
                finished(author: nil, error: response.result.error)
            }
        }
    }
}
