//
//  UIView+Extension.swift
//  OMKit
//
//  Created by 幸福的小木子 on 2018/10/26.
//  Copyright © 2018年 幸福的小木子. All rights reserved.
//

import UIKit
import WebKit

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

private let kScreenScale = UIScreen.main.scale
private let kScreenWidth = UIScreen.main.bounds.width
private let kScreenHeight = UIScreen.main.bounds.height

// MARK: - 基础元素属性
extension UIView {
    
//    var clicpRound: ClicpRound{
//        get{
//
//        }
//    }
    
    /** 对浮点数取整*/
    private func om_pixelIntegerValue(with pointValue: CGFloat) -> CGFloat {
        return round((pointValue * kScreenScale) / kScreenScale)
    }
    
    /// x轴起点
    var om_x: CGFloat {
        get{
            return self.frame.minX
        }
        set{
            var tempFrame = self.frame
            tempFrame.origin.x = om_pixelIntegerValue(with: newValue)
            self.frame = tempFrame
        }
    }
    
    /// y轴起点
    var om_y: CGFloat {
        get{
            return self.frame.minY
        }
        set{
            var tempFrame = self.frame
            tempFrame.origin.y = om_pixelIntegerValue(with: newValue)
            self.frame = tempFrame
        }
    }
    
    /// 宽
    var om_width: CGFloat {
        get{
            return self.frame.width
        }
        set{
            var tempFrame = self.frame
            tempFrame.size.width = om_pixelIntegerValue(with: newValue)
            self.frame = tempFrame
        }
    }
    
    /// 高
    var om_height: CGFloat{
        get{
            return self.frame.width
        }
        set{
            var tempFrame = self.frame
            tempFrame.size.height = om_pixelIntegerValue(with: newValue)
            self.frame = tempFrame
        }
    }
    
    /// 起始d点
    var om_origin: CGPoint{
        get{
            return self.frame.origin
        }
        set{
            var tempFrame = self.frame
            tempFrame.origin.x = om_pixelIntegerValue(with: newValue.x)
            tempFrame.origin.y = om_pixelIntegerValue(with: newValue.y)
            self.frame = tempFrame
        }
    }
    
    /** 尺寸*/
    var om_size: CGSize{
        get{
            return self.frame.size
        }
        set{
            var tempFrame = self.frame
            tempFrame.size.width = om_pixelIntegerValue(with: newValue.width)
            tempFrame.size.height = om_pixelIntegerValue(with: newValue.height)
            self.frame = tempFrame
        }
    }
    
    /** 中心点x*/
    var om_centerX: CGFloat{
        get{
            return self.center.x
        }
        set{
            self.center.x = om_pixelIntegerValue(with: newValue)
        }
    }
    
    /** 中心点y*/
    var om_centerY: CGFloat{
        get{
            return self.center.y
        }
        set{
            self.center.y = om_pixelIntegerValue(with: newValue)
        }
    }
    
    /** 中心点*/
    var om_center: CGPoint{
        get{
            return self.center
        }
        set{
            self.center = CGPoint.init(x: om_pixelIntegerValue(with: newValue.x), y: om_pixelIntegerValue(with: newValue.y))
        }
    }
    
    /** 视图右边值*/
    var om_right: CGFloat {
        get{
            return om_x + om_width
        }
        set{
            om_x = newValue - om_width
        }
    }
    
    /** 视图底部值*/
    var om_bottom: CGFloat {
        get{
            return om_y + om_height
        }
        set{
            om_y = newValue - om_height
        }
    }
    
}

private var UIViewKey_CAPTURING = "om_uiview_capturing"

// MARK: - 截图-对当前视图进行快照
extension UIView{
//    public func snapshot
    
    /** 是否正在截屏*/
    public var isCapturing: Bool {
        get{
            guard let value = objc_getAssociatedObject(self, &UIViewKey_CAPTURING) else {
                return false
            }
            guard let boolValue = value as? Bool else {
                return false
            }
            return boolValue
        }
        set{
            objc_setAssociatedObject(self, &UIViewKey_CAPTURING, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /**  是否包含了WKWebView*/
    private func isCaontainWKWebView() -> Bool {
        if self.isKind(of: WKWebView.self){
            return true
        } else {
            for view in self.subviews {
                return view.isCaontainWKWebView()
            }
        }
        return false
    }
    
    /** 快照回调*/
    public typealias OMCaptureCompletion = (UIImage?) -> Void
    
    /// 对视图进行快照
    ///
    /// - Parameter completion: 回调
    public func om_captureCurrentWihCompletion(_ completion: OMCaptureCompletion) {
        self.isCapturing = true
        let captureFrame = self.bounds
        
        UIGraphicsBeginImageContextWithOptions(captureFrame.size, true, kScreenScale)
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        context?.translateBy(x: -om_x, y: -om_y)
        
        if self.isCaontainWKWebView(){
            self.drawHierarchy(in: bounds, afterScreenUpdates: true)
        } else {
            self.layer.render(in: context!)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        context?.restoreGState()
        UIGraphicsEndImageContext()
        self.isCapturing = false
        completion(image)
    }
    
}

private var UIVIEWKEY_SHADOWOPACITY = "om_uiview_shadowOpacity"
private var UIVIEWKEY_SHADOWCOLOR   = "om_uiview_shadowColor"
private var UIVIEWKEY_SHADOWOFFSET  = "om_uiview_shadowOffset"
private var UIVIEWKEY_SHADOWRADIUS  = "om_uiview_shadowRadius"
private var UIVIEWKEY_CORNERRADIUS  = "om_uiview_shadowCornerRadius"
private var UIVIEWKEY_BORDERCOLOR   = "om_uiview_shadowBorderColor"
private var UIVIEWKEY_BORDERWIDTH   = "om_uiview_shadowBorderWidth"
private var UIVIEWKEY_ROUNDCORNERS  = "om_uiview_roundCorners"

// MARK: - 圆角、阴影、边框设置、毛玻璃方法
@IBDesignable
extension UIView {
    
    /** 阴影不透明度*/
    @IBInspectable
    public var om_shadowOpacity: Float {
        get{
            guard let value = objc_getAssociatedObject(self, &UIVIEWKEY_SHADOWOPACITY) else {
                return 0;
            }
            guard let opacity = value as? Float else {
                return 0;
            }
            return opacity
        }
        set{
            objc_setAssociatedObject(self, &UIVIEWKEY_SHADOWOPACITY, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.layer.shadowOpacity = newValue
        }
    }
    
    /** 阴影颜色*/
    @IBInspectable
    public var om_shadowColor: UIColor? {
        get{
            guard let value = objc_getAssociatedObject(self, &UIVIEWKEY_SHADOWCOLOR) else {
                return nil;
            }
            guard let shadowColor = value as? UIColor else {
                return nil;
            }
            return shadowColor
        }
        set{
            objc_setAssociatedObject(self, &UIVIEWKEY_SHADOWCOLOR, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    
    /** 阴影偏移*/
    @IBInspectable
    public var om_shadowOffset: CGSize {
        get{
            guard let value = objc_getAssociatedObject(self, &UIVIEWKEY_SHADOWOFFSET) else {
                return CGSize.zero
            }
            guard let shadowOffset = value as? CGSize else {
                return CGSize.zero
            }
            return shadowOffset
        }
        set{
            objc_setAssociatedObject(self, &UIVIEWKEY_SHADOWOFFSET, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.layer.shadowOffset = newValue
        }
    }
    
    /** 阴影弧度*/
    @IBInspectable
    public var om_shadowRadius: CGFloat {
        get{
            guard let value = objc_getAssociatedObject(self, &UIVIEWKEY_SHADOWRADIUS) else {
                return 0
            }
            guard let shadowRadius = value as? CGFloat else {
                return 0
            }
            return shadowRadius
        }
        set{
            objc_setAssociatedObject(self, &UIVIEWKEY_SHADOWRADIUS, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.layer.shadowRadius = newValue
        }
    }
    
    /** 圆角弧度*/
    @IBInspectable
    public var om_cornerRadius: CGFloat {
        get{
            guard let value = objc_getAssociatedObject(self, &UIVIEWKEY_CORNERRADIUS) else {
                return 0
            }
            guard let cornerRadius = value as? CGFloat else {
                return 0
            }
            return cornerRadius
        }
        set{
            objc_setAssociatedObject(self, &UIVIEWKEY_CORNERRADIUS, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.layer.cornerRadius = newValue
        }
    }
    
    /** 边框颜色*/
    @IBInspectable
    public var om_borderColor: UIColor? {
        get{
            guard let value = objc_getAssociatedObject(self, &UIVIEWKEY_BORDERCOLOR) else {
                return nil;
            }
            guard let borderColor = value as? UIColor else {
                return nil;
            }
            return borderColor
        }
        set{
            objc_setAssociatedObject(self, &UIVIEWKEY_BORDERCOLOR, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    /** 边框宽度*/
    @IBInspectable
    public var om_borderWidth: CGFloat {
        get{
            guard let value = objc_getAssociatedObject(self, &UIVIEWKEY_BORDERWIDTH) else {
                return 0.000001;
            }
            guard let borderWidth = value as? CGFloat else {
                return 0.000001;
            }
            return borderWidth
        }
        set{
            let borderWidth: CGFloat = newValue < 0.000001 ? 0.000001 : newValue
            objc_setAssociatedObject(self, &UIVIEWKEY_BORDERWIDTH, borderWidth , .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.layer.borderWidth = newValue
        }
    }
    
    /** 需要处理的圆角，默认四个角都处理*/
    public var om_roundCorner: UIRectCorner{
        get{
            guard let value = objc_getAssociatedObject(self, &UIVIEWKEY_ROUNDCORNERS) else {
                return .allCorners
            }
            guard let corners = value as? UIRectCorner else {
                return .allCorners
            }
            return corners
        }
        set{
            objc_setAssociatedObject(self, &UIVIEWKEY_ROUNDCORNERS, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.layer.masksToBounds = false
            
            let cornerLayer = CAShapeLayer()
            cornerLayer.frame = self.bounds
            cornerLayer.backgroundColor = self.backgroundColor?.cgColor
            
            
            let cornerRadius = om_cornerRadius > 0 ? om_cornerRadius : 0
            let path = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: newValue, cornerRadii: CGSize.init(width: cornerRadius, height: cornerRadius))
            let shapeLayer = CAShapeLayer.init()
            shapeLayer.path = path.cgPath
            cornerLayer.mask = shapeLayer
            
            self.layer.addSublayer(cornerLayer)
        }
    }
    
    /// 使用方法添加圆角、边框、阴影样式, 不需要的属性，设置为nil即可
    ///
    /// - Parameters:
    ///   - cornerRadius: 圆角弧度半径
    ///   - corners: 需要处理圆角的方向
    ///   - borderWidth: 边框宽度
    ///   - borderColor: 边框颜色
    ///   - shadowRadius: 阴影弧度半径
    ///   - shadowOffset: 阴影偏移
    ///   - shadowOpacity: 阴影的不透明度
    ///   - shadowColor: 阴影颜色
    public func om_addStyleWith(cornerRadius: CGFloat?, corners: UIRectCorner?, borderWidth: CGFloat?, borderColor: UIColor?, shadowRadius: CGFloat?, shadowOffset: CGSize?, shadowOpacity: Float?, shadowColor: UIColor?){
        if let kCornerRadius = cornerRadius {
            self.om_cornerRadius = kCornerRadius
        }
        if let kCorners = corners {
            self.om_roundCorner = kCorners
        }
        if let kBorderWidth = borderWidth {
            self.om_borderWidth = kBorderWidth
        } else {
            self.om_borderWidth = 0
        }
        if let kBorderColor = borderColor {
            self.om_borderColor = kBorderColor
        }
        if let kShadowRadius = shadowRadius {
            self.om_shadowRadius = kShadowRadius
        }
        if let kShadowColor = shadowColor {
            self.om_shadowColor = kShadowColor
        }
        if let kShadowOffset = shadowOffset {
            self.om_shadowOffset = kShadowOffset
        }
        if let kShadowOpacity = shadowOpacity {
            self.om_shadowOpacity = kShadowOpacity
        }
    }
    
    /// 添加毛玻璃效果
    ///
    /// - Parameters:
    ///   - style: 毛玻璃风格
    ///   - alpha: 透明度
    func om_addBlur(style: UIBlurEffect.Style, alpha: CGFloat) {
        let blurEffect = UIBlurEffect.init(style: style)
        let blurView = UIVisualEffectView.init(effect: blurEffect)
        blurView.frame = self.bounds
        blurView.alpha = alpha
        self.addSubview(blurView)
    }
    
}
