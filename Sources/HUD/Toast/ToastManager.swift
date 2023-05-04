//
//  ToastManager.swift
//  Toast
//
//  Created by iOS on 2023/5/4.
//

import SwiftUI

public extension View {

    private func addToast<Content: View>(isActive: Binding<Bool>,
                                 padding: CGFloat = 10,
                                 defaultOffset: CGFloat = 0,
                                 position: ToastPosition = .bottom,
                                 content: @escaping () -> Content) -> some View {
        ZStack(alignment: position.alignment) {
            self
            ToastView(
                isActive: isActive,
                padding: padding,
                defaultOffset: defaultOffset,
                content: { _ in content() }
            )
        }
    }
    ///添加Toast
    func addToast(_ ob: ToastManager) -> some View {
        self.addToast(
            isActive: ob.isActiveBinding,
            padding: ob.padding,
            defaultOffset: ob.defaultOffset,
            position: ob.position,
            content: { ob.content }
        )
    }
}

public class ToastManager: ObservableObject {
    public init() {}
    public typealias Action = () -> Void
    private var presentationId = UUID()
    //Toast停留时长
    public var duration: TimeInterval = 3
    //Toast显示位置
    public var position: ToastPosition = .bottom{
        didSet{
            switch position {
            case .top:
                defaultOffset = -200
            case .bottom:
                defaultOffset = 200
            }
        }
    }
    var defaultOffset: CGFloat = 0
    //Toast距离屏幕边缘
    public var padding: CGFloat = 10
    
    @Published
    public var content = AnyView(EmptyView())
    
    @Published
    public var isActive = false

    public var isActiveBinding: Binding<Bool> {
        .init(get: { self.isActive },
              set: { self.isActive = $0 }
        )
    }
    ///隐藏Toast
    public func dismiss() {
        dismiss {}
    }
    ///隐藏Toast,有回调
    public func dismiss(completion: @escaping Action) {
        guard isActive else { return completion() }
        isActive = false
        perform(after: 0.3, action: completion)
    }
    ///展示toa,自动隐藏
    public func show<Content: View>(_ content: Content) {
        dismiss {
            self.showAfterDismiss(content: content)
        }
    }
    ///展示toa,手动隐藏
    public func show<Content: View>(@ViewBuilder _ content: @escaping () -> Content) {
        show(content())
    }
}
extension ToastManager {
    //展示自定义View//自己可以重写替换
    public func showText(_ text: String){
        show {
            MessageView(text: text)
        }
    }
}
private extension ToastManager {
    
    func perform(_ action: @escaping Action,
                 after seconds: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: action)
    }
    
    func perform(after seconds: TimeInterval,
                 action: @escaping Action) {
        perform(action, after: seconds)
    }
    
    func showAfterDismiss<Content: View>(content: Content) {
        let id = UUID()
        self.presentationId = id

        self.content = AnyView(content)
        perform(setActive, after: 0.1)
        perform(after: self.duration) {
            guard id == self.presentationId else { return }
            self.dismiss()
        }
    }
    
    func setActive() {
        isActive = true
    }

}

public enum ToastPosition {
    
    case top, bottom
    
    public var alignment: Alignment {
        switch self {
        case .top: return .top
        case .bottom: return .bottom
        }
    }
}
