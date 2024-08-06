//  ComputerView.swift
//  Neon Controller
//
//  Created by Yashua Evans on 10/10/23.

import SwiftUI
import UIKit

struct TestViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        
        let storyboard = UIStoryboard(name: "iPhone", bundle: nil)
        let revealView = storyboard.instantiateViewController(identifier: "MainFrame") as! SWRevealViewController
        
        revealView.view.backgroundColor = UIColor.clear // Set the background color to clear
        
        return revealView
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Implement any updates here if needed
    }
}
