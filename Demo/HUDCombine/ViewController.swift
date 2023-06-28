//
//  ViewController.swift
//  HUDCombine
//
//  Created by iOS on 2023/5/15.
//

import UIKit
import SwiftUI
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let hostVC = UIHostingController(rootView: HUDView())
        hostVC.view.frame = view.bounds
        addChild(hostVC)
        view.addSubview(hostVC.view)
        hostVC.didMove(toParent: self)
    }

}

