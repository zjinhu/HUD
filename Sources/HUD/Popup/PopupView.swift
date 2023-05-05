//
//  PopupView.swift
//  Show
//
//  Created by iOS on 2023/5/4.
//

import SwiftUI

struct PopupView: View {
    @StateObject private var manager = PopupManager.shared
    
    var body: some View {
        ZStack {
            createTopPopupStackView()
            createCentrePopupStackView()
            createBottomPopupStackView()
        }
        .edgesIgnoringSafeArea(.all)
        .background(createOverlay())
    }
    
    func createOverlay() -> some View {
        Color.black
            .opacity(0.3)
            .ignoresSafeArea()
            .opacity(manager.views.isEmpty ? 0 : 1)
//            .animation(.easeInOut, value: manager.views.isEmpty)
    }
}

private extension PopupView {
    func createTopPopupStackView() -> some View {
        TopStackView(items: manager.tops)
    }
    func createCentrePopupStackView() -> some View {
        CentreStackView(items: manager.centers)
    }
    func createBottomPopupStackView() -> some View {
        BottomStackView(items: manager.bottoms)
    }
}
