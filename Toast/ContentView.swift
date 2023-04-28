//
//  ContentView.swift
//  Toast
//
//  Created by iOS on 2023/4/27.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var context: LoadingManager
    @StateObject var timer = TimeHelp()
 
    var body: some View {
        List {
            HStack{
                ProgressView(value: timer.progress)
                    .frame(width: 60, height: 60)
                    .progressViewStyle(GaugeProgressStyle())
            }
            
            
            Section {
                Button {
                    context.text = nil
                    context.showLoading()
                    dismiss()
                } label: {
                    Text("Loading No Text")
                }
                
                Button {
                    context.text = "Please wait..."
                    context.showLoading()
                    dismiss()
                } label: {
                    Text("Loading Short Text")
                }
                
                Button {
                    context.text = "Please wait. We need some more time to work out this situation."
                    context.showLoading()
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
                    context.text = nil
                    context.showProgress()
                    
                } label: {
                    Text("Progress No Text")
                }
                
                Button {
                    startTimer()
                    context.text = "Please wait..."
                    context.showProgress()
                    
                } label: {
                    Text("Progress Short Text")
                }
                
                Button {
                    startTimer()
                    context.text = "Please wait. We need some more time to work out this situation."
                    context.showProgress()
                    
                } label: {
                    Text("Progress Longer text")
                }
            } header: {
                Text("Progress")
            }
            
            Section {
                Button {

                    context.text = nil
                    context.showSuccess()
 
                } label: {
                    Text("Success No Text")
                }
                
                Button {

                    context.text = "Please wait..."
                    context.showSuccess()
  
                } label: {
                    Text("Success Short Text")
                }
                
                Button {

                    context.text = "Please wait. We need some more time to work out this situation."
                    context.showSuccess()
     
                } label: {
                    Text("Success Longer text")
                }
            } header: {
                Text("Success")
            }
            
            Section {
                Button {

                    context.text = nil
                    context.showFailed()
  
                } label: {
                    Text("Failed No Text")
                }
                
                Button {

                    context.text = "Please wait..."
                    context.showFailed()
       
                } label: {
                    Text("Failed Short Text")
                }
                
                Button {

                    context.text = "Please wait. We need some more time to work out this situation."
                    context.showFailed()
         
                } label: {
                    Text("Failed Longer text")
                }
            } header: {
                Text("Failed")
            }

        }
        .addLoading(context)
        .onChange(of: timer.progress) { newValue in
            context.progress = newValue
            debugPrint("\(context.progress)")
            if newValue >= 1{
                timer.stop()
                context.showSuccess()
            }
        }
 
    }
    
    func dismiss(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            context.dismiss()
        }
    }
    
    func startTimer(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            timer.startTimer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @StateObject static private var context = LoadingManager()
    
    static var previews: some View {
        ContentView()
            .environmentObject(context)
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
