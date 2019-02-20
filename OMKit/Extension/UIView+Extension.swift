//
//  UIView+Extension.swift
//  OMKit
//
//  Created by 幸福的小木子 on 2018/10/26.
//  Copyright © 2018年 幸福的小木子. All rights reserved.
//

import UIKit

typealias ClicpRound = (_ radius: CGFloat) -> UIView

//@objc protocol UIViewProtocol {
//
//    @objc optional func clicpRound() -> UIView
//}
//
//extension UIView: UIViewProtocol {
//    func clicpRound() -> UIView {
//        <#code#>
//    }
//}

// MARK: - 为UIView增加属性
extension UIView {
    
//    var clicpRound: ClicpRound{
//        get{
//
//        }
//    }
    
    /// x轴起点
    var x: CGFloat {
        get{
            return self.frame.minX
        }
        set{
            var tempFrame = self.frame
            tempFrame.origin.x = newValue
            self.frame = tempFrame
        }
    }
    
    /// y轴起点
    var y: CGFloat {
        get{
            return self.frame.minY
        }
        set{
            var tempFrame = self.frame
            tempFrame.origin.y = newValue
            self.frame = tempFrame
        }
    }
    
    /// 宽
    var width: CGFloat {
        get{
            return self.frame.width
        }
        set{
            var tempFrame = self.frame
            tempFrame.size.width = newValue
            self.frame = tempFrame
        }
    }
    
    /// 高
    var height: CGFloat{
        get{
            return self.frame.width
        }
        set{
            var tempFrame = self.frame
            tempFrame.size.height = newValue
            self.frame = tempFrame
        }
    }
    
    /// 起始d点
    var origin: CGPoint{
        get{
            return self.frame.origin
        }
        set{
            var tempFrame = self.frame
            tempFrame.origin.x = newValue.x
            tempFrame.origin.y = newValue.y
            self.frame = tempFrame
        }
    }
}

// MARK: - 为UIView增加方法
extension UIView {
    
    
    // MARK: -圆角处理
    
    /// 为正方形视图添加圆角，当视图不为正方形的时候不进行处理，绘制圆角为正方形的内切圆
    func clipRound() {
        guard self.bounds.width == self.bounds.height else { return }
        let radius = self.bounds.width/2
        let path = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: [UIRectCorner.topLeft, .topRight, .bottomRight, .bottomLeft], cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    
    /// 为视图添加圆角
    ///
    /// - Parameter radius: 圆角弧度
    func clipRoundCorner(radius: CGFloat) {
        let path = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: [UIRectCorner.topLeft, .topRight, .bottomRight, .bottomLeft], cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    
    /// 为视图指定方位添加圆角
    ///
    /// - Parameters:
    ///   - byPosition: 指定方位
    ///   - radius: 圆角半径
    func clipRoundCorner(byPosition: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: byPosition, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    
    /// 为正方形视图添加圆角以及边框，当视图不为正方形的时候不进行处理，绘制圆角为正方形的内切圆
    /// - Parameter borderWidth: 边框的宽度
    ///   - borderColor: 边框颜色
    func clipRound(borderWidth: CGFloat, borderColor: UIColor) {
        guard self.bounds.width == self.bounds.height else { return }
        let radius = self.bounds.width/2
        let path = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: [UIRectCorner.topLeft, .topRight, .bottomRight, .bottomLeft], cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        
        /// 边框图层
        let borderLayer = CAShapeLayer()
        borderLayer.frame = self.bounds
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineCap = .round
        borderLayer.lineWidth = borderWidth
        borderLayer.path = path.cgPath
        
        self.layer.insertSublayer(borderLayer, at: 0)
        self.layer.mask = maskLayer
    }
    
    /// 为视图添加圆角以及边框
    ///
    /// - Parameter radius: 圆角弧度
    ///   - borderWidth: 边框的宽度
    ///   - borderColor: 边框颜色
    func clipRoundCorner(radius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        let path = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: [UIRectCorner.topLeft, .topRight, .bottomRight, .bottomLeft], cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        
        /// 边框图层
        let borderLayer = CAShapeLayer()
        borderLayer.frame = self.bounds
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineCap = .round
        borderLayer.lineWidth = borderWidth
        borderLayer.path = path.cgPath
        
        self.layer.insertSublayer(borderLayer, at: 0)
        self.layer.mask = maskLayer
    }
    
    /// 为视图指定方位添加圆角以及边框
    ///
    /// - Parameters:
    ///   - byPosition: 指定方位
    ///   - radius: 圆角半径
    ///   - borderWidth: 边框的宽度
    ///   - borderColor: 边框颜色
    func clipRoundCorner(byPosition: UIRectCorner, radius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        let path = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: byPosition, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        
        /// 边框图层
        let borderLayer = CAShapeLayer()
        borderLayer.frame = self.bounds
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineCap = .round
        borderLayer.lineWidth = borderWidth
        borderLayer.path = path.cgPath
        
        self.layer.insertSublayer(borderLayer, at: 0)
        self.layer.mask = maskLayer
    }
    
    // MARK: -添加视图效果
    
    /// 添加毛玻璃效果
    ///
    /// - Parameters:
    ///   - style: 毛玻璃风格
    ///   - alpha: 透明度
    func addBlur(style: UIBlurEffect.Style, alpha: CGFloat) {
        let blurEffect = UIBlurEffect.init(style: style)
        let blurView = UIVisualEffectView.init(effect: blurEffect)
        blurView.frame = self.bounds
        blurView.alpha = alpha
        self.addSubview(blurView)
    }
    
    
    
    /// 添加阴影效果
    ///
    /// - Parameters:
    ///   - offset: 阴影偏移，系统默认的偏移值为：（0，-3）
    ///   - color: 阴影颜色
    ///   - radius: 阴影的半径
    ///   - opacity: 阴影的透明度
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        self.layer.shouldRasterize = true
        guard self.layer.sublayers != nil else {
            
            layer.shadowOpacity = opacity
            layer.shadowRadius = radius
            layer.shadowOffset = offset
            layer.shadowColor = color.cgColor
            layer.masksToBounds = false
          
            return
        }
        let containerView = UIView.init(frame: self.bounds)
        containerView.layer.shadowColor = color.cgColor
        containerView.layer.shadowOffset = CGSize.init(width: -5, height: -5)
        containerView.layer.shadowRadius = 15
        containerView.layer.shadowOpacity = 0.2
        containerView.addSubview(self)
//        self = containerView
        
        for subLayer in self.layer.sublayers! {
            if subLayer.isKind(of: CAShapeLayer.self) {
                print("FIND:", subLayer)
                let shadowLayer = subLayer as! CAShapeLayer
//                layer.shadowColor = color.cgColor
//                layer.shadowOffset = offset
//                layer.shadowRadius = radius
//                layer.shadowOpacity = opacity
//                layer.borderWidth = layer.borderWidth == 0 ? 0.00001:layer.borderWidth
//                self.layer.mask = layer
//                let shadowView = UIView.init(frame: self.bounds)
                layer.shadowColor = color.cgColor
                layer.shadowOffset = offset
                layer.shadowRadius = radius
                layer.shadowOpacity = opacity
                layer.masksToBounds = false
                layer.shadowPath = shadowLayer.path
                
//                shadowView.layer.shadowOpacity = opacity
//                shadowView.layer.shadowRadius = radius
//                shadowView.layer.shadowOffset = offset
//                shadowView.layer.shadowColor = color.cgColor
//                shadowView.layer.masksToBounds = false
//                self.addSubview(shadowView)
//                self.layer.addSublayer(shadowView.layer)
            }
        }
    }
    
    /// 添加边框
    ///
    /// - Parameters:
    ///   - width: 边框宽度
    ///   - color: 边框颜色
    func addBorder(width: CGFloat, color: UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.layer.shouldRasterize = true
    }
    
    // MARK: -视图截屏
    
    /// 对视图进行截屏处理
    ///
    /// - Returns: 返回视图截屏的结果图像
    func capture() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, UIScreen.main.scale)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let shotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return shotImage
    }
    
}
