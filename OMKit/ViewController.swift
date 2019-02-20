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
    
    var records = [OMChargeRecord]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let manager = OMCoreDataManager.init(databaseName: "OMCoreData")
        let record: OMChargeRecord = manager.createObject(entityName: "OMChargeRecord")
        record.profile = nil
        record.amount = 8888.888
        record.desc = "卖菜VIP"
        record.time = 201988888888
        record.type = 0
        
        manager.save { (isSuccess, error) in
            print("保存成功：\(isSuccess), error: \(error)")
        }
        
        manager.query(tableName: "OMChargeRecord", predicate: nil, sortDescriptor: nil, limit: 0) { (isSuccess, results, error) in
            let res: Array<OMChargeRecord> = results as! Array<OMChargeRecord>
            print("查询成功？:\(isSuccess), error: \(error)")
            for object in res{
                self.records.append(object)
            }
        }
        for object in self.records {
            print("ctime: \(object.time)  amount: \(object.amount)  desc: \(object.desc)  type: \(object.type) profile: \((object.profile)?.description) isUpload: \(object.isUpload), arc: \(object.arc)")
        }
//
//        let originalImage = UIImage.init(named: "avatar.jpg")!
//        let arcImage = originalImage.OM.clicpArc(radius: 20)
//        logoView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
//        print(originalImage, arcImage)
//        logoView.image = arcImage
//
//        logoView.backgroundColor = UIColor.red
//        view.addSubview(logoView)
////        draw()
//
//        logo = UIImageView.init(frame: CGRect.init(x: 100, y: 400, width: 200, height: 200))
//        logo.backgroundColor = UIColor.green
//        _ = logo.addShadow(offset: CGSize.init(width: 5, height: 5), color: UIColor.red, radius: 15, opacity: 0.5)
////        logo.clipRoundAndBorder(width: 20, color: UIColor.red)
//
////        logo.clipRoundCorner(byPosition: UIRectCorner.topLeft, radius: 100, borderWidth: 20, borderColor: UIColor.gray)
////        logo.addShadow(offset: CGSize.init(width: -30, height: -36), color: UIColor.red, radius: 10, opacity: 0.6)
////        logo.addBorder(width: 3, color: UIColor.red)
////        logo.clipRound()
//        view.addSubview(logo)
////        test()
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
        logoView.center = CGPoint.init(x: 100, y: 300)
    }
    
}

