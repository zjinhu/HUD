//
//  PopupManager.swift
//  Show
//
//  Created by iOS on 2023/5/4.
//

import SwiftUI

public extension View {
    /// 添加popView控制器,需要弹窗的页面最外层添加
    func addPopupView() -> some View {
        overlay(
            PopupView() 
        )
    }
}

public class PopupManager: ObservableObject {
    @Published var views: [AnyPopup] = []
    static let shared = PopupManager()
    private init() {}
}

public extension PopupManager {
    /// 收起最后一个Popup
    func dismissLast() {
        views.removeLast()
    }
    /// 收起指定Popup
    func dismiss(_ id: UUID) {
        views.removeAll { vi in
            vi.id == id
        }
    }
    /// 收起所有Popup
    func dismissAll() {
        views.removeAll()
    }
}

extension PopupManager {
    /// 弹出Popup
    func show(_ popup: AnyPopup) {
        DispatchQueue.main.async {
            withAnimation(nil) {
                if self.canBeInserted(popup){
                    self.views.append(popup)
                }
            }
        }
    }
}

extension PopupManager {
    var tops: [AnyPopup] {
        views.compactMap { now in
            if now.popupPosition == .top{
                return now
            }
            return nil
        }
    }
    var centers: [AnyPopup] {
        views.compactMap { now in
            if now.popupPosition == .center{
                return now
            }
            return nil
        }
    }
    var bottoms: [AnyPopup] {
        views.compactMap { now in
            if now.popupPosition == .bottom{
                return now
            }
            return nil
        }
    }
}

private extension PopupManager {
    func canBeInserted(_ popup: AnyPopup) -> Bool {
        !views.contains { current in
            current.id == popup.id
        }
    }
}

