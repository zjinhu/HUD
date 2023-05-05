//
//  PopupProtocol.swift
//  Show
//
//  Created by iOS on 2023/5/4.
//

import SwiftUI

/// Popup展示所在的位置
public enum PopupPosition {
    
    case top, bottom, center
    
    public var alignment: Alignment {
        switch self {
        case .top: return .top
        case .bottom: return .bottom
        case .center: return .center
        }
    }
}
/// 子类需要继承Popup协议
public protocol Popup: View, Identifiable, Equatable, Hashable{
    associatedtype V: View
    var id : UUID { get }
 
    /// Popup展示所在的位置
    var popupPosition: PopupPosition { get set }
    /// 子类创建页面布局
    func setupContent() -> V
    /// 配置Popup
    func configPopup(config: PopupConfig) -> PopupConfig
}

public extension Popup {
 
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var body: V{
        setupContent()
    }
    /// 配置Popup
    func configPopup(config: PopupConfig) -> PopupConfig {
        config
    }
    
    /// 弹出Popup
    func show() {
        PopupManager.shared.show(AnyPopup(self))
    }
    /// 关闭Popup
    func dismiss() { 
        PopupManager.shared.dismiss(id)
    }
}

/// 内部使用的通用协议
struct AnyPopup: Popup {
 
    let id: UUID
    var popupPosition: PopupPosition
 
    private let _body: AnyView
    private let _configBuilder: (PopupConfig) -> PopupConfig

    init(_ popup: some Popup) {
        self.id = popup.id
        self.popupPosition = popup.popupPosition
        self._body = AnyView(popup)
        self._configBuilder = popup.configPopup
    }
}

extension AnyPopup {
    func setupContent() -> AnyView {
        _body
    }
    
    func configPopup(config: PopupConfig) -> PopupConfig {
        _configBuilder(config)
    }
}
