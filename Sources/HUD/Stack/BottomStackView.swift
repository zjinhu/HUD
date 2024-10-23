//
//  PopupBottomStackView.swift
//  Show
//
//  Created by iOS on 2023/5/4.
//

import SwiftUI

struct BottomStackView: View {
    let items: [AnyHUD]
    @State private var heights: [AnyHUD: CGFloat] = [:]
    @State private var gestureTranslation: CGFloat = 0
    @GestureState var isGestureActive: Bool = false
    @ObservedObject private var keyboardManager = KeyboardManager()
    
    var body: some View {
        ZStack(alignment: .top, content: setupHudStack)
            .ignoresSafeArea()
            .background(setupTapArea())
            .animation(isGestureActive ? .dragGesture : .removel, value: gestureTranslation)
            .animation(.keyboard, value: isKeyboardVisible)
            .animation(items.isEmpty ? .removeLast : .transition, value: !items.isEmpty)
            .onDragGesture($isGestureActive,
                           onChanged: onDragGestureChanged,
                           onEnded: onDragGestureEnded)
    }
}

private extension BottomStackView {
    func setupHudStack() -> some View {
        ForEach(items, id: \.self, content: setupHud)
    }
    
    func setupTapArea() -> some View {
        Color.black.opacity(0.00000000001)
            .onTapGesture(perform: items.last?.dismissHUD ?? {})
            .active(if: config.touchOutsideToDismiss)
    }
}

private extension BottomStackView {
    func setupHud(_ item: AnyHUD) -> some View {
        item.body
            .padding(.bottom, getContentBottomPadding())
            .padding(.horizontal, contentHorizontalPadding)
            .readHeight{ height in
                withAnimation(.transition) {
                    heights[item] = height
                }
            }
            .background(backgroundColour,
                        radius: getCornerRadius(for: item),
                        corners: getCorners())
            .opacity(getOpacity(for: item))
            .offset(y: getOffset(for: item))
            .scaleEffect(x: getScale(for: item))
            .compositingGroup()
            .align(to: .bottom, bottomPadding)
            .focusSectionIfAvailable()
            .transition(.move(edge: .bottom))
            .zIndex(getZIndex(item))
            .shadow(color: config.shadowColor,
                    radius: config.shadowRadius,
                    x: config.shadowOffsetX,
                    y: config.shadowOffsetY)

    }
}

// MARK: -Gesture Handler
private extension BottomStackView {
    func onDragGestureChanged(_ value: CGFloat) {
        if config.dragGestureEnabled {
            gestureTranslation = max(0, value)
        }
    }
    
    func onDragGestureEnded(_ value: CGFloat) {
        if translationProgress >= gestureClosingThresholdFactor {
            items.last?.dismissHUD()
        }
        let resetAfter = items.count == 1 && translationProgress >= gestureClosingThresholdFactor ? 0.25 : 0
        DispatchQueue.main.asyncAfter(deadline: .now() + resetAfter) {
            gestureTranslation = 0
        }
    }

}

// MARK: -View Handlers
private extension BottomStackView {
    var isKeyboardVisible: Bool {
        keyboardManager.height > 0
    }
    
    func getCornerRadius(for item: AnyHUD) -> CGFloat {
        if isLast(item) {
            return cornerRadius.active
        }
        if gestureTranslation.isZero || !isNextToLast(item) {
            return cornerRadius.inactive
        }
        
        let difference = cornerRadius.active - cornerRadius.inactive
        let differenceProgress = difference * translationProgress
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
            return  1 - invertedIndex(item).doubleValue * opacityFactor
        }
        
        let scaleValue = invertedIndex(item).doubleValue * opacityFactor
        let progressDifference = isNextToLast(item) ? 1 - translationProgress : max(0.6, 1 - translationProgress)
        return 1 - scaleValue * progressDifference
    }
    
    func getScale(for item: AnyHUD) -> CGFloat {

        let scaleValue = invertedIndex(item).floatValue * scaleFactor
        let progressDifference = isNextToLast(item) ? 1 - translationProgress : max(0.7, 1 - translationProgress)
        let scale = 1 - scaleValue * progressDifference
        return min(1, scale)
    }
    
    func getContentBottomPadding() -> CGFloat {
        if isKeyboardVisible { return keyboardManager.height + config.distanceFromKeyboard }
        if config.contentIgnoresSafeArea { return 0 }

        return max(Screen.safeArea.bottom - bottomPadding, 0)
    }
    
    func getOffset(for item: AnyHUD) -> CGFloat {
        isLast(item) ? gestureTranslation : invertedIndex(item).floatValue * offsetFactor
    }
}

private extension BottomStackView {
    func isLast(_ item: AnyHUD) -> Bool {
        items.last == item
    }
    func isNextToLast(_ item: AnyHUD) -> Bool {
        invertedIndex(item) == 1
    }
    func invertedIndex(_ item: AnyHUD) -> Int {
        items.count - 1 - index(item)
    }
    func index(_ item: AnyHUD) -> Int {
        items.firstIndex(of: item) ?? 0
    }
    
    func getZIndex(_ item: AnyHUD) -> Double {
        index(item).doubleValue + 1
    }
}

private extension BottomStackView {

    var translationProgress: CGFloat {
        abs(gestureTranslation) / height
    }
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
    var gestureClosingThresholdFactor: CGFloat {
        config.dragGestureProgressToClose
    }
 
    var config: HUDConfig {
        items.last?.setupConfig(HUDConfig()) ?? .init()
    }
}
