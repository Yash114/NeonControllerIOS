//
//  ViewObj3DRepresentable.swift
//  Neon Controller
//
//  Created by Yashua Evans on 12/10/23.
//

import Foundation
import UIKit
import SwiftUI
import SceneKit

struct ViewObjc3DRepresentable : UIViewRepresentable {
    typealias UIViewType = SCNView
        
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        
        // Create a SceneKit scene
        let scene = SCNScene()
        sceneView.scene = scene

        // Configure camera and lighting
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera!.usesOrthographicProjection = true // Enable orthographic projection
        cameraNode.camera!.orthographicScale = 2.0 // Adjust the scale as needed
        scene.rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3(0, 0, 5)

        sceneView.backgroundColor = .clear
        
        let spawnTimer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true, block: { t in
            let randomShape = arc4random_uniform(2)
            
            var shapeGeometry : SCNGeometry!
            if(randomShape == 0) {
                shapeGeometry = SCNPyramid(width: 0.5, height: 0.5, length: 0.5)
            } else if (randomShape == 1) {
                shapeGeometry = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0)

            }

            
            let sm = "float u = _surface.diffuseTexcoord.x; \n" +
                "float v = _surface.diffuseTexcoord.y; \n" +
                "int u100 = int(u * 100); \n" +
                "int v100 = int(v * 100); \n" +
                "if (u100 % 99 == 0 || v100 % 99 == 0) { \n" +
                "  // do nothing \n" +
                "} else { \n" +
                "    discard_fragment(); \n" +
                "} \n"

            shapeGeometry.firstMaterial?.shaderModifiers = [SCNShaderModifierEntryPoint.surface: sm]

            shapeGeometry.firstMaterial?.multiply.contents = UserData.isPremium ? UIColor(cgColor: (Color(hex: "#FFFFD700")?.cgColor)!) : UIColor.purple

            shapeGeometry.firstMaterial?.isDoubleSided = true
                    
            let cubeNode = SCNNode(geometry: shapeGeometry)
            
            let randomXPos = Int(arc4random_uniform(8)) - 4

            cubeNode.position = SCNVector3(randomXPos, 3, 0)
            
            let moveLeftAction = SCNAction.move(to: SCNVector3(randomXPos, -3, 0), duration: 20.0)
            cubeNode.runAction(moveLeftAction)

            
            // Create a rotation action
            let randomX = arc4random_uniform(4) + 5
            let randomY = arc4random_uniform(4) + 5
            let randomZ = arc4random_uniform(4) + 5

            let rotateAction = SCNAction.rotateBy(x: CGFloat(Float.pi / Float(randomX)), y: CGFloat(Float.pi / Float(randomY)), z: CGFloat(Float.pi / Float(randomZ)), duration: 3.0) // Rotate 180 degrees around the Y-axis in 3 seconds
            
            // Repeat the rotation action forever
            let repeatAction = SCNAction.repeatForever(rotateAction)
            
            
            cubeNode.runAction(repeatAction)

            scene.rootNode.addChildNode(cubeNode)
            
            Timer.scheduledTimer(withTimeInterval: 20, repeats: false) { t in
                cubeNode.removeFromParentNode()
            }
        })

        spawnTimer.fire()

        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .directional
        ambientLightNode.light?.color = UIColor(white: 0.75, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)
        
        
        return sceneView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}
