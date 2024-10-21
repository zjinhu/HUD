//
//  PopupCentreStackView.swift
//  Show
//
//  Created by iOS on 2023/5/4.
//

import SwiftUI

struct CenterStackView: View {
    let items: [AnyHUD]
    @State private var contentIsAnimated: Bool = false
    @State private var height: CGFloat?
    @ObservedObject private var keyboardManager = KeyboardManager()
    var body: some View {
        ZStack(alignment: .center, content: setupHudStack)
            .align(to: .bottom, keyboardManager.height == 0 ? nil : keyboardManager.height)
            .frame(maxHeight: .infinity)
            .ignoresSafeArea()
            .background(setupTapArea())
            .animation(.transition, value: config.horizontalPadding)
            .animation(.transition, value: height)
            .animation(.transition, value: contentIsAnimated)
            .animation(.keyboard, value: keyboardManager.height)
            .transition(getTransition())
    }
}

private extension CenterStackView {
    func setupHudStack() -> some View {
        ForEach(items, id: \.self, content: setupHud)
    }
    
    func setupHud(_ item: AnyHUD) -> some View {
        item.body
            .readHeight(saveHeight)
            .opacity(contentOpacity)
            .background(config.backgroundColour,
                        radius: config.cornerRadius,
                        corners: .allCorners)
            .padding(.horizontal, config.horizontalPadding)
            .compositingGroup()
            .focusSectionIfAvailable()
            .shadow(color: config.shadowColor,
                    radius: config.shadowRadius,
                    x: config.shadowOffsetX,
                    y: config.shadowOffsetY)
    }
    
    func setupTapArea() -> some View {
        Color.black.opacity(0.00000000001)
            .onTapGesture(perform: items.last?.dismissHUD ?? {})
            .active(if: config.touchOutsideToDismiss)
    }
}

// MARK: -View Handlers
private extension CenterStackView {
    func saveHeight(_ value: CGFloat) {
        height = items.isEmpty ? nil : value
    }
    func getTransition() -> AnyTransition {
        .scale(scale: items.isEmpty ? config.centerTransitionExitScale : config.centerTransitionEntryScale)
        .combined(with: .opacity)
        .animation(height == nil || items.isEmpty ? .transition : nil)
        .animation(items.isEmpty ? .transition : nil)
    }
}

private extension CenterStackView {
    
    var contentOpacity: CGFloat {
        contentIsAnimated ? 0 : 1
    }
    
    var config: HUDConfig {
        items.last?.setupConfig(HUDConfig()) ?? .init()
    }
}
