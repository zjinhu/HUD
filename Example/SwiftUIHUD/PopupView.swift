//
//  PopupTopView.swift
//  Show
//
//  Created by iOS on 2023/5/5.
//

import SwiftUI
import SwiftUIHUD
struct PopupTopView: HUD {
    var id: UUID = UUID()
    
    var position: HUDPosition = .top
    
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
    
    func setupConfig(_ config: HUDConfig) -> HUDConfig {
        config
            .backgroundColour(.blue)
            .cornerRadius(0)
            .touchOutsideToDismiss(true)
    }
}
 
struct PopCenterView: HUD {
    var id: UUID = UUID()
    var position: HUDPosition = .center
    @State private var note: String = ""
    func setupBody() -> some View  {
        VStack(spacing: 10){
            Text("Alert")
                .font(.system(size: 20, weight: .bold))
            
            Text("you have messages")
                .font(.system(size: 14))
            TextField("Add a note", text: $note)
                .foregroundColor(Color.red)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity)
            Text("\(id)")
                .font(.system(size: 10))
            
            HStack(spacing: 20){
                
                Button(action: dismiss) {
                    Text("dismiss")
                        .frame(maxWidth: .infinity)
                        .padding(10)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                             .stroke(.orange, lineWidth: 2)
                )
                .cornerRadius(10)
  
                Button(action: Self().show) {
                    Text("Show next")
                        .frame(maxWidth: .infinity)
                        .padding(10)
                }
                .background(Color.orange)
                .cornerRadius(10)
            }
            .padding(.horizontal, 30)
        }
        .padding(10)
        
    }
    func setupConfig(_ config: HUDConfig) -> HUDConfig {
        config
            .backgroundColour(.white)
            .horizontalPadding(20)
            .touchOutsideToDismiss(true)
            .cornerRadius(15) 
    }
}

struct PopCenterView_Previews: PreviewProvider {
    static var previews: some View {
        PopCenterView()
    }
}

struct PopBottomView: HUD {
    var id: UUID = UUID()
    var position: HUDPosition = .bottom
    @State private var note: String = ""
    
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
                
                TextField("Add a note", text: $note)
                    .foregroundColor(Color.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .frame(maxWidth: .infinity)
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
    
    func setupConfig(_ config: HUDConfig) -> HUDConfig {
        config.backgroundColour(.green)
             .touchOutsideToDismiss(true)
             .distanceFromKeyboard(30)
             .dragGestureEnabled(false)
    }
}
 
