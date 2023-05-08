//
//  ContentView.swift
//  Toast
//
//  Created by iOS on 2023/4/27.
//

import SwiftUI

struct ContentView: View {

    @StateObject var timer = TimeHelp()
 
    @State var loadingText: String?
    @State var loading: LoadingView?
    
    @State var progress: CGFloat = 0
    @State var progressView: StepView?
    @State var progressTextView: StepView?

    
    @State var toast = ToastView(text: .constant("Toast"))
    @State var toastTop = ToastView(position: .top, text: .constant("Compares less than or equal to all positive numbers, but greater than zero. If the target supports subnormal values, this is smaller than leastNormalMagnitude; otherwise they are equal."))
    
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
        .addHUD()
        .onChange(of: timer.progress) { newValue in
            progress = newValue
            debugPrint("\(newValue)")
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
