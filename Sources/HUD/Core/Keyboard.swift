//
//  KeyboardManager.swift
//  SwiftUIHUD
//
//  Created by iOS on 2023/6/19.
//

import SwiftUI
import Combine

extension UIApplication {
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


class KeyboardManager: ObservableObject {
    @Published private(set) var keyboardHeight: CGFloat = 0
    private var subscription: [AnyCancellable] = []

    init() { subscribeToKeyboardEvents() }
}

// MARK: - Creating Publishers
private extension KeyboardManager {
    func subscribeToKeyboardEvents() {
        Publishers.Merge(getKeyboardWillOpenPublisher(), createKeyboardWillHidePublisher())
            .debounce(for: .milliseconds(50), scheduler: DispatchQueue.main)
            .sink { self.keyboardHeight = $0 }
            .store(in: &subscription)
    }
}
private extension KeyboardManager {
    func getKeyboardWillOpenPublisher() -> Publishers.CompactMap<NotificationCenter.Publisher, CGFloat> {
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
            .map { max(0, $0.height - 8) }
    }
    func createKeyboardWillHidePublisher() -> Publishers.Map<NotificationCenter.Publisher, CGFloat> {
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in .zero }
    }
}

class ScreenManager: ObservableObject {
    @Published private(set) var screenSize: CGSize = UIScreen.size
    private var subscription: [AnyCancellable] = []

    init() { subscribeToScreenOrientationChangeEvents() }
}

private extension ScreenManager {
    func subscribeToScreenOrientationChangeEvents() {
        NotificationCenter.default
            .publisher(for: UIDevice.orientationDidChangeNotification)
            .receive(on: DispatchQueue.main)
            .sink { _ in self.screenSize = UIScreen.size }
            .store(in: &subscription)
    }
}

fileprivate extension UIScreen {
    static var size: CGSize { main.bounds.size }
}
