//
//  PopupView.swift
//  Show
//
//  Created by iOS on 2023/5/4.
//

import SwiftUI

struct ContainerView: View {
    @StateObject private var manager = HUDManager.shared
    @StateObject private var keyboardObserver: KeyboardManager = .init()
    @StateObject private var screenObserver: ScreenManager = .init()
    
    var body: some View {
        ZStack {
            topStackView()
            centerStackView()
            bottomStackView()
        }
        .edgesIgnoringSafeArea(.all)
        .visible(if: !manager.views.isEmpty)
        .animation(.easeInOut, value: manager.views.isEmpty)
    }
    
}

private extension ContainerView {
    
    func topStackView() -> some View {
        ZStack{
            setupMask(items: manager.tops)
            TopStackView(items: manager.tops)
        }
    }
    
    func centerStackView() -> some View {
        ZStack{
            setupMask(items: manager.centers)
            CenterStackView(items: manager.centers)
        }
    }
    
    func bottomStackView() -> some View {
        ZStack{
            setupMask(items: manager.bottoms)
            BottomStackView(items: manager.bottoms, keyboardHeight: keyboardObserver.keyboardHeight)
        }
    }
    
    func setupMask(items: [AnyHUD]) -> some View {
        Color.black.opacity(0.3)
            .active(if: getConfig(items).needMask && !items.isEmpty)
    }
    
    func getConfig(_ items: [AnyHUD]) -> Config {
        items.last?.setupConfig(Config()) ?? .init()
    }
}
