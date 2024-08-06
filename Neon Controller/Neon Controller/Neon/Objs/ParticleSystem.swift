//
//  ParticleSystem.swift
//  Neon Controller
//
//  Created by Yashua Evans on 8/8/23.
//

import Foundation
import SwiftUI

class ParticleSystem {
    
    let maxDistance : Double = 75
    
    var particles : [Particle] = []
    
    init(particleCount : Int, shapeCount : Int, bounds : Vector) {
        
        for _ in 0..<particleCount {
            self.particles.append(Particle(bounds))
        }
    }
    
    func update(bounds: Vector, date: TimeInterval) {
        
        for particle in self.particles {
            particle.update(bounds: bounds,timer : date)
        }
    }
    
    func draw(context: GraphicsContext) {
        for p1 in particles {
            let p1_origin = CGPoint(x: p1.position.x, y: p1.position.y)
            
            context.fill(Circle().path(in: CGRect(origin: p1_origin, size: CGSize(width: 1, height: 1))), with: .color(.white))
            
            for p2 in particles {
                
                let distance = p1.position.distance(p2.position)
                if(distance > maxDistance) { continue }
                
                let p2_origin = CGPoint(x: p2.position.x, y: p2.position.y)
                
                let line = Path { path in
                    path.move(to: p1_origin)
                    path.addLine(to: p2_origin)
                }
                
                context.stroke(line, with: .color(.white.opacity(1 - (distance / maxDistance))), lineWidth: 0.1)
            }
        }
    }
}
