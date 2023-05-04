//
//  DemoNotification.swift
//  Toast
//
//  Created by iOS on 2023/4/27.
//

import SwiftUI

struct DemoNotification {
 
    static var error: some View {
        ShowMessage(
            icon: .error,
            title: "Error",
            text: "This is an error message that comes in from the bottom.",
            style: .init(
                iconColor: .white,
                textColor: .white,
                titleColor: .white,
                titleFont: .headline
            )
        )
    }
    
    static var errorStyle: ShowStyle {
        .init(backgroundColor: .red, edge: .bottom)
    }
 
    static var warning: some View {
        ShowMessage(
            icon: .warning,
            title: "Warning",
            text: "This is a long message to demonstrate multiline messages, which should center aligned and support many lines of text.",
            style: .init(
                iconColor: .white,
                iconFont: .headline,
                textColor: .white,
                titleColor: .white,
                titleFont: .headline
            )
        )
    }
    
    static var warningStyle: ShowStyle {
        .init(backgroundColor: .orange, edge: .top)
    }
}

 
extension Image {
    
    static let cover = Image(systemName: "rectangle.inset.fill")
    static let dismiss = Image(systemName: "xmark.circle")
    static let error = Image(systemName: "xmark.octagon")
    static let flag = Image(systemName: "flag")
    static let globe = Image(systemName: "globe")
    static let sheet = Image(systemName: "rectangle.bottomthird.inset.fill")
    static let silentModeOff = Image(systemName: "bell.fill")
    static let silentModeOn = Image(systemName: "bell.slash.fill")
    static let `static` = Image(systemName: "viewfinder")
    static let warning = Image(systemName: "exclamationmark.triangle")
}
