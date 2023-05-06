//
//  ContentView.swift
//  Toast
//
//  Created by iOS on 2023/4/27.
//

import SwiftUI

struct ContentView: View {

    @StateObject var timer = TimeHelp()
 
    @State var loading = LoadingView()
    @State var loadingText = LoadingView(text: "loading...")
    @State var loadingLong = LoadingView(text: "Compares less than or equal to all positive numbers, but greater than zero. If the target supports subnormal values, this is smaller than leastNormalMagnitude; otherwise they are equal.")
    @State var toast = ToastView(text: "loading...")
    @State var toastTop = ToastView(position: .top, text: "loading...")
    
    @State var succ = SuccessView()
    @State var fail = FailedView()
    
    @State var progress: CGFloat = 0
    
    @State var progressView: ProgressHudView?
 
    var body: some View {
        List {

            Section {

                Button {
                    loading.text = nil
                    loading.show()
                    dismiss()
                } label: {
                    Text("Loading")
                }
                
                Button {
 
                    loadingText.show()
                    dismiss()
                } label: {
                    Text("Loading text")
                }
                
                Button {
                    loadingLong.show()
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
    
            } header: {
                Text("progress")
            }
            
            Section {
                Button {
                    fail.show()
                } label: {
                    Text("Failed No Text")
                }

            } header: {
                Text("Failed")
            }

            Section {
                Button {
                    toast.show()
                } label: {
                    Text("Toast at bottom")
                }

                Button {
                    toastTop.show()
                } label: {
                    Text("Toast at Top")
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
        .addHudView()
        .onChange(of: timer.progress) { newValue in
            progress = newValue
            debugPrint("\(newValue)")
            if newValue >= 1{
                progressView?.dismiss()
                timer.stop()
                succ.show()
            }
        }
        .onAppear {
            progressView = ProgressHudView(progress: $progress)
        }

    }
    
    func dismiss(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            loading.dismiss()
            loadingLong.dismiss()
            loadingText.dismiss()
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
