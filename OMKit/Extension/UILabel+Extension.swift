//
//  UILabel+Extension.swift
//  OMKit
//
//  Created by oymuzi on 2019/2/25.
//  Copyright © 2019年 幸福的小木子. All rights reserved.
//

import Foundation
import UIKit

private var UILABELKEY_ISENABLEDCOPY        = "uilabel_isEnablesCopy"
private var UILABELKEY_COPYPRESSDURATION    = "uilabel_copyPressDuration"


// MARK: - 增加 是否允许拷贝文本内容属性，按压时间属性
extension UILabel{
    
    /** 是否允许有复制功能*/
    public var om_isEnabledCopy: Bool{
        get{
            guard let value = objc_getAssociatedObject(self, &UILABELKEY_ISENABLEDCOPY) else {
                return false
            }
            guard let enabledCopy = value as? Bool else {
                return false
            }
            return enabledCopy
        }
        set{
            objc_setAssociatedObject(self, &UILABELKEY_ISENABLEDCOPY, newValue, .OBJC_ASSOCIATION_ASSIGN)
            self.attachLongPressGesture()
        }
    }
    
    /** 设置按压时间，长按指定时间后出现复制按钮*/
    public var om_copyPressDuration: Float{
        get{
            guard let value = objc_getAssociatedObject(self, &UILABELKEY_COPYPRESSDURATION) else {
                return 0.5
            }
            guard let pressDuration = value as? Float else {
                return 0.5
            }
            return pressDuration
        }
        set{
           objc_setAssociatedObject(self, &UILABELKEY_COPYPRESSDURATION, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    open override var canBecomeFirstResponder: Bool{
        return true
    }
    
    /** 附加长按手势*/
    private func attachLongPressGesture(){
        guard self.om_isEnabledCopy else { return }
        self.isUserInteractionEnabled = true
        let longPressGesture = UILongPressGestureRecognizer.init(target: self, action: #selector(showCopyMenu))
        let pressDuration = self.om_copyPressDuration != 0.5 ? self.om_copyPressDuration : 0.5
        longPressGesture.minimumPressDuration = TimeInterval(pressDuration)
        self.addGestureRecognizer(longPressGesture)
    }
    
    /** 展示复制按钮*/
    @objc private func showCopyMenu(){
        self.becomeFirstResponder()
        let menu = UIMenuController.shared
        let copy = UIMenuItem.init(title: "复制", action: #selector(copyText(_:)))
        menu.menuItems = [copy]
        menu.setTargetRect(self.frame, in: self.superview ?? self)
        menu.setMenuVisible(true, animated: true)
    }
    
    /** 复制文本内容*/
    @objc private func copyText(_ sender: Any){
        let pasteboard = UIPasteboard.general
        pasteboard.string = self.text ?? self.attributedText?.string
    }
    
}
