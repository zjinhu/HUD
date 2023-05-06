//
//  LoadingView.swift
//  Show
//
//  Created by iOS on 2023/5/6.
//

import SwiftUI

public struct LoadingView: Hud {
    public var id: UUID = UUID()
    public var position: HudPosition = .center
    
    public var text: String?
    //HUD提示字体颜色
    public var textColor = Color.black
    //HUD提示字体颜色
    public var textFont: Font = .system(size: 15, weight: .medium)
    //HUD Loading颜色
    public var accentColor = Color.blue
    
    public func setupBody() -> some View  {
        VStack(spacing: 10){
            ProgressView()
                .scaleEffect(2)
                .frame(width: 50, height: 50)
                .progressViewStyle(CircularProgressViewStyle(tint: accentColor))
            
            if let status = text{
                Text("\(status)")
                    .font(textFont)
                    .foregroundColor(textColor)
            }
        }
        .padding(15) 
    }
    
    public func setupConfig(_ config: Config) -> Config {
        config
            .backgroundColour(.white)
            .maxStackCount(1)
            .needMask(true)
            .horizontalPadding(50)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
