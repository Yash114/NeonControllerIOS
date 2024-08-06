//
//  NeonViewController.swift
//  Moonlight
//
//  Created by Yashua Evans on 10/15/23.
//  Copyright © 2023 Moonlight Game Streaming Project. All rights reserved.
//

import SwiftUI
import UIKit

@objc class MySwiftUIHostingController: UIHostingController<RootView> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: MySwiftUIView())
    }
}
