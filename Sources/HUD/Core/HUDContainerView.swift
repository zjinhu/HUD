//
//  PopupView.swift
//  Show
//
//  Created by iOS on 2023/5/4.
//

import SwiftUI

#if os(iOS) || os(macOS)
struct HUDContainerView: View {
    @StateObject private var manager = HUDManager.shared
    var body: some View { createBody() }
}
#elseif os(tvOS)
struct HUDContainerView: View {
    let rootView: any View
    @StateObject private var manager = HUDManager.shared

    var body: some View {
        AnyView(rootView)
            .disabled(!manager.views.isEmpty)
            .overlay(createBody())
    }
}
#endif

private extension HUDContainerView {
    
    func createBody() -> some View {
        createHudStackView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(createOverlay())
    }
    
    func createHudStackView() -> some View {
        ZStack {
            topStackView()
            centerStackView()
            bottomStackView()
        }
        .animation(.transition, value: manager.views.map(\.id))
    }
    
    func createOverlay() -> some View {
//        Color.black.opacity(0.6)
        BlurView()
            .ignoresSafeArea()
            .active(if: getConfig(manager.views).needMask && !manager.views.isEmpty)
            .animation(.linear(duration: 0.2), value: manager.views)
    }
    
    func topStackView() -> some View {
        TopStackView(items: manager.tops)
    }
    
    func centerStackView() -> some View {
        CenterStackView(items: manager.centers)
    }
    
    func bottomStackView() -> some View {
        BottomStackView(items: manager.bottoms)
    }
 
    func getConfig(_ items: [AnyHUD]) -> HUDConfig {
        items.last?.setupConfig(HUDConfig()) ?? .init()
    }
}
