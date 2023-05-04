//
//  ToastApp.swift
//  Toast
//
//  Created by iOS on 2023/4/27.
//

import SwiftUI

@main
struct ToastApp: App {
    @StateObject private var loading = LoadingManager()
    @StateObject private var toast = ToastManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
            .environmentObject(loading)
            .environmentObject(toast)
        }
    }
}
