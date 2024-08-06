//
//  ConstellationsViewController.swift
//  Neon Controller
//
//  Created by Yashua Evans on 10/18/23.
//

import UIKit

class ControllerOverlayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBSegueAction func embedSwiftUIView(_ coder: NSCoder) -> ConstellationsViewController? {
        return ConstellationsViewController(coder: coder)
    }
}
