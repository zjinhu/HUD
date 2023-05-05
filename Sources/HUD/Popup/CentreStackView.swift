//
//  PopupCentreStackView.swift
//  Show
//
//  Created by iOS on 2023/5/4.
//

import SwiftUI

struct CentreStackView: View {
    let items: [AnyPopup]
    @State private var activeView: AnyView?
    @State private var configTemp: PopupConfig?
    @State private var height: CGFloat?
    @State private var contentIsAnimated: Bool = false
    
    var body: some View {
        createPopup()
            .frame(width: UIScreen.width, height: UIScreen.height)
            .background(createTapArea())
            .animation(transitionAnimation, value: width)
            .animation(transitionAnimation, value: height)
            .animation(transitionAnimation, value: contentIsAnimated)
            .transition(getTransition())
            .onChange(of: items, perform: onItemsChange)
    }
}

private extension CentreStackView {
    func createPopup() -> some View {
        activeView?
            .readHeight(onChange: saveHeight)
            .frame(width: width, height: height)
            .opacity(contentOpacity)
            .background(backgroundColour)
            .cornerRadius(cornerRadius)
    }
    
    func createTapArea() -> some View {
        Color.black.opacity(0.00000000001)
            .onTapGesture(perform: items.last?.dismiss ?? {})
            .active(if: config.touchOutsideToDismiss)
    }
}

// MARK: -Logic Handlers
private extension CentreStackView {
    func onItemsChange(_ items: [AnyPopup]) {
        guard let popup = items.last else { return handleClosingPopup() }
        
        showNewPopup(popup)
        animateContentIfNeeded()
    }
}
private extension CentreStackView {
    func showNewPopup(_ popup: AnyPopup) {
        DispatchQueue.main.async {
            activeView = AnyView(popup.body)
            configTemp = popup.configPopup(config: .init())
        }
    }
    
    func animateContentIfNeeded() {
        if height != nil {
            contentIsAnimated = true
            DispatchQueue.main.asyncAfter(deadline: .now() + opacityAnimationTime) {
                contentIsAnimated = false
            }
        }
    }
    
    func handleClosingPopup() {
        DispatchQueue.main.async {
            height = nil
            activeView = nil
        }
    }
}

// MARK: -View Handlers
private extension CentreStackView {
    func saveHeight(_ value: CGFloat) {
        height = items.isEmpty ? nil : value
    }
    
    func getTransition() -> AnyTransition {
        .scale(scale: items.isEmpty ? config.centerTransitionExitScale : config.centerTransitionEntryScale)
        .combined(with: .opacity)
        .animation(height == nil || items.isEmpty ? transitionAnimation : nil)
    }
}

private extension CentreStackView {
    var width: CGFloat {
        max(0, UIScreen.width - config.horizontalPadding * 2)
    }
    var cornerRadius: CGFloat {
        config.cornerRadius
    }
    var contentOpacity: CGFloat {
        contentIsAnimated ? 0 : 1
    }
    var opacityAnimationTime: CGFloat {
        config.centerAnimationTime
    }
    var backgroundColour: Color {
        config.backgroundColour
    }
    var transitionAnimation: Animation {
        config.transitionAnimation
    }
    var config: PopupConfig {
        items.last?.configPopup(config: .init()) ?? configTemp ?? .init()
    }
}
