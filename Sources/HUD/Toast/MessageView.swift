//
//  ToastTextView.swift
//  Toast
//
//  Created by iOS on 2023/5/4.
//

import SwiftUI

public struct MessageView: View {
    
    public var text: String
    
    public var body: some View {
        Text(text)
            .padding(10)
            .foregroundColor(.white)
            .background(
                Color.black
                    .opacity(0.8)
                    .cornerRadius(8)
            )
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(text: "xxxx")
            .background(Color.black
                .opacity(0.8)
                .cornerRadius(8)
            )
    }
}
