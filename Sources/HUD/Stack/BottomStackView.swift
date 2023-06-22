//
//  PopupBottomStackView.swift
//  Show
//
//  Created by iOS on 2023/5/4.
//

import SwiftUI

struct BottomStackView: View {
    let items: [AnyHUD]
    let keyboardHeight: CGFloat 
    @State private var heights: [AnyHUD: CGFloat] = [:]
    @State private var gestureTranslation: CGFloat = 0
    @State private var cacheCleanerTrigger: Bool = false
    
    var body: some View {
        ZStack(alignment: .top, content: setupHudStack)
            .ignoresSafeArea()
            .background(setupTapArea())
            .animation(transitionAnimation, value: items)
            .animation(transitionAnimation, value: heights)
            .animation(dragGestureAnimation, value: gestureTranslation)
            .gesture(hudDragGesture)
            .onChange(of: items, perform: onItemsChange)
            .clearCacheObjects(shouldClear: items.isEmpty, trigger: $cacheCleanerTrigger)
    }
}

private extension BottomStackView {
    func setupHudStack() -> some View {
        ForEach(items, id: \.self, content: setupHud)
    }
    
    func setupTapArea() -> some View {
        Color.black.opacity(0.00000000001)
            .onTapGesture(perform: items.last?.dismiss ?? {})
            .active(if: config.touchOutsideToDismiss)
    }
}

private extension BottomStackView {
    func setupHud(_ item: AnyHUD) -> some View {
        item.body
            .padding(.bottom, getContentBottomPadding())
            .padding(.horizontal, contentHorizontalPadding)
            .readHeight{ height in
                heights[item] = height
            }
            .background(backgroundColour,
                        radius: getCornerRadius(for: item),
                        corners: getCorners())
            .opacity(getOpacity(for: item))
            .offset(y: getOffset(for: item))
            .scaleEffect(getScale(for: item), anchor: .top)
            .compositingGroup()
            .alignToBottom(bottomPadding)
            .transition(transition)
            .zIndex(isLast(item).doubleValue)
            .shadow(color: config.shadowColour,
                    radius: config.shadowRadius,
                    x: config.shadowOffsetX,
                    y: config.shadowOffsetY)

    }
}

// MARK: -Gesture Handler
private extension BottomStackView {
    var hudDragGesture: some Gesture {
        DragGesture()
            .onChanged(onHudDragGestureChanged)
            .onEnded(onHudDragGestureEnded)
    }
    
    func onHudDragGestureChanged(_ value: DragGesture.Value) {
        if config.dragGestureEnabled {
            gestureTranslation = max(0, value.translation.height)
        }
    }
    
    func onHudDragGestureEnded(_ value: DragGesture.Value) {
        if translationProgress() >= gestureClosingThresholdFactor {
            items.last?.dismiss()
        }
        gestureTranslation = 0
    }
    
    func onItemsChange(_ items: [AnyHUD]) {
        items.last?.setupConfig(HUDConfig()).onFocus()
    }
 
}

// MARK: -View Handlers
private extension BottomStackView {
    
    func getCornerRadius(for item: AnyHUD) -> CGFloat {
        if isLast(item) {
            return cornerRadius.active
        }
        if gestureTranslation.isZero || !isNextToLast(item) {
            return cornerRadius.inactive
        }
        
        let difference = cornerRadius.active - cornerRadius.inactive
        let differenceProgress = difference * translationProgress()
        return cornerRadius.inactive + differenceProgress
    }
    
    func getCorners() -> RectCorner {
        switch bottomPadding {
            case 0: return [.topLeft, .topRight]
            default: return .allCorners
        }
    }
    
    func getOpacity(for item: AnyHUD) -> Double {
        if isLast(item) {
            return 1
        }
        if gestureTranslation.isZero {
            return  1 - invertedIndex(of: item).doubleValue * opacityFactor
        }
        
        let scaleValue = invertedIndex(of: item).doubleValue * opacityFactor
        let progressDifference = isNextToLast(item) ? 1 - translationProgress() : max(0.6, 1 - translationProgress())
        return 1 - scaleValue * progressDifference
    }
    
    func getScale(for item: AnyHUD) -> CGFloat {
        if isLast(item) {
            return 1
        }
        if gestureTranslation.isZero {
            return  1 - invertedIndex(of: item).floatValue * scaleFactor
        }
        
        let scaleValue = invertedIndex(of: item).floatValue * scaleFactor
        let progressDifference = isNextToLast(item) ? 1 - translationProgress() : max(0.7, 1 - translationProgress())
        return 1 - scaleValue * progressDifference
    }
    
    func getContentBottomPadding() -> CGFloat {
        if isKeyboardVisible { return keyboardHeight + config.distanceFromKeyboard }
        if config.contentIgnoresSafeArea { return 0 }

        return max(UIScreen.safeArea.bottom - bottomPadding, 0)
    }
    
    func getOffset(for item: AnyHUD) -> CGFloat {
        isLast(item) ? gestureTranslation : invertedIndex(of: item).floatValue * offsetFactor
    }
}

private extension BottomStackView {
    func translationProgress() -> CGFloat {
        abs(gestureTranslation) / height
    }
    func isLast(_ item: AnyHUD) -> Bool {
        items.last == item
    }
    func isNextToLast(_ item: AnyHUD) -> Bool {
        index(of: item) == items.count - 2
    }
    func invertedIndex(of item: AnyHUD) -> Int {
        items.count - 1 - index(of: item)
    }
    func index(of item: AnyHUD) -> Int {
        items.firstIndex(of: item) ?? 0
    }
}

private extension BottomStackView {
    var height: CGFloat {
        if let hud = items.last, let hei = heights[hud]{
            return  hei
        }
        return  0
    }
 
    var contentHorizontalPadding: CGFloat {
        config.horizontalPadding
    }
    var bottomPadding: CGFloat {
        config.bottomPadding
    }
    var maxHeightFactor: CGFloat {
        12
    }
    var maxHeightStackedFactor: CGFloat {
        0.85
    }
    var opacityFactor: Double {
        1 / config.maxStackCount.doubleValue
    }
    var offsetFactor: CGFloat {
        -config.stackViewsOffset
    }
    var scaleFactor: CGFloat {
        config.stackViewsScale
    }
    var cornerRadius: (active: CGFloat, inactive: CGFloat) {
        (config.cornerRadius, config.stackViewsCornerRadius)
    }
    var backgroundColour: Color {
        config.backgroundColour
    }
    var transitionAnimation: Animation {
        config.transitionAnimation
    }
    var dragGestureAnimation: Animation {
        config.dragGestureAnimation
    }
    var gestureClosingThresholdFactor: CGFloat {
        config.dragGestureProgressToClose
    }
    var transition: AnyTransition {
        .move(edge: .bottom)
    }
    var config: HUDConfig {
        items.last?.setupConfig(HUDConfig()) ?? .init()
    }
    var isKeyboardVisible: Bool {
        keyboardHeight > 0
    }
}
