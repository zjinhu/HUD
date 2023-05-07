//
//  TopPopupConfig.swift
//  Show
//
//  Created by iOS on 2023/5/4.
//

import SwiftUI

public struct Config: Configurable{
    //是否需要遮罩
    var needMask: Bool = true
    //弹窗背景颜色
    var backgroundColour: Color = .clear
    //弹窗忽略安全区域
    var ignoresSafeArea: Bool = false
    //点击区域外关闭弹窗
    var touchOutsideToDismiss: Bool = false
    //圆角弧度
    var cornerRadius: CGFloat = 10
    //手势关闭
    var dragGestureProgressToClose: CGFloat = 1/3
    //手势关闭动画
    var dragGestureAnimation: Animation = .interactiveSpring()
    
    //弹窗背景阴影颜色
    var shadowColour: Color = .primary.opacity(0.3)
    var shadowRadius: CGFloat = 8
    var shadowOffsetX: CGFloat = 0
    var shadowOffsetY: CGFloat = 0
    
    //距离顶部的padding,默认为0,Top Popup会用到
    var topPadding: CGFloat = 0
    //距离底部的padding,默认为0,Bottom Popup会用到
    var bottomPadding: CGFloat = 0
    //Bottom PopupView自动添加安全区域高度
    var bottomAutoHeight: Bool = false
    
    
    //横向的padding,默认为0,大部分情况Center Popup会用到
    var horizontalPadding: CGFloat = 0
    //中间弹出动画执行时间
    var centerAnimationTime: CGFloat = 0.1
    //Center PopupView弹出动画比例
    var centerTransitionExitScale: CGFloat = 0.86
    //Center PopupView弹出动画比例
    var centerTransitionEntryScale: CGFloat = 1.1
    
    
    //弹出动画
    var transitionAnimation: Animation = .spring(response: 0.32, dampingFraction: 1, blendDuration: 0.32)
    //堆栈样式--露出位置--默认6
    var stackViewsOffset: CGFloat = 6
    //堆栈样式--比例
    var stackViewsScale: CGFloat = 0.06
    //堆栈样式--圆角
    var stackViewsCornerRadius: CGFloat = 10
    //堆栈样式--最大堆展示数量
    var maxStackCount: Int = 3
    
    
    //是否需要自动关闭
    var autoDismiss: Bool = false
    //自动关闭等候时长
    var autoDismissTime: TimeInterval = 3
}


public extension Config {
    //是否需要遮罩
    func needMask(_ value: Bool) -> Self {
        changing(path: \.needMask, to: value)
    }
    //弹窗背景颜色
    func backgroundColour(_ value: Color) -> Self {
        changing(path: \.backgroundColour, to: value)
    }
    //弹窗忽略安全区域
    func ignoresSafeArea(_ value: Bool) -> Self {
        changing(path: \.ignoresSafeArea, to: value)
    }
    //点击区域外关闭弹窗
    func touchOutsideToDismiss(_ value: Bool) -> Self {
        changing(path: \.touchOutsideToDismiss, to: value)
    }
    //横向的padding,默认为0,大部分情况Center Popup会用到
    func horizontalPadding(_ value: CGFloat) -> Self {
        changing(path: \.horizontalPadding, to: value)
    }
    //距离顶部的padding,默认为0,Top Popup会用到
    func topPadding(_ value: CGFloat) -> Self {
        changing(path: \.topPadding, to: value)
    }
    //距离底部的padding,默认为0,Bottom Popup会用到
    func bottomPadding(_ value: CGFloat) -> Self {
        changing(path: \.bottomPadding, to: value)
    }
    //圆角弧度
    func cornerRadius(_ value: CGFloat) -> Self {
        changing(path: \.cornerRadius, to: value)
    }
    //弹出动画执行时间
    func centerAnimationTime(_ value: CGFloat) -> Self {
        changing(path: \.centerAnimationTime, to: value)
    }
    //手势关闭
    func dragGestureProgressToClose(_ value: CGFloat) -> Self {
        changing(path: \.dragGestureProgressToClose, to: value)
    }
    //手势关闭动画
    func dragGestureAnimation(_ value: Animation) -> Self {
        changing(path: \.dragGestureAnimation, to: value)
    }
    //弹窗背景阴影颜色
    func shadowColour(_ value: Color) -> Self {
        changing(path: \.shadowColour, to: value)
    }
    func shadowRadius(_ value: CGFloat) -> Self {
        changing(path: \.shadowRadius, to: value)
    }
    func shadowOffsetX(_ value: CGFloat) -> Self {
        changing(path: \.shadowOffsetX, to: value)
    }
    func shadowOffsetY(_ value: CGFloat) -> Self {
        changing(path: \.shadowOffsetY, to: value)
    }
    //Bottom PopupView自动添加安全区域高度
    func bottomAutoHeight(_ value: Bool) -> Self {
        changing(path: \.bottomAutoHeight, to: value)
    }
    //Center PopupView弹出动画比例
    func centerTransitionEntryScale(_ value: CGFloat) -> Self {
        changing(path: \.centerTransitionEntryScale, to: value)
    }
    //Center PopupView弹出动画比例
    func centerTransitionExitScale(_ value: CGFloat) -> Self {
        changing(path: \.centerTransitionExitScale, to: value)
    }
    //弹出动画
    func transitionAnimation(_ value: Animation) -> Self {
        changing(path: \.transitionAnimation, to: value)
    }
    //堆栈样式--露出位置--默认6
    func stackViewsOffset(_ value: CGFloat) -> Self {
        changing(path: \.stackViewsOffset, to: value)
    }
    //堆栈样式--比例
    func stackViewsScale(_ value: CGFloat) -> Self {
        changing(path: \.stackViewsScale, to: value)
    }
    //堆栈样式--圆角
    func stackViewsCornerRadius(_ value: CGFloat) -> Self {
        changing(path: \.stackViewsCornerRadius, to: value)
    }
    //堆栈样式--最大堆展示数量
    func maxStackCount(_ value: Int) -> Self {
        changing(path: \.maxStackCount, to: value)
    }
    //是否需要自动关闭
    func autoDismiss(_ value: Bool) -> Self {
        changing(path: \.autoDismiss, to: value)
    }
    //自动关闭等候时长
    func autoDismissTime(_ value: TimeInterval) -> Self {
        changing(path: \.autoDismissTime, to: value)
    }
}

protocol Configurable {}
extension Configurable {
    func changing<T>(path: WritableKeyPath<Self, T>, to value: T) -> Self {
        var clone = self
        clone[keyPath: path] = value
        return clone
    }
}
