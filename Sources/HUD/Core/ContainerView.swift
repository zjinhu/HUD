//
//  PopupView.swift
//  Show
//
//  Created by iOS on 2023/5/4.
//

import SwiftUI

struct ContainerView: View {
    @StateObject private var manager = HudManager.shared
    
    var body: some View {
        ZStack {
            topStackView()
            centerStackView()
            bottomStackView()
        }
        .edgesIgnoringSafeArea(.all)
    }

}

private extension ContainerView {

    func topStackView() -> some View {
        ZStack{
            setupBack(items: manager.tops)
            TopStackView(items: manager.tops)
        }
    }
    
    func centerStackView() -> some View {
        ZStack{
            setupBack(items: manager.centers)
            CenterStackView(items: manager.centers)
        }
    }
    
    func bottomStackView() -> some View {
        ZStack{
            setupBack(items: manager.bottoms)
            BottomStackView(items: manager.bottoms)
        }
    }
    
    func setupBack(items: [AnyHud]) -> some View {
        Color.black.opacity(0.3)
            .active(if: getConfig(items).needMask && !items.isEmpty)
    }
    
    func getConfig(_ items: [AnyHud]) -> Config {
        items.last?.setupConfig(Config()) ?? .init()
    }
}
