//
//  ViewEx.swift
//  Toast
//
//  Created by iOS on 2023/4/27.
//

import SwiftUI

public extension View {
    
    private func addLoading<Content: View>(isActive: Binding<Bool>, content: @escaping () -> Content) -> some View {
        
        ZStack{
            self
            LoadingView(isActive: isActive, content: { _ in content() })
        }
    }
    ///添加loading,也可以WindowGroup里给ContentView添加
    func addLoading(_ ob: LoadingManager ) -> some View {
        self.addLoading(isActive: ob.isActiveBinding, content: { ob.content })
    }
}
