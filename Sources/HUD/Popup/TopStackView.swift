//
//  PopupTopStackView.swift
//  Show
//
//  Created by iOS on 2023/5/4.
//

import SwiftUI

struct TopStackView: View {
    let items: [AnyPopup]
    @State private var heights: [AnyPopup: CGFloat] = [:]
    @State private var gestureTranslation: CGFloat = 0

    var body: some View {
        ZStack(alignment: .bottom, content: createPopupStack)
            .ignoresSafeArea()
            .animation(transitionAnimation, value: items)
            .animation(transitionAnimation, value: heights)
            .animation(dragGestureAnimation, value: gestureTranslation)
            .background(createTapArea())
            .simultaneousGesture(popupDragGesture)
    }
}

private extension TopStackView {
    func createPopupStack() -> some View {
        ForEach(items, id: \.self, content: createPopup)
    }
    
    func createTapArea() -> some View {
        Color.black.opacity(0.00000000001)
            .onTapGesture(perform: items.last?.dismiss ?? {})
            .active(if: config.touchOutsideToDismiss)
    }
}

private extension TopStackView {
    func createPopup(_ item: AnyPopup) -> some View {
        item.body
            .padding(.top, contentTopPadding)
            .readHeight { saveHeight($0, for: item) }
            .frame(width: width, height: height)
            .background(backgroundColour)
            .cornerRadius(getCornerRadius(for: item))
            .opacity(getOpacity(for: item))
            .offset(y: getOffset(for: item))
            .scaleEffect(getScale(for: item), anchor: .bottom)
            .alignToTop(topPadding)
            .transition(transition)
            .zIndex(isLast(item).doubleValue)
    }
}

// MARK: -Gesture Handler
private extension TopStackView {
    var popupDragGesture: some Gesture {
        DragGesture()
            .onChanged(onPopupDragGestureChanged)
            .onEnded(onPopupDragGestureEnded)
    }
    
    func onPopupDragGestureChanged(_ value: DragGesture.Value) {
        gestureTranslation = min(0, value.translation.height)
    }
    
    func onPopupDragGestureEnded(_ value: DragGesture.Value) {
        if translationProgress() >= gestureClosingThresholdFactor {
            items.last?.dismiss()
        }
        gestureTranslation = 0
    }
}

// MARK: -View Handlers
private extension TopStackView {
    
    func getCornerRadius(for item: AnyPopup) -> CGFloat {
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
    
    func getOpacity(for item: AnyPopup) -> Double {
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
    
    func getScale(for item: AnyPopup) -> CGFloat {
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
    
    func getOffset(for item: AnyPopup) -> CGFloat {
        isLast(item) ? gestureTranslation : invertedIndex(of: item).floatValue * offsetFactor
    }
    
    func saveHeight(_ height: CGFloat, for item: AnyPopup) {
        heights[item] = height
    }
}

private extension TopStackView {
    func translationProgress() -> CGFloat {
        abs(gestureTranslation) / height
    }
    
    func isLast(_ item: AnyPopup) -> Bool {
        items.last == item
    }
    
    func isNextToLast(_ item: AnyPopup) -> Bool {
        index(of: item) == items.count - 2
    }
    
    func invertedIndex(of item: AnyPopup) -> Int {
        items.count - 1 - index(of: item)
    }
    
    func index(of item: AnyPopup) -> Int {
        items.firstIndex(of: item) ?? 0
    }
}

private extension TopStackView {
    var contentTopPadding: CGFloat {
        config.ignoresSafeArea ? 0 : max(UIScreen.safeArea.top - config.topPadding, 0)
    }
    
    var topPadding: CGFloat {
        config.topPadding
    }
    
    var width: CGFloat {
        UIScreen.width - config.horizontalPadding * 2
    }
    
    var height: CGFloat {
        heights.first { $0.key == items.last }?.value ?? 0
    }
    
    var opacityFactor: Double {
        1 / config.maxStackCount.doubleValue
    }
    
    var offsetFactor: CGFloat {
        config.stackViewsOffset
    }
    
    var scaleFactor: CGFloat {
        config.stackViewsScale
    }
    
    var cornerRadius: (active: CGFloat, inactive: CGFloat) { (config.cornerRadius, config.stackViewsCornerRadius)
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
        .move(edge: .top)
    }
    
    var config: PopupConfig {
        items.last?.configPopup(config: .init()) ?? .init()
    }
}
