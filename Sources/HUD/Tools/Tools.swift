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

// MARK: -Content Height Reader
extension View {
    func readHeight(onChange action: @escaping (CGFloat) -> ()) -> some View {
        background(heightReader).onPreferenceChange(HeightPreferenceKey.self, perform: action)
    }
}

private extension View {
    var heightReader: some View {
        GeometryReader {
            Color.clear.preference(key: HeightPreferenceKey.self, value: $0.size.height)
        }
    }
}

fileprivate struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

// MARK: -Others
extension View {
    @ViewBuilder func active(if condition: Bool) -> some View {
        if condition { self }
    }
}

extension UIScreen {
    static let width: CGFloat = main.bounds.size.width
    static let height: CGFloat = main.bounds.size.height
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
    
    @inlinable mutating func removeLast() {
        if !isEmpty {
            removeLast(1)
        }
    }
}
