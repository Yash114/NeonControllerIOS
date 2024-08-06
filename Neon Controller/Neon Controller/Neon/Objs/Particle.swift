//
//  Particle.swift
//  Neon Controller
//
//  Created by Yashua Evans on 8/8/23.
//

import Foundation
import SwiftUI

struct Particle {
    
    var position : Vector
    var velocity : Vector
    @SwiftUI.State var bounds : Vector

    let topSpeed = 0.1
    
    init(_ bounds : Vector) {
        
        self.bounds = bounds
        
        self.position = Vector(x: Double.random(in: 0..<bounds.x), y: Double.random(in: 0..<bounds.y))
        
        let angle = Double.random(in: 0..<360)
        self.velocity = Vector(x: Double(topSpeed) * cos(angle), y: Double(topSpeed) * sin(angle))
    }
    
    func update(bounds: Vector, timer : TimeInterval) {
        self.bounds = bounds
        position.add(velocity)
        
        velocity.invert(
            self.position.x > bounds.x || self.position.x < 0,
            self.position.y > bounds.y || self.position.y < 0)

        
        self.position.constrain(bounds)
    }
}
