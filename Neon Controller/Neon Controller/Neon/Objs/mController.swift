//
//  Layout.swift
//  Neon Controller
//
//  Created by Yashua Evans on 8/9/23.
//

import Foundation

@objc class mController: NSObject {
    static func == (lhs: mController, rhs: mController) -> Bool {
        return lhs.controllerID == rhs.controllerID
    }
    
    static let defaultUUID = "98nssh9aha"
    
    var controllerName : String!
    var controllerDescription : String!
    var controllerID : String!
    
    @objc var buttons = [ControlButton]()
    
    @objc var isGyro = false
    @objc var gyroSensitivity = 0.5;
    @objc var gyroThreshold = 0.5;
    

    
    override init() {
        self.controllerName = "Default"
        self.controllerDescription = "Default On-Screen Controller"
        self.controllerID = mController.defaultUUID
    }
        
    init(controllerName : String, controllerDescription : String, id: String) {
        self.controllerName = controllerName
        self.controllerDescription = controllerDescription
        self.controllerID = id
    }
    
    init(controllerName : String, controllerDescription : String) {
        self.controllerName = controllerName
        self.controllerDescription = controllerDescription
        self.controllerID = String().randomString(length: 7)
    }
    
    init(ref : mController) {
        
        self.buttons.append(contentsOf: ref.buttons)
        
        self.controllerName = ref.controllerName
        self.controllerDescription = ref.controllerDescription
        self.controllerID = ref.controllerID
        
    }
    
    func updateButtons(buttons: [ControlButton]) {
        self.buttons = buttons
    }
    
    init(controllerID : String) {
        
        super.init()
        
        self.controllerID = controllerID

        if let controller = SaveController.GetLayout(self) {
            self.buttons.append(contentsOf: controller.buttons)
            
            self.controllerName = controller.controllerName
            self.controllerDescription = controller.controllerDescription
            self.controllerID = controller.controllerID
        }
    }
    
    func delete() {
        UserData.savedControllers.removeAll { Controller in Controller == self }
        SaveController.SaveLayouts()
    }
    
    func save() {
        SaveController.SaveLayout(self)
        
        UserData.savedControllers.removeAll { Controller in Controller == self }
        UserData.savedControllers.append(self)
        UserData.currentController = self
        
        SaveController.SaveLayouts()
    }
    
    func retrieve() {
        if let gotController = SaveController.GetLayout(self) {
            
            self.buttons = gotController.buttons
            self.controllerName = gotController.controllerName
            self.controllerDescription = gotController.controllerDescription
            self.controllerID = gotController.controllerID
            
        }
    }
    
}
