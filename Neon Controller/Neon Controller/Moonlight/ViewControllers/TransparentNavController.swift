//
//  TransparentNavController.swift
//  Neon Controller
//
//  Created by Yashua Evans on 10/18/23.
//

import Foundation

class TransparentNavController : UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = true
        
        // Set a background image (optional)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}
