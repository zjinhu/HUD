//
//  hudProtocol.swift
//  Show
//
//  Created by iOS on 2023/5/4.
//

import SwiftUI

/// hud展示所在的位置
public enum HUDPosition {
    
    case top, bottom, center
    
    public var alignment: Alignment {
        switch self {
        case .top: return .top
        case .bottom: return .bottom
        case .center: return .center
        }
    }
}

/// 子类需要继承hud协议
public protocol HUD: View{
    associatedtype V: View
    ///标识唯一ID
    var id : UUID { get }
    /// hud展示所在的位置
    var position: HUDPosition { get set }
    /// 子类创建页面布局
    func setupBody() -> V
    /// 配置hud
    func setupConfig(_ config: HUDConfig) -> HUDConfig
    
}

public extension HUD {

    var body: V{
        setupBody()
    }
    /// 配置hud
    func setupConfig(_ config: HUDConfig) -> HUDConfig {
        config
    }
    
    /// 弹出hud
    func show(useStack: Bool = true) {
        HUDManager.shared.show(AnyHUD(self), withStacking: useStack)
    }
    
    /// 关闭hud
    func dismiss() { 
        HUDManager.shared.dismiss(id)
    }
    
    func dismissAll() {
        HUDManager.shared.dismissAll()
    }
}

/// 内部使用的通用协议
struct AnyHUD: HUD, Hashable {
    
    let id: UUID
    var position: HUDPosition
    
    private let _body: AnyView
    private let _configBuilder: (HUDConfig) -> HUDConfig
    
    init(_ hud: some HUD) {
        self.id = hud.id
        self.position = hud.position
        self._body = AnyView(hud)
        self._configBuilder = hud.setupConfig
    }
}

extension AnyHUD {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension AnyHUD {
    func setupBody() -> AnyView {
        _body
    }
    
    func setupConfig(_ config: HUDConfig) -> HUDConfig {
        _configBuilder(config)
    }
}
