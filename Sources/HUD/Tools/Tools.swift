//
//  Ex.swift
//  Show
//
//  Created by iOS on 2023/5/4.
//

import SwiftUI
// MARK: -Alignments
extension View {
    func align(to edge: Edge, _ value: CGFloat?) -> some View { padding(.init(edge), value)
            .frame(
                maxHeight: value != nil ? .infinity : nil,
                alignment: edge.toAlignment()
            )
    }
}

fileprivate extension Edge {
    func toAlignment() -> Alignment {
        switch self {
            case .top: return .top
            case .bottom: return .bottom
            case .leading: return .leading
            case .trailing: return .trailing
        }
    }
}

extension View {
    func frame(size: CGSize) -> some View {
        frame(width: size.width, height: size.height)
    }
}

extension View {
    func clearCacheObjects(shouldClear: Bool, trigger: Binding<Bool>) -> some View {
        onChange(of: shouldClear) {
            $0 ? trigger.toggleAfter(seconds: 0.4) : ()
        }
        .id(trigger.wrappedValue)
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

extension Binding<Bool> {
    func toggleAfter(seconds: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            wrappedValue.toggle()
        }
    }
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
    
    @inlinable mutating func removeAllUpToElement(where predicate: (Element) -> Bool) {
        if let index = lastIndex(where: predicate) { removeLast(count - index - 1)
        }
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
    
    var nextToLast: Element? {
        count >= 2 ? self[count - 2] : nil
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

extension View {
    func background(_ colour: Color, radius: CGFloat, corners: RectCorner) -> some View {
        background(RoundedCorner(radius: radius, corners: corners)
            .fill(colour))
    }
}

// MARK: - Implementation
fileprivate struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: RectCorner
    
    
    var animatableData: CGFloat {
        get { radius }
        set { radius = newValue }
    }
    func path(in rect: CGRect) -> Path {
        let points = createPoints(rect)
        let path = createPath(rect, points)
        return path
    }
}
private extension RoundedCorner {
    func createPoints(_ rect: CGRect) -> [CGPoint] {
        [
            .init(x: rect.minX, y: corners.contains(.topLeft) ? rect.minY + radius  : rect.minY),
            .init(x: corners.contains(.topLeft) ? rect.minX + radius : rect.minX, y: rect.minY ),
            .init(x: corners.contains(.topRight) ? rect.maxX - radius : rect.maxX, y: rect.minY ),
            .init(x: rect.maxX, y: corners.contains(.topRight) ? rect.minY + radius  : rect.minY ),
            .init(x: rect.maxX, y: corners.contains(.bottomRight) ? rect.maxY - radius : rect.maxY ),
            .init(x: corners.contains(.bottomRight) ? rect.maxX - radius : rect.maxX, y: rect.maxY ),
            .init(x: corners.contains(.bottomLeft) ? rect.minX + radius : rect.minX, y: rect.maxY ),
            .init(x: rect.minX, y: corners.contains(.bottomLeft) ? rect.maxY - radius : rect.maxY )
        ]
    }
    
    func createPath(_ rect: CGRect, _ points: [CGPoint]) -> Path {
        var path = Path()
        
        path.move(to: points[0])
        path.addArc(tangent1End: CGPoint(x: rect.minX, y: rect.minY), tangent2End: points[1], radius: radius)
        path.addLine(to: points[2])
        path.addArc(tangent1End: CGPoint(x: rect.maxX, y: rect.minY), tangent2End: points[3], radius: radius)
        path.addLine(to: points[4])
        path.addArc(tangent1End: CGPoint(x: rect.maxX, y: rect.maxY), tangent2End: points[5], radius: radius)
        path.addLine(to: points[6])
        path.addArc(tangent1End: CGPoint(x: rect.minX, y: rect.maxY), tangent2End: points[7], radius: radius)
        path.closeSubpath()
        
        return path
    }
}

// MARK: - Rect Corner Structure
struct RectCorner: OptionSet {
    let rawValue: Int
}

extension RectCorner {
    static let topLeft = RectCorner(rawValue: 1 << 0)
    static let topRight = RectCorner(rawValue: 1 << 1)
    static let bottomRight = RectCorner(rawValue: 1 << 2)
    static let bottomLeft = RectCorner(rawValue: 1 << 3)
    static let allCorners: RectCorner = [.topLeft, topRight, .bottomLeft, .bottomRight]
}

extension View {
    func readHeight(_ onChange: @escaping (CGFloat) -> ()) -> some View {
        modifier(Modifier(onHeightChange: onChange))
    }
}

fileprivate struct Modifier: ViewModifier {
    let onHeightChange: (CGFloat) -> ()

    func body(content: Content) -> some View { content
        .background(
            GeometryReader { geo -> Color in
                DispatchQueue.main.async { onHeightChange(geo.size.height) }
                return Color.clear
            }
        )
    }
}

#if os(iOS) || os(macOS)
extension View {
    func onTapGesture(perform action: @escaping () -> ()) -> some View {
        onTapGesture(count: 1, perform: action)
    }
    
    func onDragGesture(onChanged actionOnChanged: @escaping (CGFloat) -> (), onEnded actionOnEnded: @escaping (CGFloat) -> ()) -> some View {
        simultaneousGesture(createDragGesture(actionOnChanged, actionOnEnded))
    }
}
private extension View {
    func createDragGesture(_ actionOnChanged: @escaping (CGFloat) -> (), _ actionOnEnded: @escaping (CGFloat) -> ()) -> some Gesture {
        DragGesture()
            .onChanged {
                actionOnChanged($0.translation.height)
            }
            .onEnded {
                actionOnEnded($0.translation.height)
            }
    }
}
#endif

#if os(tvOS)
extension View {
    func onTapGesture(perform action: () -> ()) -> some View { self
    }
    func onDragGesture(onChanged actionOnChanged: (CGFloat) -> (),
                       onEnded actionOnEnded: (CGFloat) -> ()) -> some View {
        self
    }
}
#endif

extension View {

    func focusSectionIfAvailable() -> some View {
    #if os(iOS) || os(macOS)
        self
    #elseif os(tvOS)
        focusSection()
    #endif
    }

}

public enum AnimationType { case spring, linear, easeInOut }
extension AnimationType {
    var entry: Animation {
        switch self {
            case .spring: return .spring(response: 0.4, dampingFraction: 1, blendDuration: 0.1)
            case .linear: return .linear(duration: 0.4)
            case .easeInOut: return .easeInOut(duration: 0.4)
        }
    }
    var removal: Animation {
        switch self {
            case .spring: return .interactiveSpring(response: 0.14, dampingFraction: 1, blendDuration: 1)
            case .linear: return .linear(duration: 0.3)
            case .easeInOut: return .easeInOut(duration: 0.3)
        }
    }
}
