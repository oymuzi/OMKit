//
//  ViewController.swift
//  OMKit
//
//  Created by 幸福的小木子 on 2018/10/26.
//  Copyright © 2018年 幸福的小木子. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var logoView: UIImageView!
    var logo: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.test()
//        self.navigationController?.pushViewController(OMViewController(), animated: true)
//        let vc = OMWebView.initWithURLString("https://mypup.cn")
//        self.navigationController?.pushViewController(vc, animated: true)

    }

    func test() {
        
        self.logo = UIView.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100))
        self.logo.backgroundColor = UIColor.cyan
        
//        self.logo.om_shadowRadius = 10
//        self.logo.om_shadowOffset = CGSize.zero
//        self.logo.om_shadowColor = UIColor.green
//        self.logo.om_shadowOpacity = 1
//        self.logo.om_cornerRadius = 50
//        self.logo.om_borderWidth = 1
//        self.logo.om_borderColor = UIColor.blue
//        self.logo.om_roundCorner = [.topLeft, .bottomRight]
        self.logo.om_addBlur(style: .dark, alpha: 0.8)
        
//        self.logo.layer.shadowColor = UIColor.green.cgColor
//        self.logo.layer.borderColor = UIColor.blue.cgColor//self.logo.layer.shadowColor
//        self.logo.layer.borderWidth = 1
//        self.logo.layer.cornerRadius = 50
//        self.logo.layer.shadowRadius = 10
//        self.logo.layer.shadowOpacity = 1
//        self.logo.layer.shadowOffset = CGSize.zero
        
        self.view.addSubview(logo)
        
//        self.logo.addBorder(width: 2, color: UIColor.red)
//        self.logo.clipRound()
        
//        let containerView = UIImageView.init(frame: logo.bounds)
//        containerView.layer.shadowColor = UIColor.red.cgColor
//        containerView.layer.shadowOffset = CGSize.init(width: -5, height: -5)
//        containerView.layer.shadowRadius = 15
//        containerView.layer.shadowOpacity = 0.2
//        view.addSubview(containerView)
//
//        let path = UIBezierPath.init(roundedRect: logo.bounds, byRoundingCorners: [UIRectCorner.topLeft], cornerRadii: CGSize(width: 50, height: 50))
//        let maskLayer = CAShapeLayer()
//        maskLayer.frame = logo.bounds
//        maskLayer.path = path.cgPath
//
//        /// 边框图层
//        let borderLayer = CAShapeLayer()
//        borderLayer.frame = logo.bounds
//        borderLayer.fillColor = UIColor.clear.cgColor
//        borderLayer.strokeColor = UIColor.purple.cgColor
//        borderLayer.lineCap = .round
//        borderLayer.lineWidth = 4
//        borderLayer.path = path.cgPath
//
//        logo.layer.insertSublayer(borderLayer, at: 0)
//        logo.layer.addSublayer(containerView.layer)
//        logo.addSubview(containerView)
//        logo.sendSubviewToBack(containerView)
//        logo.layer.mask = maskLayer
//        containerView.addSubview(logo)
//
//        logo = containerView
    }
    
//    func test() -> UIView {
//        
//    }
    
    func draw() {
        let context = UIBezierPath.init(roundedRect: logoView.bounds, byRoundingCorners: [UIRectCorner.topLeft, .topRight, .bottomRight, .bottomLeft], cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = logoView.bounds
        maskLayer.path = context.cgPath
        logoView.layer.mask = maskLayer
        
    }
    

    override func viewDidLayoutSubviews() {
//        logoView.center = CGPoint.init(x: 100, y: 300)
    }
    
}

