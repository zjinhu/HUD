//
//  Ex.swift
//  Show
//
//  Created by iOS on 2023/5/4.
//

import SwiftUI
// MARK: -Alignments
extension View {
    func alignToBottom(_ value: CGFloat = 0) -> some View {
        VStack(spacing: 0) {
            Spacer()
            self
            Spacer().frame(height: value)
        }
    }
    func alignToTop(_ value: CGFloat = 0) -> some View {
        VStack(spacing: 0) {
            Spacer().frame(height: value)
            self
            Spacer()
        }
    }
}

// MARK: -Others
extension View {
    @ViewBuilder func active(if condition: Bool) -> some View {
        if condition { self }
    }
    
    func visible(if condition: Bool) -> some View {
        opacity(condition.doubleValue)
    }
}

extension View {
    func clearCacheObjects(shouldClear: Bool, trigger: Binding<Bool>) -> some View {
        onChange(of: shouldClear) { $0 ? trigger.toggleAfter(seconds: 0.4) : () }
        .id(trigger.wrappedValue)
    }
}

extension Binding<Bool> {
    func toggleAfter(seconds: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            wrappedValue.toggle()
        }
    }
}

extension UIScreen {
    static let safeArea: UIEdgeInsets = {
        UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow})
            .first?
            .safeAreaInsets ?? .zero
    }()
}

extension Int {
    var doubleValue: Double { Double(self) }
    var floatValue: CGFloat { CGFloat(self) }
}

extension Bool {
    var doubleValue: Double { self ? 1 : 0 }
    var floatValue: CGFloat { self ? 1 : 0 }
}

extension Array {
    @inlinable mutating func append(_ newElement: Element, if prerequisite: Bool) {
        if prerequisite { append(newElement) }
    }
    @inlinable mutating func replaceLast(_ newElement: Element, if prerequisite: Bool) {
        guard prerequisite else { return }

        switch isEmpty {
            case true: append(newElement)
            case false: self[count - 1] = newElement
        }
    }
    @inlinable mutating func removeLast() {
        if !isEmpty {
            removeLast(1)
        }
    }
}

public extension Color {
    static let defaultBackground = Color.dynamic(light: .white, dark: .init(red: 0.11, green: 0.11, blue: 0.11))

    static func dynamic(light: Color, dark: Color) -> Color {
        let l = UIColor(light)
        let d = UIColor(dark)
        return UIColor.dynamicColor(light: l, dark: d).toColor()
    }

    func toUIColor() -> UIColor {
        return UIColor(self)
    }
}

extension UIColor {
    
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else { return light }
        return UIColor { $0.userInterfaceStyle == .dark ? dark : light }
    }

    func toColor() -> Color {
        return Color(self)
    }
}

extension UIViewController{
   func canUseVC() -> Bool {
       if let _ = self as? UITabBarController {
           // tabBar 的跟控制器
           return true
       } else if let _ = self as? UINavigationController {
           // 控制器是 nav
           return true
       } else {
           // 返回顶控制器
           return false
       }
   }
}

extension UIApplication {
   var keyWindow: UIWindow? {
       connectedScenes
           .compactMap {  $0 as? UIWindowScene }
           .flatMap { $0.windows }
           .first { $0.isKeyWindow }
   }
}
