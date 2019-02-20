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

class OMWebView: UIViewController, WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate {
    
    /** 网页视图*/
    public var webView: WKWebView!
    /** 代理*/
    public weak var delegate: OMWebViewDelegate?
    /** JS交互时JS调用原生方法时收到的消息，以及内容*/
    public var runJavaScriptReceiveMessageBlock: ((WKScriptMessage) -> Void)?
    
    private var userContentcontroller: WKUserContentController!
    /** js交互的方法名集合*/
    private var scriptMessageHandlerNames = [String]()
    /** 当前网页加载地址*/
    private var urlString: String = ""
    
    override func viewDidLoad() {
        <#code#>
    }
    
    static func initWithURLString(_ urlString: String) -> OMWebView{
        let webView = OMWebView()
        webView.urlString = urlString
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
    }
    
    private func setupUI(){
        let configuration = WKWebViewConfiguration.init()
        configuration.allowsAirPlayForMediaPlayback = true
        configuration.allowsInlineMediaPlayback = true
        configuration.allowsPictureInPictureMediaPlayback = true
        self.userContentcontroller = WKUserContentController.init()
        configuration.userContentController = self.userContentcontroller
        self.webView = WKWebView.init(frame: self.view.bounds, configuration: configuration)
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.view.addSubview(self.webView!)
    }

}
