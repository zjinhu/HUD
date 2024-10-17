//
//  LoadingProgressView.swift
//  Show
//
//  Created by iOS on 2023/5/6.
//

import SwiftUI

public struct StepView: HUD {
    public var id: UUID = UUID()
    public var position: HUDPosition = .center
    //HUD提示
    @Binding public var text: String?
    //HUD提示字体颜色
    public var textColor = Color.white
    //HUD提示字体颜色
    public var textFont: Font = .system(size: 15, weight: .medium)
    //HUD Loading颜色
    public var accentColor = Color.white
    ///进度条进度 0--1
    @Binding public var progress: CGFloat
    
    public init(text: Binding<String?>,
                progress: Binding<CGFloat>) {
        self._text = text
        self._progress = progress
    }
    
    public var body: some View {
        VStack(spacing: 10){
            ProgressView(value: progress)
                .frame(width: 70, height: 70)
                .progressViewStyle(GaugeProgressStyle(strokeColor: accentColor))
            
            if let status = text, !status.isEmpty{
                Text("\(status)")
                    .font(textFont)
                    .foregroundColor(textColor)
            }
        }
        .padding(15)
    }
    
    public func setupConfig(_ config: HUDConfig) -> HUDConfig {
        config
            .backgroundColour(.black.opacity(0.8))
            .maxStackCount(1)
            .needMask(true)
            .horizontalPadding(50)
    }
}

struct StepView_Previews: PreviewProvider {
    static var previews: some View {
        StepView(text: .constant("Progressing"), progress: .constant(0.5))
            .previewLayout(.sizeThatFits)
            .background(Color.purple)
            .cornerRadius(10)
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
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
        }
    }
}
