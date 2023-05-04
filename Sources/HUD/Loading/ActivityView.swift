//
//  GaugeProgressView.swift
//  Toast
//
//  Created by iOS on 2023/4/27.
//

import SwiftUI

struct LoadProgressView: View {
    @EnvironmentObject var manager: LoadingManager
    
    var body: some View {
        VStack{
            ProgressView()
                .scaleEffect(2.5)
                .frame(width: 50, height: 50)
                .progressViewStyle(CircularProgressViewStyle(tint: manager.accentColor))
            
            if let status = manager.text{
                Text("\(status)")
                    .font(manager.textFont)
                    .foregroundColor(manager.textColor)
            }
        }
        .padding(10)
    }
}

struct GaugeProgressView: View {
    @EnvironmentObject var manager: LoadingManager
    
    var body: some View {
        VStack{
            ProgressView(value: manager.progress)
                .frame(width: 50, height: 50)
                .progressViewStyle(GaugeProgressStyle(strokeColor: manager.accentColor))
            
            if let status = manager.text{
                Text("\(status)")
                    .font(manager.textFont)
                    .foregroundColor(manager.textColor)
            }
        }
        .padding(10)
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

struct SuccessShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.width * 0.1, y: rect.width * 0.5))
        path.addLine(to: CGPoint(x: rect.width * 0.5, y: rect.width * 0.8))
        path.addLine(to: CGPoint(x: rect.width * 1.0, y: rect.width * 0.1))
        return path
    }
}

struct SuccessView: View {
    @EnvironmentObject var manager: LoadingManager
    var body: some View {
        VStack{
            SuccessShape()
                .trim(from: 0.0, to: manager.isActive ? 1.0 : 0.0)
                .stroke(manager.accentColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .animation(.easeInOut(duration: 0.5), value: UUID())
                .frame(width: 50, height: 50)
                .offset(x: -3)
            
            if let status = manager.text{
                Text("\(status)")
                    .font(manager.textFont)
                    .foregroundColor(manager.textColor)
            }
        }
        .padding(10)
    }
}

struct XShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.width * 0.15, y: rect.width * 0.15))
        path.addLine(to: CGPoint(x: rect.width * 0.85, y: rect.width * 0.85))
        path.move(to: CGPoint(x: rect.width * 0.85, y: rect.width * 0.15))
        path.addLine(to: CGPoint(x: rect.width * 0.15, y: rect.width * 0.85))
        return path
    }
}

struct FailedView: View {
    @EnvironmentObject var manager: LoadingManager
    @State private var isDrawn = false
    var body: some View {
        VStack{
            XShape()
                .trim(from: 0.0, to: manager.isActive ? 1.0 : 0.0)
                .stroke(manager.accentColor, style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                .animation(.easeInOut(duration: 0.5), value: UUID())
                .frame(width: 50, height: 50)

            
            if let status = manager.text{
                Text("\(status)")
                    .font(manager.textFont)
                    .foregroundColor(manager.textColor)
            }
        }
        .padding(10)
    }
}
