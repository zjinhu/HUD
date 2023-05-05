//
//  ContentView.swift
//  Toast
//
//  Created by iOS on 2023/4/27.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var loading: LoadingManager
    @EnvironmentObject private var toast: ToastManager

    @StateObject var timer = TimeHelp()
 
    var body: some View {
        List {

            Section {
                Button {
                    loading.text = nil
                    loading.showLoading()
                    dismiss()
                } label: {
                    Text("Loading No Text")
                }
                
                Button {
                    loading.text = "Please wait..."
                    loading.showLoading()
                    dismiss()
                } label: {
                    Text("Loading Short Text")
                }
                
                Button {
                    loading.text = "Please wait. We need some more time to work out this situation."
                    loading.showLoading()
                    dismiss()
                } label: {
                    Text("Loading Longer text")
                }
            } header: {
                Text("Loading")
            }
            
            Section {
                Button {
                    startTimer()
                    loading.text = nil
                    loading.showProgress()
                    
                } label: {
                    Text("Progress No Text")
                }
                
                Button {
                    startTimer()
                    loading.text = "Please wait..."
                    loading.showProgress()
                    
                } label: {
                    Text("Progress Short Text")
                }
                
                Button {
                    startTimer()
                    loading.text = "Please wait. We need some more time to work out this situation."
                    loading.showProgress()
                    
                } label: {
                    Text("Progress Longer text")
                }
            } header: {
                Text("Progress")
            }
            
            Section {
                Button {

                    loading.text = nil
                    loading.showSuccess()
 
                } label: {
                    Text("Success No Text")
                }
                
                Button {

                    loading.text = "Please wait..."
                    loading.showSuccess()
  
                } label: {
                    Text("Success Short Text")
                }
                
                Button {

                    loading.text = "Please wait. We need some more time to work out this situation."
                    loading.showSuccess()
     
                } label: {
                    Text("Success Longer text")
                }
            } header: {
                Text("Success")
            }
            
            Section {
                Button {

                    loading.text = nil
                    loading.showFailed()
  
                } label: {
                    Text("Failed No Text")
                }
                
                Button {

                    loading.text = "Please wait..."
                    loading.showFailed()
       
                } label: {
                    Text("Failed Short Text")
                }
                
                Button {

                    loading.text = "Please wait. We need some more time to work out this situation."
                    loading.showFailed()
         
                } label: {
                    Text("Failed Longer text")
                }
            } header: {
                Text("Failed")
            }

            Section {
                Button {
                    toast.position = .bottom
                    toast.showText("Toast at bottom")
  
                } label: {
                    Text("Toast at bottom")
                }
                
                Button {
                    toast.position = .top
                    toast.showText("Toast at top")
  
                } label: {
                    Text("Toast at top")
                }

            } header: {
                Text("Toast")
            }
            
            Section {
                Button {
                    PopupTopView().show()
                } label: {
                    Text("Pop Top")
                }
 
                Button {
                    PopCenterView().show()
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
        .addLoading(loading)
        .onChange(of: timer.progress) { newValue in
            loading.progress = newValue
            debugPrint("\(loading.progress)")
            if newValue >= 1{
                timer.stop()
                loading.showSuccess()
            }
        }
        .addToast(toast)
        .addPopupView()
 
    }
    
    func dismiss(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            loading.dismiss()
        }
    }
    
    func startTimer(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            timer.startTimer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
            .environmentObject(LoadingManager())
            .environmentObject(ToastManager())
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
