//
//  Vector.swift
//  Neon Controller
//
//  Created by Yashua Evans on 8/8/23.
//

import Foundation
import SwiftUI

class Vector {
    var x : Double
    var y : Double
    
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    func randomWithin(_ bounds : Vector) -> Vector  {
        let randX = Double.random(in: 0..<bounds.x)
        let randY = Double.random(in: 0..<bounds.y)

        return Vector(x: randX, y: randY)
    }
    
    func add(_ other : Vector) {
        self.x = self.x + other.x
        self.y = self.y + other.y
    }
    
    func constrain(_ other : Vector) {
        self.x = self.x > other.x ? other.x : self.x
        self.x = self.x < 0 ? 0 : self.x

        self.y = self.y > other.y ? other.y : self.y
        self.y = self.y < 0 ? 0 : self.y
    }
    
    func invert(_ xVal : Bool, _ yVal : Bool) {
        self.x = self.x * (xVal ? -1 : 1)
        self.y = self.y * (yVal ? -1 : 1)
    }
    
    static func multiply(_ vector : Vector, multi: Double) -> Vector {
        return Vector(x: vector.x * multi, y: vector.y * multi)
    }
    
    func distance(_ other : Vector) -> Double {
        return sqrt(pow(other.x - self.x, 2) + pow(other.y - self.y, 2))
    }
    
    
}

