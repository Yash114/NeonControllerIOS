//
//  Shape3D.swift
//  Neon Controller
//
//  Created by Yashua Evans on 8/8/23.
//

import Foundation
import SwiftUI
import SceneKit
import UIKit

class Shape3D {

    let Cube = 0
    let Pyramid = 1
    let Tetrahedron = 2

    let topSpeed = 5

    var position : Vector
    var velocity : Vector
    var shape : Int = 0

    var bounds : Vector

    init(bounds : Vector) {
        self.bounds = bounds

        self.position = bounds.randomWithin(Vector(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height))

        let angle = Double.random(in: 0..<360)
        self.velocity = Vector(x: Double(topSpeed) * cos(angle), y: Double(topSpeed) * sin(angle))
    }

    func update() {
        self.position.add(self.velocity)
        self.position.constrain(self.bounds)
        
        if(self.position.x > self.bounds.x || self.position.x < 0) {
            self.velocity.x *= -1
        }
        
        if(self.position.y > self.bounds.y || self.position.y < 0) {
            self.velocity.y *= -1
        }
    }
}
