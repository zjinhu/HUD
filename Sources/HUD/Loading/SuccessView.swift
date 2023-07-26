//
//  SuccessView.swift
//  Show
//
//  Created by iOS on 2023/5/6.
//

import SwiftUI

public struct SuccessView: HUD {
    public var id: UUID = UUID()
    public var position: HUDPosition = .center
    
    @Binding public var text: String?
    //HUD提示字体颜色
    public var textColor = Color.white
    //HUD提示字体颜色
    public var textFont: Font = .system(size: 15, weight: .medium)
    //HUD Loading颜色
    public var accentColor = Color.white
    
    @State private var isActive = false
    
    public init(text: Binding<String?>) {
        self._text = text
    }
    
    public func setupBody() -> some View  {
        VStack(spacing: 10){
            SuccessShape()
                .trim(from: 0.0, to: isActive ? 1.0 : 0.0)
                .stroke(accentColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .animation(.easeInOut(duration: 0.5), value: UUID())
                .frame(width: 50, height: 50)
                .offset(x: -3)
            
            if let status = text, !status.isEmpty{
                Text("\(status)")
                    .font(textFont)
                    .foregroundColor(textColor)
            }
        }
        .padding(15) 
        .onAppear{
            isActive = true
        }
        .onDisappear{
            isActive = false
        } 
    }
    
    public func setupConfig(_ config: HUDConfig) -> HUDConfig {
        config
            .backgroundColour(.black.opacity(0.8))
            .maxStackCount(1)
            .needMask(false)
            .autoHidden(true)
            .autoHiddenTime(1)
            .horizontalPadding(50)
    }
}

struct SuccessView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessView(text: .constant("xxx"))
    }
}

struct SuccessShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.width * 0.1, y: rect.width * 0.5))
        path.addLine(to: CGPoint(x: rect.width * 0.5, y: rect.width * 0.8))
        path.addLine(to: CGPoint(x: rect.width * 1.0, y: rect.width * 0.1))
        return path
    }
}
