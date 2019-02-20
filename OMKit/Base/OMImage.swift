//
//  OMImage.swift
//  OMKit
//
//  Created by 幸福的小木子 on 2018/10/26.
//  Copyright © 2018年 幸福的小木子. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    var OM: OMImage {
        return OMImage()
    }
    
}

/// 图片库
class OMImage: UIImage {
    
    
    // MARK: -静态方法
    
    /// 获取来自本地图片的额外信息
    ///
    /// - Parameter fileURLWithPath: 本地图片url
    /// - Returns: 额外信息
    static func info(fileURLWithPath: String) -> NSDictionary? {
        let imageURL: CFURL = URL.init(fileURLWithPath: fileURLWithPath) as CFURL
        var info: NSDictionary?
        if let imageSource = CGImageSourceCreateWithURL(imageURL, nil){
            let imageHeader = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil)
            info = imageHeader
        }
        return info
    }
    
    /// 获取来自网络图片的额外信息
    ///
    /// - Parameter url: 网络图片的url
    /// - Returns: 额外信息
    static func info(url: String) -> NSDictionary? {
        guard let imageURL: URL = URL.init(string: url) else { return nil }
        let imageCFURL: CFURL = imageURL as CFURL
        var info: NSDictionary?
        if let imageSource = CGImageSourceCreateWithURL(imageCFURL, nil){
            let imageHeader = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil)
            info = imageHeader
        }
        return info
    }
    
    // MARK: -图片处理操作
    
    /// 裁切圆角图片
    ///
    /// - Parameter radius: 裁切半径
    /// - Returns: 裁切后的图片
    func clicpCircle() -> UIImage? {
        guard self.size.width == self.size.height else {
            return nil
        }
        // 准备图片上下文操作
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        // 获取上下文
        let context = UIGraphicsGetCurrentContext()
        // 内切圆矩形尺寸
        let circleRect = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)
        // 裁切圆
        context?.addEllipse(in: circleRect)
        context?.clip()
        self.draw(in: circleRect)
        // 获取裁切后的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        // 关闭上下文
        UIGraphicsEndImageContext();
        return newImage
    }
    
    
    /// 裁切弧形图片
    ///
    /// - Parameter radius: 指定的圆角弧度
    /// - Returns: 处理后的图片
    func clicpArc(radius: CGFloat) -> UIImage? {
        // 准备图片上下文操作
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        // 获取上下文
        let context = UIGraphicsGetCurrentContext()
        let path = UIBezierPath.init(roundedRect: CGRect.init(origin: CGPoint.zero, size: self.size), byRoundingCorners: [.topRight, .bottomRight, .bottomLeft, .topLeft], cornerRadii: CGSize.init(width: radius, height: radius))
//        // 内切圆矩形尺寸
        let circleRect = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)
//        let center = CGPoint(x: self.size.width/2, y: self.size.height/2)
        // 裁切圆
//        context?.addPath(path.cgPath)
        context?.addEllipse(in: path.bounds)
        context?.clip()
        path.fill()
        self.draw(in: path.bounds)
        
        // 获取裁切后的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        // 关闭上下文
        UIGraphicsEndImageContext();
        return newImage
    }
    
    /// 添加文字水印
    ///
    /// - Parameters:
    ///   - message: 文本信息
    ///   - point: 水印起点坐标
    ///   - options: 文本信息的设置，例如颜色、字体之类的
    /// - Returns: 添加水印后的图片
    func addWatermark(with message: String, point: CGPoint, options: [NSAttributedString.Key: Any]?) -> UIImage? {
        // 开启上下文
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        // 重绘范围
        draw(in: CGRect(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: self.size.width, height: self.size.height)))
        // 绘制水印
        (message as NSString).draw(at: point, withAttributes: options)
        // 获取新图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭上下文
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    /// 添加图片水印
    ///
    /// - Parameters:
    ///   - image: 水印图片
    ///   - point: 水印的起始点
    ///   - blendMode: 混合类型
    ///   - alpha: 透明度
    /// - Returns: 添加图片水印后的图片
    func addWatermark(with image: UIImage?, point: CGPoint, blendMode: CGBlendMode, alpha: CGFloat) -> UIImage? {
        // 开启上下文
        UIGraphicsBeginImageContextWithOptions(self.size, true, 0.0)
        // 重绘尺寸
        draw(in: CGRect(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: self.size.width, height: self.size.height)))
        /// 添加图片水印
        image?.draw(at: point, blendMode: blendMode, alpha: alpha)
        // 获取新图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭上下文
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    
    
}
