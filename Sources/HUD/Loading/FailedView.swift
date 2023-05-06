//
//  FailedView.swift
//  Show
//
//  Created by iOS on 2023/5/6.
//

import SwiftUI

struct FailedView: Hud {
    var id: UUID = UUID()
    var position: HudPosition = .center
    
    var text: String?
    //HUD提示字体颜色
    var textColor = Color.black
    //HUD提示字体颜色
    var textFont: Font = .system(size: 15, weight: .medium)
    //HUD Loading颜色
    var accentColor = Color.blue
    
    @State var isActive = false
    
    func setupBody() -> some View  {
        VStack(spacing: 10){
            
            XShape()
                .trim(from: 0.0, to: isActive ? 1.0 : 0.0)
                .stroke(accentColor, style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                .animation(.easeInOut(duration: 0.5), value: UUID())
                .frame(width: 50, height: 50)
            
            if let status = text{
                Text("\(status)")
                    .font(textFont)
                    .foregroundColor(textColor)
            }
        }
        .padding(15)
        .background(BlurView())
        .shadow(color: .black.opacity(0.5), radius: 5, y: 5)
        .onAppear{
            isActive = true
        }
        .onDisappear{
            isActive = false
        } 
    }
    
    func setupConfig(_ config: Config) -> Config {
        config
            .backgroundColour(.white)
            .maxStackCount(1)
            .needMask(false)
            .autoDismiss(true)
            .autoDismissTime(1)
    }
}

struct FailedView_Previews: PreviewProvider {
    static var previews: some View {
        FailedView()
    }
}

struct XShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.width * 0.15, y: rect.width * 0.15))
        path.addLine(to: CGPoint(x: rect.width * 0.85, y: rect.width * 0.85))
        path.move(to: CGPoint(x: rect.width * 0.15, y: rect.width * 0.85))
        path.addLine(to: CGPoint(x: rect.width * 0.85, y: rect.width * 0.15))
        return path
    }
}
