//
//  PopupTopView.swift
//  Show
//
//  Created by iOS on 2023/5/5.
//

import SwiftUI

struct PopupTopView: Hud {
    var id: UUID = UUID()
    
    var position: HudPosition = .top
    
    func setupBody() -> some View  {
        HStack(spacing: 0) {
            
            Image("grad")
                .resizable()
                .frame(width: 40, height: 40)
                .aspectRatio(contentMode: .fill)
                .mask(Circle())
            
            Spacer().frame(width: 15)
            
            VStack(alignment: .leading, spacing: 0) {
                Text("John Clark")
                    .foregroundColor(.white)
                Text("Great idea, let’s do it 🍄️")
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
            Button(action: Self().show) {
                Text("Show next".uppercased())
                    .foregroundColor(.white)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 24)
    }
    
    func setupConfig(config: Config) -> Config {
        config
            .backgroundColour(.blue)
            .cornerRadius(0)
    }
}
 
struct PopCenterView: Hud {
    var id: UUID = UUID()
    var position: HudPosition = .center
    
    func setupBody() -> some View  {
        VStack{
            Text("title")
                .font(.system(size: 20, weight: .bold))
            Text("text\(id)")
                .font(.system(size: 14))
            HStack{
                
                Button(action: dismiss) {
                    Text("dismiss")
                        .padding(10)
                }
                .background(Color.gray)
                
                Spacer()
                
                Button(action: Self().show) {
                    Text("Show next")
                        .padding(10)
                }
                .background(Color.orange)
            }
            .padding(15)
        }
        .padding(10)
        
    }
    func setupConfig(config: Config) -> Config {
        config
            .backgroundColour(.white)
            .horizontalPadding(20)
            .touchOutsideToDismiss(true)
            .cornerRadius(15)
    }
}

struct PopBottomView: Hud {
    var id: UUID = UUID()
    var position: HudPosition = .bottom
    
    func setupBody() -> some View  {
        HStack(spacing: 0) {
            
            Image("grad")
                .resizable()
                .frame(width: 40, height: 40)
                .aspectRatio(contentMode: .fill)
                .mask(Circle()) 
            
            Spacer().frame(width: 15)
            
            VStack(alignment: .leading, spacing: 0) {
                Text("John Clark")
                    .foregroundColor(.white)
                Text("Great idea, let’s do it 🍄️")
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
            Button(action: Self().show) {
                Text("Show next".uppercased())
                    .foregroundColor(.white)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 24)
    }
    func setupConfig(config: Config) -> Config {
        config.backgroundColour(.green)
    }
}
 
