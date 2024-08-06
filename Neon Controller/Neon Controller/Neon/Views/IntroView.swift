//
//  IntroView.swift
//  Neon Controller
//
//  Created by Yashua Evans on 8/8/23.
//

import SwiftUI

struct IntroView: View {
    
    let startTime = Date()
    let timeOffset = 0.5
    let durationPer = 1.5
        
    var body: some View {
        
        GeometryReader { geo in
            
            ZStack {
                
                AnimatedBackground()
                
                Image("LogoImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geo.size.width / 3, height: geo.size.width / 3)
                
                TimelineView(.animation) { timeline in
                    
                    Canvas { context, size in
                        let time = timeline.date.timeIntervalSince(startTime)
                        
                        let rect1_scale = (min(time, durationPer) / durationPer)
                        let rect1 = Path { path in
                            path.move(to: CGPoint(x: 0, y: 0 + rect1_scale * size.height / 2))
                            path.addLine(to: CGPoint(x: size.width, y: 0 + rect1_scale * size.height / 2))
                            path.addLine(to: CGPoint(x: size.width, y: size.height - rect1_scale * size.height / 2))
                            path.addLine(to: CGPoint(x: 0, y: size.height - rect1_scale * size.height / 2))
                            path.addLine(to: CGPoint(x: 0, y: 0))
                        }
                        
                        let rect2_scale = min(max(time - timeOffset, 0), durationPer) / durationPer
                        let rect2 = Path { path in
                            path.move(to: CGPoint(x: 0, y: 0 + rect2_scale * size.height / 2))
                            path.addLine(to: CGPoint(x: size.width, y: 0 + rect2_scale * size.height / 2))
                            path.addLine(to: CGPoint(x: size.width, y: size.height - rect2_scale * size.height / 2))
                            path.addLine(to: CGPoint(x: 0, y: size.height - rect2_scale * size.height / 2))
                            path.addLine(to: CGPoint(x: 0, y: 0))
                        }
                        
                        
                        let rect3_scale = min(max(time - 2 * timeOffset, 0), durationPer) / durationPer
                        let rect3 = Path { path in
                            path.move(to: CGPoint(x: 0, y: 0 + rect3_scale * size.height / 2))
                            path.addLine(to: CGPoint(x: size.width, y: 0 + rect3_scale * size.height / 2))
                            path.addLine(to: CGPoint(x: size.width, y: size.height - rect3_scale * size.height / 2))
                            path.addLine(to: CGPoint(x: 0, y: size.height - rect3_scale * size.height / 2))
                            path.addLine(to: CGPoint(x: 0, y: 0))
                        }
                        
                        
                        context.fill(rect3, with: .color(Color(UIColor(named: "Secondary")!)))
                        context.fill(rect2, with: .color(Color(UIColor(named: "Primary2")!)))
                        context.fill(rect1, with: .color(Color(UIColor(named: "Primary1")!)))

                    }
                }
            }
            .ignoresSafeArea()
        }
    }
}
