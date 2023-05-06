//
//  hudProtocol.swift
//  Show
//
//  Created by iOS on 2023/5/4.
//

import SwiftUI

/// hud展示所在的位置
public enum HudPosition {
    
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
public protocol Hud: View, Equatable, Hashable{
    associatedtype V: View
    ///标识唯一ID
    var id : UUID { get }
    /// hud展示所在的位置
    var position: HudPosition { get set }
    /// 子类创建页面布局
    func setupBody() -> V
    /// 配置hud
    func setupConfig(_ config: Config) -> Config
}

public extension Hud {
 
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var body: V{
        setupBody()
    }
    /// 配置hud
    func setupConfig(_ config: Config) -> Config {
        config
    }
    
    /// 弹出hud
    func show() {
        HudManager.shared.show(AnyHud(self))
    }
    /// 关闭hud
    func dismiss() { 
        HudManager.shared.dismiss(id)
    }
}

/// 内部使用的通用协议
struct AnyHud: Hud {
 
    let id: UUID
    var position: HudPosition
 
    private let _body: AnyView
    private let _configBuilder: (Config) -> Config

    init(_ hud: some Hud) {
        self.id = hud.id
        self.position = hud.position
        self._body = AnyView(hud)
        self._configBuilder = hud.setupConfig
    }
}

extension AnyHud {
    func setupBody() -> AnyView {
        _body
    }
    
    func setupConfig(_ config: Config) -> Config {
        _configBuilder(config)
    }
}
