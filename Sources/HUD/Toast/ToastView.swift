//
//  ToastView.swift
//  Show
//
//  Created by iOS on 2023/5/6.
//

import SwiftUI

public struct ToastView: HUD {
    
    public var position: HUDPosition = .bottom
    public var id: UUID = UUID()
    
    @Binding public var text: String
    
    public init(position: HUDPosition = .bottom,
                text: Binding<String>) {
        self.position = position
        self._text = text
    }
    
    public func setupBody() -> some View  {
        Text(text)
            .multilineTextAlignment(.center)
            .padding(15)
            .foregroundColor(.white)
            .background(
                Color.black
                    .opacity(0.8)
                    .cornerRadius(8)
            )
    }
    
    public func setupConfig(_ config: Config) -> Config {
        config
            .backgroundColour(.clear)
            .maxStackCount(1)
            .needMask(false)
            .autoDismiss(true)
            .horizontalPadding(20)
    }
    
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        ToastView(text: .constant("Compares less than or equal to all positive numbers, but greater than zero. If the target supports subnormal values, this is smaller than leastNormalMagnitude; otherwise they are equal."))
    }
}
