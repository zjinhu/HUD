//
//  KeyboardManager.swift
//  SwiftUIHUD
//
//  Created by iOS on 2023/6/19.
//

import SwiftUI
import Combine

#if os(iOS)
class KeyboardManager: ObservableObject {
    @Published private(set) var height: CGFloat = 0
    private var subscription: [AnyCancellable] = []

    init() {
        subscribeToKeyboardEvents()
    }
}

extension KeyboardManager {
    static func hideKeyboard() { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

private extension KeyboardManager {
    func subscribeToKeyboardEvents() {
        Publishers.Merge(getKeyboardWillOpenPublisher(), createKeyboardWillHidePublisher())
            .debounce(for: .milliseconds(50), scheduler: DispatchQueue.main)
            .sink { self.height = $0 }
            .store(in: &subscription)
    }
}
private extension KeyboardManager {
    func getKeyboardWillOpenPublisher() -> Publishers.CompactMap<NotificationCenter.Publisher, CGFloat> {
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
            .map { max(0, $0.height - 8)
            }
    }
    func createKeyboardWillHidePublisher() -> Publishers.Map<NotificationCenter.Publisher, CGFloat> {
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in .zero }
    }
}

#elseif os(macOS)
class KeyboardManager: ObservableObject {
    private(set) var height: CGFloat = 0
}

extension KeyboardManager {
    static func hideKeyboard() {
        DispatchQueue.main.async { NSApp.keyWindow?.makeFirstResponder(nil)
        }
    }
}

#elseif os(tvOS)
class KeyboardManager: ObservableObject {
    private(set) var height: CGFloat = 0
    private init() {}
}

extension KeyboardManager {
    static func hideKeyboard() {}
}
#endif

#if (os(iOS) || os(tvOS)) && !os(xrOS)

class Screen {
    static var safeArea: UIEdgeInsets = UIScreen.safeArea
}

fileprivate extension UIScreen {
    static var safeArea: UIEdgeInsets {
        UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)?
            .safeAreaInsets ?? .zero
    }
}

#elseif os(macOS)
class Screen {
    static var safeArea: NSEdgeInsets = NSScreen.safeArea
}

fileprivate extension NSScreen {
    static var safeArea: NSEdgeInsets =
    NSApplication.shared
        .mainWindow?
        .contentView?
        .safeAreaInsets ?? .init(top: 0, left: 0, bottom: 0, right: 0)
}
#endif
//// MARK: -iOS Implementation
//#if os(iOS)
//class ScreenManager: ObservableObject {
//    @Published private(set) var size: CGSize = UIScreen.size
//    @Published private(set) var safeArea: UIEdgeInsets = UIScreen.safeArea
//    private(set) var cornerRadius: CGFloat? = UIScreen.cornerRadius
//    private var subscription: [AnyCancellable] = []
//
//    static let shared: ScreenManager = .init()
//    private init() { subscribeToScreenOrientationChangeEvents() }
//}
//
//private extension ScreenManager {
//    func subscribeToScreenOrientationChangeEvents() {
//        NotificationCenter.default
//            .publisher(for: UIDevice.orientationDidChangeNotification)
//            .receive(on: DispatchQueue.main)
//            .sink(receiveValue: updateScreenValues)
//            .store(in: &subscription)
//    }
//}
//private extension ScreenManager {
//    func updateScreenValues(_ value: NotificationCenter.Publisher.Output) {
//        size = UIScreen.size
//        safeArea = UIScreen.safeArea
//    }
//}
//
//fileprivate extension UIScreen {
//    static var safeArea: UIEdgeInsets {
//        UIApplication.shared
//            .connectedScenes
//            .compactMap { $0 as? UIWindowScene }
//            .flatMap(\.windows)
//            .first(where: \.isKeyWindow)?
//            .safeAreaInsets ?? .zero
//    }
//    static var size: CGSize { UIScreen.main.bounds.size }
//    static var cornerRadius: CGFloat? = main.value(forKey: cornerRadiusKey) as? CGFloat
//}
//fileprivate extension UIScreen {
//    static let cornerRadiusKey: String = ["Radius", "Corner", "display", "_"].reversed().joined()
//}
//
//
//// MARK: - macOS Implementation
//#elseif os(macOS)
//class ScreenManager: ObservableObject {
//    @Published private(set) var size: CGSize = NSScreen.size
//    @Published private(set) var safeArea: NSEdgeInsets = NSScreen.safeArea
//    private(set) var cornerRadius: CGFloat? = NSScreen.cornerRadius
//    private var subscription: [AnyCancellable] = []
//
//    static let shared: ScreenManager = .init()
//    private init() { subscribeToWindowSizeChangeEvents() }
//}
//
//private extension ScreenManager {
//    func subscribeToWindowSizeChangeEvents() {
//        NotificationCenter.default
//            .publisher(for: NSWindow.didResizeNotification)
//            .receive(on: DispatchQueue.main)
//            .sink(receiveValue: updateScreenValues)
//            .store(in: &subscription)
//    }
//}
//private extension ScreenManager {
//    func updateScreenValues(_ value: NotificationCenter.Publisher.Output) { if let window = value.object as? NSWindow, let contentView = window.contentView {
//        size = contentView.frame.size
//        safeArea = contentView.safeAreaInsets
//    }}
//}
//
//fileprivate extension NSScreen {
//    static var safeArea: NSEdgeInsets =
//        NSApplication.shared
//            .mainWindow?
//            .contentView?
//            .safeAreaInsets ?? .init(top: 0, left: 0, bottom: 0, right: 0)
//    static var size: CGSize = NSApplication.shared.mainWindow?.frame.size ?? .zero
//    static var cornerRadius: CGFloat = 0
//}
//
//
//// MARK: - tvOS Implementation
//#elseif os(tvOS)
//class ScreenManager: ObservableObject {
//    @Published private(set) var size: CGSize = UIScreen.size
//    @Published private(set) var safeArea: UIEdgeInsets = UIScreen.safeArea
//    private(set) var cornerRadius: CGFloat? = UIScreen.cornerRadius
//
//    static let shared: ScreenManager = .init()
//    private init() {}
//}
//
//fileprivate extension UIScreen {
//    static var safeArea: UIEdgeInsets {
//        UIApplication.shared
//            .connectedScenes
//            .compactMap { $0 as? UIWindowScene }
//            .flatMap(\.windows)
//            .first(where: \.isKeyWindow)?
//            .safeAreaInsets ?? .zero
//    }
//    static var size: CGSize { UIScreen.main.bounds.size }
//    static var cornerRadius: CGFloat = 0
//}
//#endif
