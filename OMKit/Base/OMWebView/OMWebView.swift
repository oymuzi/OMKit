//
//  OMWebView.swift
//  OMKit
//
//  Created by oymuzi on 2019/2/20.
//  Copyright © 2019年 幸福的小木子. All rights reserved.
//

import UIKit
import WebKit

/** 防止添加js方法时引起的内存泄漏*/
class OMWebViewScriptMessageHanlder: NSObject, WKScriptMessageHandler {
    
    weak var delegate: WKScriptMessageHandler?
    
    init(delegate: WKScriptMessageHandler?) {
        self.delegate = delegate
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        self.delegate?.userContentController(userContentController, didReceive: message)
    }
}


@objc protocol OMWebViewDelegate: NSObjectProtocol{
    
    /** JS交互时JS调用原生方法时收到的消息，以及内容*/
    @objc optional func runJavaScriptReceiveMessage(message: WKScriptMessage)
    
}

class OMWebView: UIViewController, WKScriptMessageHandler {
    
    /** 网页视图*/
    public var webView: WKWebView!
    /** 代理*/
    public weak var delegate: OMWebViewDelegate?
    /** JS交互时JS调用原生方法时收到的消息，以及内容*/
    public var runJavaScriptReceiveMessageBlock: ((WKScriptMessage) -> Void)?
    /** 自动改变标题，根据url的标题*/
    public var autoChangeTitle: Bool = true
    
    private var userContentcontroller: WKUserContentController!
    /** 网页来源标记标签*/
    private var memoLabel: UILabel!
    /** 进度条*/
    private var progressView: UIProgressView!
    /** 容器视图*/
    private var containerView: UIScrollView!
    /** js交互的方法名集合*/
    private var scriptMessageHandlerNames = [String]()
    /** 当前网页加载地址*/
    private var urlString: String = ""
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        self.setupUI()
        self.checkURL()
    }
    
    static func initWithURLString(_ urlString: String) -> OMWebView{
        let webView = OMWebView()
        webView.urlString = urlString
//        if let url = URL.init(string: urlString){
//            webView.setWebviewMemo(url.host ?? "")
//        }
        return webView
    }
    
    public func addJavaScriptFunctionName(_ name: String){
        let messageHandler = OMWebViewScriptMessageHanlder.init(delegate: self)
        self.scriptMessageHandlerNames.append(name)
        self.userContentcontroller.add(messageHandler, name: name)
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        self.delegate?.runJavaScriptReceiveMessage?(message: message)
        self.runJavaScriptReceiveMessageBlock?(message)
    }
    
    deinit {
        /** 移除js方法，防止内存泄漏*/
        for script in self.scriptMessageHandlerNames {
            self.webView.configuration.userContentController.removeScriptMessageHandler(forName: script)
        }
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    private func setupUI(){
        
        
        containerView = UIScrollView.init(frame: self.view.bounds)
        containerView.backgroundColor = UIColor.init(white: 0.98, alpha: 1)
        containerView.showsVerticalScrollIndicator = false
        containerView.showsHorizontalScrollIndicator = false
        containerView.isScrollEnabled = false
        self.view.addSubview(containerView)
        
        
        let configuration = WKWebViewConfiguration.init()
        configuration.allowsAirPlayForMediaPlayback = true
        configuration.allowsInlineMediaPlayback = true
        configuration.allowsPictureInPictureMediaPlayback = true
        self.userContentcontroller = WKUserContentController.init()
        configuration.userContentController = self.userContentcontroller
        self.webView = WKWebView.init(frame: self.view.bounds, configuration: configuration)
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.webView.isExclusiveTouch = false
        self.webView.scrollView.delegate = self
        self.webView.scrollView.zoomScale = 1.0
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.containerView.addSubview(self.webView)
        
        self.memoLabel = UILabel.init(frame: CGRect.init(x: 0, y: 20, width: view.frame.width, height: 20))
        self.memoLabel.textAlignment = .center
        self.memoLabel.font = UIFont.systemFont(ofSize: 12)
        self.memoLabel.textColor = UIColor.gray
        self.memoLabel.alpha = 0.00//1.00
        containerView.addSubview(self.memoLabel)
        
        progressView = UIProgressView.init(frame: CGRect.init(x: 0, y: 0, width: view.frame.width, height: 3))
        progressView.backgroundColor = UIColor.clear
        progressView.trackTintColor = UIColor.clear
        progressView.progressTintColor = UIColor.blue.withAlphaComponent(0.5)
        self.containerView.addSubview(progressView)
        progressView.alpha = 0.0
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            progressView.alpha = 1.0
            progressView.setProgress(Float(self.webView.estimatedProgress), animated: true)
            if self.webView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.progressView.alpha = 0.0
                }) { [weak self] (finished) in
                    guard let strongSelf = self else { return }
                    strongSelf.progressView.setProgress(0, animated: false)
                }
            }
        }
    }
    
    private func setWebviewMemo(_ memo: String?){
        guard let promtMessage = memo, promtMessage.count > 0 else { return }
        self.memoLabel.text = "此网页由 "+promtMessage+" 提供"
    }
    
    private func checkURL(){
        guard self.urlString.count > 0  else { return }
        guard let url = URL.init(string: urlString) else { return }
        if self.webView.isLoading  {
            self.webView.stopLoading()
        }
        let urlRequest = URLRequest.init(url: url)
        self.webView.load(urlRequest)
    }
    
    func addSwipeGesture(){
        let swipeGesture = UIPanGestureRecognizer.init(target: self, action: #selector(swipe(recognizer:)))
        
    }
    
    @objc private func swipe(recognizer: UIPanGestureRecognizer){
       
    }

}

extension OMWebView: WKNavigationDelegate, WKUIDelegate{
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.setWebviewMemo(webView.url?.host)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if self.autoChangeTitle {
            self.title = webView.title
        }
    }
}

extension OMWebView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if offset < 0 {
            if fabsf(Float(offset)) > 50 {
                let alpha = (fabsf(Float(offset)) - 50) / 100.00
                if alpha >= 1.00 {
                    self.memoLabel.alpha = 1.00
                } else {
                    self.memoLabel.alpha = CGFloat(alpha)
                }
            } else {
                self.memoLabel.alpha = 0.0
            }
        } else {
            self.memoLabel.alpha = 0.0
        }
//        if offset < 0 {
//            self.webView.frame.origin.y = CGFloat(fabsf(Float(offset)))
//            if fabsf(Float(offset)) > 50 {
//                let alpha = (fabsf(Float(offset)) - 50) / 100.00
//                if alpha >= 1.00 {
//                    self.memoLabel.alpha = 1.00
//                } else {
//                    self.memoLabel.alpha = CGFloat(alpha)
//                }
//            } else {
//                self.memoLabel.alpha = 0.0
//            }
//        } else {
//        }

    }
}
