//
//  TopPopupConfig.swift
//  Show
//
//  Created by iOS on 2023/5/4.
//

import SwiftUI

public struct PopupConfig {
    //弹窗背景颜色
    var backgroundColour: Color = .white
    //弹窗忽略安全区域
    var ignoresSafeArea: Bool = false
    //点击区域外关闭弹窗
    var touchOutsideToDismiss: Bool = false
    //圆角弧度
    var cornerRadius: CGFloat = 20
    //手势关闭
    var dragGestureProgressToClose: CGFloat = 1/3
    //手势关闭动画
    var dragGestureAnimation: Animation = .interactiveSpring()
    

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
}


public extension PopupConfig {
    //弹窗背景颜色
    func backgroundColour(_ value: Color) -> Self {
        var clone = self
        clone.backgroundColour = value
        return clone
    }
    //弹窗忽略安全区域
    func ignoresSafeArea(_ value: Bool) -> Self {
        var clone = self
        clone.ignoresSafeArea = value
        return clone
    }
    //点击区域外关闭弹窗
    func touchOutsideToDismiss(_ value: Bool) -> Self {
        var clone = self
        clone.touchOutsideToDismiss = value
        return clone
    }
    //横向的padding,默认为0,大部分情况Center Popup会用到
    func horizontalPadding(_ value: CGFloat) -> Self {
        var clone = self
        clone.horizontalPadding = value
        return clone
    }
    //距离顶部的padding,默认为0,Top Popup会用到
    func topPadding(_ value: CGFloat) -> Self {
        var clone = self
        clone.topPadding = value
        return clone
    }
    //距离底部的padding,默认为0,Bottom Popup会用到
    func bottomPadding(_ value: CGFloat) -> Self {
        var clone = self
        clone.bottomPadding = value
        return clone
    }
    //圆角弧度
    func cornerRadius(_ value: CGFloat) -> Self {
        var clone = self
        clone.cornerRadius = value
        return clone
    }
    //弹出动画执行时间
    func centerAnimationTime(_ value: CGFloat) -> Self {
        var clone = self
        clone.centerAnimationTime = value
        return clone
    }
    //手势关闭
    func dragGestureProgressToClose(_ value: CGFloat) -> Self {
        var clone = self
        clone.dragGestureProgressToClose = value
        return clone
    }
    //手势关闭动画
    func dragGestureAnimation(_ value: Animation) -> Self {
        var clone = self
        clone.dragGestureAnimation = value
        return clone
    }
    //Bottom PopupView自动添加安全区域高度
    func bottomAutoHeigh(_ value: Bool) -> Self {
        var clone = self
        clone.bottomAutoHeight = value
        return clone
    }
    //Center PopupView弹出动画比例
    func centerTransitionEntryScale(_ value: CGFloat) -> Self {
        var clone = self
        clone.centerTransitionEntryScale = value
        return clone
    }
    //Center PopupView弹出动画比例
    func centerTransitionExitScale(_ value: CGFloat) -> Self {
        var clone = self
        clone.centerTransitionExitScale = value
        return clone
    }
    //弹出动画
    func transitionAnimation(_ value: Animation) -> Self {
        var clone = self
        clone.transitionAnimation = value
        return clone
    }
    //堆栈样式--露出位置--默认6
    func stackViewsOffset(_ value: CGFloat) -> Self {
        var clone = self
        clone.stackViewsOffset = value
        return clone
    }
    //堆栈样式--比例
    func stackViewsScale(_ value: CGFloat) -> Self {
        var clone = self
        clone.stackViewsScale = value
        return clone
    }
    //堆栈样式--圆角
    func stackViewsCornerRadius(_ value: CGFloat) -> Self {
        var clone = self
        clone.stackViewsCornerRadius = value
        return clone
    }
    //堆栈样式--最大堆展示数量
    func maxStackCount(_ value: Int) -> Self {
        var clone = self
        clone.maxStackCount = value
        return clone
    }
}
