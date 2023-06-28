//
//  MessageView.swift
//  HUDCombine
//
//  Created by iOS on 2023/5/23.
//

import SwiftUI
import SwiftMessages
struct MessageView: View {
    var body: some View {
        Button {
            let hostVC = UIHostingController(rootView: PopView())
            let messageView = BaseView(frame: .zero)
            messageView.installContentView(hostVC.view)
            messageView.configureDropShadow()
            var config = SwiftMessages.defaultConfig
            config.presentationStyle = .top
            config.dimMode = .gray(interactive: true)
            config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
            SwiftMessages.show(config: config, view: messageView)
        } label: {
            Text("123")
        }

    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
    }
}
