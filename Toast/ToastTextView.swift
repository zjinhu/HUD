//
//  ToastTextView.swift
//  Toast
//
//  Created by iOS on 2023/5/4.
//

import SwiftUI

struct ToastTextView: View {
    @EnvironmentObject var manager: ToastManager
    
    var text: String
    
    var body: some View {
        HStack{
            Image(systemName: "square.and.arrow.up")
            Text(text)
        }
        .padding(10)
        .foregroundColor(.white)
        .background(Color.blue.cornerRadius(8))
        
    }
}

struct ToastTextView_Previews: PreviewProvider {
    static var previews: some View {
        ToastTextView(text: "xxxx")
            .background(Color.blue.cornerRadius(8))
    }
}
