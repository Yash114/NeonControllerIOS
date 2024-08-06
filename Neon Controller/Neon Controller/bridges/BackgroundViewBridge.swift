//
//  BackgroundViewBridge.swift
//  Neon Controller
//
//  Created by Yashua Evans on 10/18/23.
//

import SwiftUI
import UIKit

class BackgroundViewBridge: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBSegueAction func embedSwiftUIView(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: AnimatedBackground())

    }
}
