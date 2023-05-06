//
//  ToastView.swift
//  Show
//
//  Created by iOS on 2023/5/6.
//

import SwiftUI

struct ToastView: Hud {
    
    var position: HudPosition = .bottom
    var id: UUID = UUID()
    
    public var text: String
    
    func setupBody() -> some View  {
        Text(text)
            .padding(10)
            .foregroundColor(.white)
            .background(
                Color.black
                    .opacity(0.8)
                    .cornerRadius(8)
            )
    }

    func setupConfig(config: Config) -> Config {
        config
            .backgroundColour(.clear)
            .maxStackCount(1)
            .needMask(false)
            .autoDismiss(true)
    }
    
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        ToastView(text: "123123")
    }
}
