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
    var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationController?.pushViewController(OMCoreDataManagerDemoViewController(), animated: true)
    }

    func test() {
        let containerView = UIImageView.init(frame: logo.bounds)
        containerView.layer.shadowColor = UIColor.red.cgColor
        containerView.layer.shadowOffset = CGSize.init(width: -5, height: -5)
        containerView.layer.shadowRadius = 15
        containerView.layer.shadowOpacity = 0.2
//        view.addSubview(containerView)
        
        let path = UIBezierPath.init(roundedRect: logo.bounds, byRoundingCorners: [UIRectCorner.topLeft], cornerRadii: CGSize(width: 50, height: 50))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = logo.bounds
        maskLayer.path = path.cgPath
        
        /// 边框图层
        let borderLayer = CAShapeLayer()
        borderLayer.frame = logo.bounds
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.purple.cgColor
        borderLayer.lineCap = .round
        borderLayer.lineWidth = 4
        borderLayer.path = path.cgPath
        
        logo.layer.insertSublayer(borderLayer, at: 0)
//        logo.layer.addSublayer(containerView.layer)
//        logo.addSubview(containerView)
//        logo.sendSubviewToBack(containerView)
        logo.layer.mask = maskLayer
        containerView.addSubview(logo)
        
        logo = containerView
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

