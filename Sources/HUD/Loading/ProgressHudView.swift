//
//  LoadingProgressView.swift
//  Show
//
//  Created by iOS on 2023/5/6.
//

import SwiftUI

public struct ProgressHudView: Hud {
    public var id: UUID = UUID()
    public var position: HudPosition = .center
    //HUD提示
    public var text: String?
    //HUD提示字体颜色
    public var textColor = Color.black
    //HUD提示字体颜色
    public var textFont: Font = .system(size: 15, weight: .medium)
    //HUD Loading颜色
    public var accentColor = Color.blue
    ///进度条进度 0--1
    @Binding public var progress: CGFloat
    
    public func setupBody() -> some View  {
        VStack(spacing: 10){
            ProgressView(value: progress)
                .frame(width: 50, height: 50)
                .progressViewStyle(GaugeProgressStyle(strokeColor: accentColor))
            
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

struct GaugeProgressStyle: ProgressViewStyle {
    var strokeColor = Color.blue
    var strokeWidth = 8.0
    
    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0
        
        return ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.5), style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
            
            Circle()
                .trim(from: 0, to: fractionCompleted)
                .stroke(strokeColor, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
            
            Text("\(String(format: "%.f", fractionCompleted*100))%")
        }
    }
}
