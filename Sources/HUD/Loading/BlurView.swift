//
//  BlurView.swift
//  Toast
//
//  Created by iOS on 2023/4/27.
//

import SwiftUI
import Foundation
#if os(macOS)
import AppKit
struct BlurView: NSViewRepresentable {
    typealias NSViewType = NSView
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        view.wantsLayer = true
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        nsView.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.6).cgColor
    }
}
#else
import UIKit
struct BlurView: UIViewRepresentable {
    typealias UIViewType = GlassmorphismView
    
    func makeUIView(context: Context) -> GlassmorphismView {
        let glassmorphismView = GlassmorphismView()
        return glassmorphismView
    }
    
    func updateUIView(_ uiView: GlassmorphismView, context: Context) {
        uiView.setBlurDensity(with: 0.1) 
    }
}

class GlassmorphismView: UIView {

    private let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear)
    private var blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private var animatorCompletionValue: CGFloat = 0.2
    private let backgroundView = UIView()
    public override var backgroundColor: UIColor? {
        get {
            return .clear
        }
        set {}
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialize()
    }
    
    deinit {
        animator.pauseAnimation()
        animator.stopAnimation(true)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }

    public func setBlurDensity(with density: CGFloat) {
        self.animatorCompletionValue = (1 - density)
        self.animator.fractionComplete = animatorCompletionValue
    }

    private func initialize() {

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(backgroundView, at: 0)
        
        blurView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.heightAnchor.constraint(equalTo: self.heightAnchor),
            backgroundView.widthAnchor.constraint(equalTo: self.widthAnchor),
            blurView.topAnchor.constraint(equalTo: self.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            blurView.heightAnchor.constraint(equalTo: self.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])

        animator.addAnimations {
            self.blurView.effect = nil
        }
        animator.fractionComplete = animatorCompletionValue
    }
 
}
#endif
