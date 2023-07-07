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
            .disabled(!stack.views.isEmpty)
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
        .animation(manager.isPresent ? AnimationType.spring.entry : AnimationType.spring.removal, value: manager.views.map(\.id))
//        .edgesIgnoringSafeArea(.all)
//        .visible(if: !manager.views.isEmpty)
    }
    func createOverlay() -> some View {
        Color.black.opacity(0.3)
            .ignoresSafeArea()
            .active(if: getConfig(manager.views).needMask && !manager.views.isEmpty)
            .animation(.easeInOut, value: manager.views.isEmpty)
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
