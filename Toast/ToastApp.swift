//
//  ToastApp.swift
//  Toast
//
//  Created by iOS on 2023/4/27.
//

import SwiftUI

@main
struct ToastApp: App {
    @StateObject private var context = LoadingManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            .environmentObject(context) 
        }
    }
}
