//
//  LoadingView.swift
//  Toast
//
//  Created by iOS on 2023/4/27.
//

import SwiftUI

public struct LoadingView<Content: View>: View {
    public typealias ContentBuilder = (_ isActive: Bool) -> Content
    private let content: ContentBuilder
    //绑定显示状态
    @Binding private var isActive: Bool
 
    public init( isActive: Binding<Bool>, @ViewBuilder content: @escaping ContentBuilder ) {
        _isActive = isActive
        self.content = content
    }
    
    public var body: some View {
        ZStack{
            Color.black
                .opacity(0.3)
                .ignoresSafeArea()
            
            content(isActive)
                .frame(minWidth: 80, minHeight: 80)
                .background(BlurView())
                .cornerRadius(10)
                .animation(.spring())
                .padding(100)
        }
        .opacity(!isActive ? 0 : 1)
    }
 
}
