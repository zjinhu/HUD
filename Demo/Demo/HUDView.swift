//
//  SwiftUIView.swift
//  HUDCombine
//
//  Created by iOS on 2023/5/15.
//

import SwiftUI
import HUD
struct HUDView: View {
    @StateObject var timer = TimeHelp()
 
    @State var loadingText: String?
    @State var loading: LoadingView?
    
    @State var progress: CGFloat = 0
    @State var progressView: StepView?
    @State var progressTextView: StepView?

    @State var fail = FailView(text: .constant(nil))
    
    @State var succ = SuccessView(text: .constant(""))
    
    @State var failText = FailView(text: .constant("Failed"))
    @State var succText = SuccessView(text: .constant("Success"))


    var body: some View {
        List {
            Section {
                Button {
                    loadingText = nil
                    loading?.show()
                    dismiss()
                } label: {
                    Text("Loading")
                }
                
                Button {
                    loadingText = "Loading"
                    loading?.show()
                    dismiss()
                } label: {
                    Text("Loading text")
                }
                
                Button {
                    loadingText = "Compares less than or equal to all positive numbers, but greater than zero. If the target supports subnormal values, this is smaller than leastNormalMagnitude; otherwise they are equal."
                    loading?.show()
                    dismiss()
                } label: {
                    Text("Loading long text")
                }
                
            } header: {
                Text("Loading")
            }
            
            Section {
                Button {
                    succ.show()
                } label: {
                    Text("Success No Text")
                }
    
                Button {
                    succText.show()
                } label: {
                    Text("Success Text")
                }
            } header: {
                Text("Success")
            }
            
            Section {
                Button {
                    startTimer()
                    progressView?.show()
                } label: {
                    Text("progress No Text")
                }
    
                Button {
                    startTimer()
                    progressTextView?.show()
                } label: {
                    Text("progress Text")
                }
            } header: {
                Text("progress")
            }
            
            Section {
                Button {
                    fail.show()
                } label: {
                    Text("Failed No Text")
                }

                Button {
                    failText.show()
                } label: {
                    Text("Failed Text")
                }
            } header: {
                Text("Failed")
            }
            
            Section {
                Button {
                    PopupTopView().show(useStack: true)
                } label: {
                    Text("Pop Top")
                }
 
                Button {
                    PopCenterView().show(useStack: true)
                } label: {
                    Text("Pop Center")
                }
                
                Button {
                    PopBottomView().show()
                } label: {
                    Text("Pop Bottom")
                }
                
            } header: {
                Text("PopupView")
            }
        }
        .addHUD()
        .onChange(of: timer.progress) { newValue in
            progress = newValue
            debugPrint("////////\(newValue)")
            if newValue >= 1{
                progressView?.dismiss()
                progressTextView?.dismiss()
                timer.stop()
                succ.show()
            }
        }
        .onAppear {
            loading = LoadingView(text: $loadingText)
            progressView = StepView(text: .constant(""), progress: $progress)
            progressTextView = StepView(text: .constant("Hello world"), progress: $progress)
        }

    }
    
    
    
    func dismiss(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            loading?.dismiss()
        }
    }
    
    func startTimer(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            timer.startTimer()
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        HUDView()
    }
}


import Combine
class TimeHelp: ObservableObject{
    @Published var progress: CGFloat = 0
    var canceller: AnyCancellable?
    
    func startTimer() {
        let timerPublisher = Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
 
        self.canceller = timerPublisher.sink { date in
            self.updateValue()
        }
    }
    
    func updateValue() {
        progress += 0.2
    }
    
    func stop() {
        canceller?.cancel()
        canceller = nil
        progress = 0
    }
}
import SwiftUI
import HUD
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
            Button {
                PopupTopView().show(useStack: true)
            } label: {
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
            .maxStackCount(5)
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
  
                Button {
                    PopCenterView().show(useStack: true)
                } label: {
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
            .maxStackCount(3)
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
            Button {
                PopBottomView().show(useStack: true)
            } label: {
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
 
