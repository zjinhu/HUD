//
//  hudManager.swift
//  Show
//
//  Created by iOS on 2023/5/4.
//

import SwiftUI

public extension View {
    /// 添加popView控制器,需要弹窗的页面最外层添加
    func addHudView() -> some View {
        overlay(
            ContainerView() 
        )
    }
}

public class HudManager: ObservableObject {
    @Published var views: [AnyHud] = []
    static let shared = HudManager()
    private init() {}
}

public extension HudManager {
    /// 收起最后一个hud
    func dismissLast() {
        views.removeLast()
    }
    /// 收起指定hud
    func dismiss(_ id: UUID) {
        views.removeAll { vi in
            vi.id == id
        }
    }
    /// 收起所有hud
    func dismissAll() {
        views.removeAll()
    }
}

extension HudManager {
    /// 弹出hud
    func show(_ hud: AnyHud) {
        DispatchQueue.main.async {
            withAnimation{
                if self.canBeInserted(hud){
                    self.views.append(hud)
                    let config = hud.setupConfig(Config())
                    if config.autoDismiss {
                        DispatchQueue.main.asyncAfter(deadline: .now() + config.autoDismissTime, execute: self.dismissLast)
                    }
                }
            }
        }
    }
}

extension HudManager {
    var tops: [AnyHud] {
        views.compactMap { now in
            if now.position == .top{
                return now
            }
            return nil
        }
    }
    var centers: [AnyHud] {
        views.compactMap { now in
            if now.position == .center{
                return now
            }
            return nil
        }
    }
    var bottoms: [AnyHud] {
        views.compactMap { now in
            if now.position == .bottom{
                return now
            }
            return nil
        }
    }
}

private extension HudManager {
    func canBeInserted(_ hud: AnyHud) -> Bool {
        !views.contains { current in
            current.id == hud.id
        }
    }
}

