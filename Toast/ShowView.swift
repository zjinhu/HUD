//
//  ShowView.swift
//  Toast
//
//  Created by iOS on 2023/4/27.
//

import SwiftUI

struct ShowView<Content: View>: View {
    public typealias ContentBuilder = (_ isActive: Bool) -> Content
    
    private let config: ShowConfig
    
    private let style: ShowStyle
    
    private let content: ContentBuilder
    
    @Binding
    private var isActive: Bool
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    public init( isActive: Binding<Bool>,
                 config: ShowConfig = .standard,
                 style: ShowStyle = .standard,
                 @ViewBuilder content: @escaping ContentBuilder ) {
        
        _isActive = isActive
        self.style = style
        self.config = config
        self.content = content
    }
    
    var body: some View {
        content(isActive)
            .background(background)
            .cornerRadius(style.cornerRadius ?? 1_000)
            .shadow(
                color: style.shadowColor,
                radius: style.shadowRadius,
                y: style.shadowOffset)
            .animation(.spring())
            .offset(x: 0, y: verticalOffset)
            .padding(style.padding)
    }
    
    @ViewBuilder
    var background: some View {
        if let color = style.backgroundColor {
            color
        } else {
            ShowStyle.standardBackgroundColor(for: colorScheme)
        }
    }
    
    var verticalOffset: CGFloat {
        if isActive { return 0 }
        switch style.edge {
        case .top: return -250
        case .bottom: return 250
        case .center: return 0
        }
    }
    
    func dismiss() {
        isActive = false
    }
}

public enum ShowLayout {
    
    case top, bottom, center
    public var alignment: Alignment {
        switch self {
        case .top: return .top
        case .center: return .center
        case .bottom: return .bottom
        }
    }
}

public struct ShowConfig {
    public static var standard = ShowConfig()
    
    public var animation: Animation
    
    public var duration: TimeInterval
    
    public init(animation: Animation = .spring(),
                duration: TimeInterval = 3) {
        self.animation = animation
        self.duration = duration
    }
}

public struct ShowStyle {
    
    public init(backgroundColor: Color? = nil,
                cornerRadius: CGFloat? = nil,
                padding: EdgeInsets? = nil,
                edge: ShowLayout = .top,
                shadowColor: Color = .black.opacity(0.1),
                shadowOffset: CGFloat = 5,
                shadowRadius: CGFloat = 7.5 ) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.padding = padding ?? Self.standardPadding
        self.edge = edge
        self.shadowColor = shadowColor
        self.shadowOffset = shadowOffset
        self.shadowRadius = shadowRadius
    }
    
    public static var standard = ShowStyle()
    
    @ViewBuilder
    public static func standardBackgroundColor(for colorScheme: ColorScheme) -> some View {
        if colorScheme == .light {
            Color.primary.colorInvert()
        } else {
            #if os(iOS)
            Color(UIColor.secondarySystemBackground)
            #elseif os(macOS)
            Color.primary.colorInvert()
            #elseif os(macOS)
            Color.secondary
                .colorInvert()
                .background(Color.white)
            #endif
        }
    }
    
    public static var standardPadding: EdgeInsets {
        #if os(iOS)
        EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        #else
        EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        #endif
    }
    
    public var backgroundColor: Color?
    
    public var cornerRadius: CGFloat?
    
    public var edge: ShowLayout
    
    public var padding: EdgeInsets
    
    public var shadowColor: Color
    
    public var shadowOffset: CGFloat
    
    public var shadowRadius: CGFloat
}

public extension View {
    
    func show<Content: View>(isActive: Binding<Bool>,
                             config: ShowConfig = .standard,
                             style: ShowStyle = .standard,
                             content: @escaping () -> Content) -> some View {
        ZStack(alignment: style.edge.alignment) {
            self

            ShowView(
                isActive: isActive,
                config: config,
                style: style,
                content: { _ in content() })
        }
    }
    
    func show(_ context: ShowContext ) -> some View {
        self.show(
            isActive: context.isActiveBinding,
            config: context.config,
            style: context.style,
            content: { context.content }
        )
    }
}

public class ShowContext: ObservableObject {
    
    public init() {}
    
    public typealias Action = () -> Void
    
    private var presentationId = UUID()

    @Published
    public var config = ShowConfig.standard
    
    @Published
    public var content = AnyView(EmptyView())
    
    @Published
    public var isActive = false
    
    @Published
    public var style = ShowStyle.standard

    @Published
    private var originalConfig: ShowConfig?
    
    @Published
    private var originalStyle: ShowStyle?

    public var isActiveBinding: Binding<Bool> {
        .init(get: { self.isActive },
              set: { self.isActive = $0 }
        )
    }
    
    public func dismiss() {
        dismiss {}
    }
    
    public func dismiss(completion: @escaping Action) {
        guard isActive else { return completion() }
        isActive = false
        perform(after: 0.3, action: completion)
    }
    
    public func present<Content: View>(content: Content,
                                       config: ShowConfig? = nil,
                                       style: ShowStyle? = nil) {
        dismiss {
            self.presentAfterDismiss(
                content: content,
                config: config,
                style: style
            )
        }
    }
    
    public func present<Content: View>(config: ShowConfig? = nil,
                                       style: ShowStyle? = nil,
                                       @ViewBuilder _ content: @escaping () -> Content) {
        present(
            content: content(),
            config: config,
            style: style
        )
    }
}

private extension ShowContext {
    
    func perform(_ action: @escaping Action, after seconds: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: action)
    }
    
    func perform(after seconds: TimeInterval, action: @escaping Action) {
        perform(action, after: seconds)
    }
    
    func presentAfterDismiss<Content: View>(content: Content,
                                            config: ShowConfig?,
                                            style: ShowStyle?) {
        let id = UUID()
        self.presentationId = id
        updateConfig(with: config)
        updateStyle(with: style)
        self.content = AnyView(content)
        perform(setActive, after: 0.1)
        perform(after: self.config.duration) {
            guard id == self.presentationId else { return }
            self.dismiss()
        }
    }
    
    func setActive() {
        isActive = true
    }
    
    func updateConfig(with config: ShowConfig?) {
        self.config = self.originalConfig ?? self.config
        self.originalConfig = self.config
        self.config = config ?? self.config
    }
    
    func updateStyle(with style: ShowStyle?) {
        self.style = self.originalStyle ?? self.style
        self.originalStyle = self.style
        self.style = style ?? self.style
    }
}

public struct ShowMessageStyle {
 
    public init(iconColor: Color = .primary.opacity(0.6),
        iconFont: Font = Font.title3,
        iconTextSpacing: CGFloat = 20,
        padding: CGSize = .init(width: 15, height: 7),
        textColor: Color = .primary.opacity(0.4),
        textFont: Font = Font.footnote.bold(),
        titleColor: Color = .primary.opacity(0.6),
        titleFont: Font = Font.footnote.bold(),
        titleTextSpacing: CGFloat = 2) {
        self.iconColor = iconColor
        self.iconFont = iconFont
        self.iconTextSpacing = iconTextSpacing
        self.padding = padding
        self.textColor = textColor
        self.textFont = textFont
        self.titleColor = titleColor
        self.titleFont = titleFont
        self.titleTextSpacing = titleTextSpacing
    }
 
    public static var standard = ShowMessageStyle()
 
    public var iconColor: Color
 
    public var iconFont: Font
 
    public var iconTextSpacing: CGFloat
 
    public var padding: CGSize
 
    public var textColor: Color
 
    public var textFont: Font
 
    public var titleColor: Color
 
    public var titleFont: Font
 
    public var titleTextSpacing: CGFloat
}

public struct ShowMessage<IconView: View>: View {
 
    public init(
        icon: IconView,
        title: String? = nil,
        text: String,
        style: ShowMessageStyle = .standard
    ) {
        self.icon = icon
        self.title = Self.title(for: title)
        self.text = LocalizedStringKey(text)
        self.style = style
    }
 
    public init(
        icon: Image,
        title: String? = nil,
        text: String,
        style: ShowMessageStyle = .standard
    ) where IconView == Image {
        self.icon = icon
        self.title = Self.title(for: title)
        self.text = LocalizedStringKey(text)
        self.style = style
    }
 
    public init(
        title: String? = nil,
        text: String,
        style: ShowMessageStyle = .standard
    ) where IconView == EmptyView {
        self.icon = EmptyView()
        self.title = Self.title(for: title)
        self.text = LocalizedStringKey(text)
        self.style = style
    }
    
    let icon: IconView
    let title: LocalizedStringKey?
    let text: LocalizedStringKey
    let style: ShowMessageStyle
    
    public var body: some View {
        HStack(spacing: style.iconTextSpacing) {
            iconView
            textContent
            iconView.opacity(0.001)
        }
        .padding(.vertical, style.padding.height)
        .padding(.horizontal, style.padding.width)
    }
}

private extension ShowMessage {

    static func title(for title: String?) -> LocalizedStringKey? {
        if let title = title {
            return LocalizedStringKey(title)
        } else {
            return nil
        }
    }
    
    var textContent: some View {
        VStack(spacing: style.titleTextSpacing) {
            if let title = title {
                Text(title)
                    .font(style.titleFont)
                    .foregroundColor(style.titleColor)
            }
            Text(text)
                .font(style.textFont)
                .foregroundColor(style.textColor)
        }
        .multilineTextAlignment(.center)
    }
    
    @ViewBuilder
    var iconView: some View {
        icon.font(style.iconFont)
            .foregroundColor(style.iconColor)
    }
}

struct ShowMessage_Previews: PreviewProvider {

    struct Preview: View {

        var body: some View {
            VStack {
                Group {
                    ShowMessage(
                        icon: Image(systemName: "bell.slash.fill"),
                        title: "Silent mode",
                        text: "On",
                        style: .init(iconColor: .red)
                    )

                    ShowMessage(
                        icon: Color.red.frame(width: 20, height: 20),
                        text: "Custom icon view, no title",
                        style: .init(iconColor: .red)
                    )

                    ShowMessage(
                        title: "No icon",
                        text: "On",
                        style: .init(iconColor: .red)
                    )

                    ShowMessage(
                        icon: Image(systemName: "exclamationmark.triangle"),
                        title: "Warning",
                        text: "This is a long message to demonstrate multiline messages.",
                        style: .init(
                            iconColor: .orange,
                            iconFont: .headline,
                            textColor: .orange,
                            titleColor: .orange,
                            titleFont: .headline
                        )
                    )
                }
                .background(Color.white)
                .cornerRadius(5)
                .padding()

            }.background(Color.gray)
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
