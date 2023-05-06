//
//  LoadingProgressView.swift
//  Show
//
//  Created by iOS on 2023/5/6.
//

import SwiftUI

struct LoadingProgressView: Hud {
    var id: UUID = UUID()
    var position: HudPosition = .center
    //HUD提示
    var text: String?
    //HUD提示字体颜色
    var textColor = Color.black
    //HUD提示字体颜色
    var textFont: Font = .system(size: 15, weight: .medium)
    //HUD Loading颜色
    var accentColor = Color.blue
    ///进度条进度 0--1
    @State var progress: CGFloat = 0
    
    func setupBody() -> some View  {
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
    
    func setupConfig(config: Config) -> Config {
        config
            .backgroundColour(.blue)
            .cornerRadius(10)
            .maxStackCount(1)
    }
}

struct LoadingProgressView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingProgressView()
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
