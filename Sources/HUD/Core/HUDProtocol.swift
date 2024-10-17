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
    ///标识唯一ID
    var id : UUID { get }
    /// hud展示所在的位置
    var position: HUDPosition { get set }
    /// 配置hud
    func setupConfig(_ config: HUDConfig) -> HUDConfig
    
}

public extension HUD {

    /// 配置hud
    func setupConfig(_ config: HUDConfig) -> HUDConfig {
        config
    }
    
    /// 弹出hud
    func showHUD(useStack: Bool = true) {
        HUDManager.shared.showHUD(AnyHUD(self), withStacking: useStack)
    }
    
    /// 关闭hud
    func hiddenHUD() {
        HUDManager.shared.hiddenHUD(id)
    }
    
    func hiddenAllHUD() {
        HUDManager.shared.hiddenAllHUD()
    }
}

/// 内部使用的通用协议
struct AnyHUD: HUD, Hashable {
    
    let id: UUID
    var position: HUDPosition
    
    private let _body: AnyView
    private let _configBuilder: (HUDConfig) -> HUDConfig
    
    init<H: HUD>(_ hud: H) {
        if let hud = hud as? AnyHUD {
            self = hud
        } else {
            self.id = hud.id
            self.position = hud.position
            self._body = AnyView(hud)
            self._configBuilder = hud.setupConfig
        }
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
    var body: some View { _body }
    
    func setupConfig(_ config: HUDConfig) -> HUDConfig {
        _configBuilder(config)
    }
}
