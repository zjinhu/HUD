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
    var body: some View {
        ZStack(alignment: .center, content: setupHudStack)
            .ignoresSafeArea()
            .background(setupTapArea())
            .animation(config.animation.entry, value: config.horizontalPadding)
            .animation(height == nil ? config.animation.removal : config.animation.entry, value: height)
            .animation(config.animation.entry, value: contentIsAnimated)
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
            .shadow(color: config.shadowColour,
                    radius: config.shadowRadius,
                    x: config.shadowOffsetX,
                    y: config.shadowOffsetY)
    }
    
    func setupTapArea() -> some View {
        Color.black.opacity(0.00000000001)
            .onTapGesture(perform: items.last?.hiddenHUD ?? {})
            .active(if: config.touchOutsideToHidden)
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
        .animation(height == nil || items.isEmpty ? config.animation.removal : nil)
        .animation(items.isEmpty ? config.animation.removal : nil)
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
