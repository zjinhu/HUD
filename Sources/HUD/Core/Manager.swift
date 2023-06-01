//
//  hudManager.swift
//  Show
//
//  Created by iOS on 2023/5/4.
//

import SwiftUI

public extension View {
    /// 添加popView控制器,需要弹窗的页面最外层添加
    func addHUD() -> some View {
        overlay(
            ContainerView()
        )
    }
}

public class HUDManager: ObservableObject {
    @Published var views: [AnyHUD] = []
    @Published var isPresent: Bool = false
    fileprivate var operationRecentlyPerformed: Bool = false
    static let shared = HUDManager()
    private init() {}
}

public extension HUDManager {
    /// 收起最后一个hud
    func dismissLast() {
        views.removeLast()
        dismissVC()
    }
    /// 收起指定hud
    func dismiss(_ id: UUID) {
        withAnimation{
            views.removeAll { vi in
                vi.id == id
            }
        }
        dismissVC()
    }
    /// 收起所有hud
    func dismissAll() {
        views.removeAll()
        dismissVC()
    }
    
    func dismissVC(){
        if views.isEmpty,
           let vc = UIApplication.shared.keyWindow?.rootViewController as? UIViewController,
           isPresent{
            DispatchQueue.main.async {
                vc.dismiss(animated: false) {
                    self.isPresent = false
                }
            }
        }
    }
}

extension HUDManager {
    /// 弹出hud
    func show(_ hud: AnyHUD, withStacking shouldStack: Bool = false) {

        DispatchQueue.main.async {
            if let vc = UIApplication.shared.keyWindow?.rootViewController as? UIViewController,
               vc.canUseVC(),
               !self.isPresent,
               self.canBeInserted(hud){
                let toPresent = UIHostingController(rootView: Color.clear.addHUD())
                toPresent.modalPresentationStyle = .overCurrentContext
                toPresent.modalTransitionStyle = .crossDissolve
                toPresent.view.backgroundColor = .clear
                
                vc.present(toPresent, animated: false) {
                    withAnimation{
                        self.addHud(hud, withStacking: shouldStack)
                    }
                    
                    self.isPresent = true
                }
                return
            }
 
            withAnimation{
                if self.canBeInserted(hud){
                    self.addHud(hud, withStacking: shouldStack)
                }
            }
        }
    }
    
    func addHud(_ hud: AnyHUD, withStacking shouldStack: Bool){
        views.perform(shouldStack ? .insertAndStack(hud) : .insertAndReplace(hud))
        let config = hud.setupConfig(Config())
        if config.autoDismiss {
            DispatchQueue.main.asyncAfter(deadline: .now() + config.autoDismissTime) {
                self.dismiss(hud.id)
            }
        }
    }
}

extension HUDManager {
    var tops: [AnyHUD] {
        views.compactMap { now in
            if now.position == .top{
                return now
            }
            return nil
        }
    }
    var centers: [AnyHUD] {
        views.compactMap { now in
            if now.position == .center{
                return now
            }
            return nil
        }
    }
    var bottoms: [AnyHUD] {
        views.compactMap { now in
            if now.position == .bottom{
                return now
            }
            return nil
        }
    }
}

private extension HUDManager {
    func canBeInserted(_ hud: AnyHUD) -> Bool {
        !views.contains { current in
            current.id == hud.id
        }
    }
}

fileprivate extension [AnyHUD] {
    enum Operation {
        case insertAndReplace(AnyHUD), insertAndStack(AnyHUD)
        case removeLast, remove(id: UUID), removeAll
    }
}
fileprivate extension [AnyHUD] {
    mutating func perform(_ operation: Operation) {
        guard !HUDManager.shared.operationRecentlyPerformed else { return }

        blockOtherOperations()
        hideKeyboard()
        performOperation(operation)
        liftBlockade()
    }
}

private extension [AnyHUD] {
    func canBeInserted(_ hud: AnyHUD) -> Bool {
        !contains { current in
            current.id == hud.id
        }
    }
}

private extension [AnyHUD] {
    func blockOtherOperations() {
        HUDManager.shared.operationRecentlyPerformed = true
    }
    func hideKeyboard() {
        UIApplication.shared.hideKeyboard()
    }
    mutating func performOperation(_ operation: Operation) {
        switch operation {
            case .insertAndReplace(let popup): replaceLast(popup, if: canBeInserted(popup))
            case .insertAndStack(let popup): append(popup, if: canBeInserted(popup))
            case .removeLast: removeLast()
            case .remove(let id): removeAll(where: { $0.id == id })
            case .removeAll: removeAll()
        }
    }
    func liftBlockade() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.44) { HUDManager.shared.operationRecentlyPerformed = false }
    }
}

fileprivate extension UIApplication {
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

import Combine

class KeyboardManager: ObservableObject {
    @Published private(set) var keyboardHeight: CGFloat = 0
    private var subscription: [AnyCancellable] = []

    init() { subscribeToKeyboardEvents() }
}

// MARK: - Creating Publishers
private extension KeyboardManager {
    func subscribeToKeyboardEvents() {
        Publishers.Merge(getKeyboardWillOpenPublisher(), createKeyboardWillHidePublisher())
            .debounce(for: .milliseconds(50), scheduler: DispatchQueue.main)
            .sink { self.keyboardHeight = $0 }
            .store(in: &subscription)
    }
}
private extension KeyboardManager {
    func getKeyboardWillOpenPublisher() -> Publishers.CompactMap<NotificationCenter.Publisher, CGFloat> {
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
            .map { max(0, $0.height - 8) }
    }
    func createKeyboardWillHidePublisher() -> Publishers.Map<NotificationCenter.Publisher, CGFloat> {
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in .zero }
    }
}

class ScreenManager: ObservableObject {
    @Published private(set) var screenSize: CGSize = UIScreen.size
    private var subscription: [AnyCancellable] = []

    init() { subscribeToScreenOrientationChangeEvents() }
}

private extension ScreenManager {
    func subscribeToScreenOrientationChangeEvents() {
        NotificationCenter.default
            .publisher(for: UIDevice.orientationDidChangeNotification)
            .receive(on: DispatchQueue.main)
            .sink { _ in self.screenSize = UIScreen.size }
            .store(in: &subscription)
    }
}


// MARK: - Helpers
fileprivate extension UIScreen {
    static var size: CGSize { main.bounds.size }
}
