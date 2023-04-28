//
//  LoadingManager.swift
//  Toast
//
//  Created by iOS on 2023/4/27.
//

import Foundation
import SwiftUI
public class LoadingManager: ObservableObject {
    public init() {}
    //HUD提示
    @Published public var text: String?
    //HUD提示字体颜色
    @Published public var textColor = Color.black
    //HUD提示字体颜色
    @Published public var textFont: Font = .system(size: 15, weight: .medium)
    //HUD Loading颜色
    @Published public var accentColor = Color.blue
    ///进度条进度 0--1
    @Published public var progress: CGFloat = 0
    ///展示的容器
    @Published public var content = AnyView(EmptyView())
    ///展示状态
    @Published public var isActive = false
    ///状态绑定
    public var isActiveBinding: Binding<Bool> {
        .init(get: { self.isActive },
              set: { self.isActive = $0 }
        )
    }
    ///直接关闭loading
    public func dismiss() {
        isActive = false
    }
    ///展示loading
    public func show<Content: View>(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = AnyView(content())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isActive = true
        }
    }
 
    private func dismissDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isActive = false
        }
    }
}

extension LoadingManager {
    
    public func showLoading(){
        show {
            LoadProgressView()
        }
    }
    
    public func showProgress(){
        show {
            GaugeProgressView()
        }
    }
    
    public func showSuccess(){
        show {
            SuccessView()
        }
        dismissDelay()
    }
    
    public func showFailed(){
        show {
            FailedView()
        }
        dismissDelay()
    }
}


