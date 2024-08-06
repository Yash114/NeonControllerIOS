//
//  3DobjcView.swift
//  Neon Controller
//
//  Created by Yashua Evans on 12/10/23.
//

import Foundation
import UIKit
import SceneKit

class ViewObj3D : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create a SceneKit view and add it to your view controller's view
//        let sceneView = SCNView(frame: self.view.frame)
//        self.view.addSubview(sceneView)
//
//        // Create a SceneKit scene
//        let scene = SCNScene()
//        sceneView.scene = scene
        
//        // Create a 3D box
//        let boxGeometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
//        let boxNode = SCNNode(geometry: boxGeometry)
//        scene.rootNode.addChildNode(boxNode)
//
//        // Position the box in the scene
//        boxNode.position = SCNVector3(0.0, 0.0, -5.0)
        
        // Create and add a camera to the scene
//        let cameraNode = SCNNode()
//        cameraNode.camera = SCNCamera()
//        scene.rootNode.addChildNode(cameraNode)
//        cameraNode.position = SCNVector3(0, 0, 10)

//        // Add ambient light to the scene
//        let ambientLightNode = SCNNode()
//        ambientLightNode.light = SCNLight()
//        ambientLightNode.light?.type = .ambient
//        ambientLightNode.light?.color = UIColor(white: 0.75, alpha: 1.0)
//        scene.rootNode.addChildNode(ambientLightNode)
        
        self.view.backgroundColor = .clear
    }
    
}
