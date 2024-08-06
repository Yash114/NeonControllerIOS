//
//  SaveController.swift
//  Neon Controller
//
//  Created by Yashua Evans on 9/4/23.
//

import Foundation
import SwiftUI

class SaveController {
    
    struct DefaultsKeys {
        static let controllerListKey = "y237fuhe9w8"
        static let selectedControllerKey = "82995y9rn83y489"
        
        static let controllerName = "hg438g7923vn8"
        static let controllerDiscription = "oqwthvn39 h "
        static let controllerButtonCount = "4g287t98328g8fb"
        
        static let controllerIsGyro = "e8vntqr9efbhw9"
        static let controllerGyroSensitivity = "e9g7t8n3249evuwb8"
        static let controllerGyroThreshold = "wynf8ewbqch9"

        
        
        static let buttonType = "29h8bu32b"
        
        static let buttonPositionKeyX = "fo32nfin329"
        static let buttonPositionKeyY = "hw9feufunwe"
        static let buttonSize = "g4h38qb9n3h"

        static let buttonKeybindKey = "8349843h9h32r"
        static let buttonNameKey = "3928ngjg0gu3"
        static let buttonShowNameKey = "9hgaw0eb9wa0u"
        static let buttonEnabledHapticsKey = "h9f2n0b9un3"
        
        static let buttonButtonColor = "yfn893fhe9vfb"
        
        static let isPremiumFlag = "t79r86dyrtufyg"
    }
    
    public static func SaveLayouts() {
        
        let defaults = UserDefaults.standard
        defaults.set(
            UserData.savedControllers.map({ Controller in Controller.controllerID }),
            forKey: DefaultsKeys.controllerListKey
        )
    }
    
    public static func SaveLayout(_ controller : mController) {
        
        let controllerPrefix = controller.controllerID + ":"

        let defaults = UserDefaults.standard
        
        //Save Controller Attr
        defaults.set(controller.controllerName, forKey: controllerPrefix + DefaultsKeys.controllerName)
        defaults.set(controller.controllerDescription, forKey: controllerPrefix + DefaultsKeys.controllerDiscription)
        defaults.set(controller.buttons.count, forKey: controllerPrefix + DefaultsKeys.controllerButtonCount)
        
        defaults.set(controller.isGyro, forKey: controllerPrefix + DefaultsKeys.controllerIsGyro)
        defaults.set(controller.gyroThreshold, forKey: controllerPrefix + DefaultsKeys.controllerGyroThreshold)
        defaults.set(controller.gyroSensitivity, forKey: controllerPrefix + DefaultsKeys.controllerGyroSensitivity)

        
        //Save Buttons
        for (index, button) in controller.buttons.enumerated() {
            let buttonPrefix = controllerPrefix + index.description + ":"
            SaveButton(buttonPrefix: buttonPrefix, button: button)
        }
        
    }
    
    private static func SaveButton(buttonPrefix : String, button: ControlButton) {
                                
        let defaults = UserDefaults.standard
        defaults.set(button.type.rawValue, forKey: buttonPrefix + DefaultsKeys.buttonType)
        
        defaults.set(button.position.width, forKey: buttonPrefix + DefaultsKeys.buttonPositionKeyX)
        defaults.set(button.position.height, forKey: buttonPrefix + DefaultsKeys.buttonPositionKeyY)

        defaults.set(button.size, forKey: buttonPrefix + DefaultsKeys.buttonSize)

        defaults.set(button.keybind, forKey: buttonPrefix + DefaultsKeys.buttonKeybindKey)
        defaults.set(button.name, forKey: buttonPrefix + DefaultsKeys.buttonNameKey)
        defaults.set(button.showName, forKey: buttonPrefix + DefaultsKeys.buttonShowNameKey)
        defaults.set(button.isHapticsEnabled, forKey: buttonPrefix + DefaultsKeys.buttonEnabledHapticsKey)
        
        print("Color Saved:", button.color.toARGBHexString())
        
        defaults.set(button.color.toARGBHexString(), forKey: buttonPrefix + DefaultsKeys.buttonButtonColor)
    }
    
    public static func GetLayout(_ controller : mController) -> mController? {
                
        let controllerPrefix = controller.controllerID + ":"

        let defaults = UserDefaults.standard
        
        let controllerName = defaults.string(forKey: controllerPrefix + DefaultsKeys.controllerName)
        let controllerDescription = defaults.string(forKey: controllerPrefix + DefaultsKeys.controllerDiscription)
        
        if(controllerName != nil && controllerDescription != nil) {
            let outputController = mController(controllerName: controllerName!, controllerDescription: controllerDescription!, id: controller.controllerID )
            
            let buttonCount = defaults.integer( forKey: controllerPrefix + DefaultsKeys.controllerButtonCount)
            
            controller.gyroSensitivity = defaults.double(forKey: controllerPrefix + DefaultsKeys.controllerGyroSensitivity)
            controller.gyroThreshold = defaults.double(forKey: controllerPrefix + DefaultsKeys.controllerGyroThreshold)
            
            controller.isGyro = defaults.bool(forKey: controllerPrefix + DefaultsKeys.controllerIsGyro)

            
            for i in 0..<buttonCount {
                let buttonPrefix = controllerPrefix + i.description + ":"
                outputController.buttons.append( GetButton(buttonPrefix: buttonPrefix))
            }
            
            return outputController
        }
        
        return nil
    }
    
    public static func SaveFlags() {
        let defaults = UserDefaults.standard

        defaults.set(UserData.isPremium, forKey: DefaultsKeys.isPremiumFlag)
    }
    
    public static func GetFlags() {
        let defaults = UserDefaults.standard
        
        UserData.isPremium = defaults.bool(forKey: DefaultsKeys.isPremiumFlag)

    }
    
    private static func GetButton(buttonPrefix : String) -> ControlButton {

        let outputButton = ControlButton()
        let defaults = UserDefaults.standard

        outputButton.type =  ControlButton.type(rawValue: defaults.integer(forKey: buttonPrefix + DefaultsKeys.buttonType))!
        
        let xPos = defaults.double(forKey: buttonPrefix + DefaultsKeys.buttonPositionKeyX)
        let yPos = defaults.double(forKey: buttonPrefix + DefaultsKeys.buttonPositionKeyY)

        outputButton.position = CGSize(width: xPos, height: yPos)
        
        outputButton.size = defaults.double(forKey: buttonPrefix + DefaultsKeys.buttonSize)
        
        outputButton.color = Color(hex: defaults.string(forKey: buttonPrefix + DefaultsKeys.buttonButtonColor) ?? "#FFFFFFFF")!
        
        print("Color Recieved:", defaults.string(forKey: buttonPrefix + DefaultsKeys.buttonButtonColor))


        outputButton.keybind = defaults.string(forKey: buttonPrefix + DefaultsKeys.buttonKeybindKey)!
        outputButton.name = defaults.string(forKey: buttonPrefix + DefaultsKeys.buttonNameKey)!
        outputButton.showName = defaults.bool(forKey: buttonPrefix + DefaultsKeys.buttonShowNameKey)
        outputButton.isHapticsEnabled = defaults.bool(forKey: buttonPrefix + DefaultsKeys.buttonEnabledHapticsKey)
        
        return outputButton
        
    }
    
    public static func SaveSelectedController(_ controller : mController) {
        let defaults = UserDefaults.standard
        defaults.set(
            controller.controllerID,
            forKey: DefaultsKeys.selectedControllerKey
        )
        
        UserData.currentController = controller
        
        print("th439uno saved default:" , controller.controllerID)

    }
    
    public static func GetLayouts() -> [mController] {
        
        var defaultExists = false
        
        var controllers = [mController]()
        var selectedControllerID = mController.defaultUUID
        
        let defaults = UserDefaults.standard
        if let ID = defaults.string( forKey: DefaultsKeys.selectedControllerKey ) {
            selectedControllerID = ID
            print("gg:" + selectedControllerID)
        }
        
        if let gatheredLayout = defaults.array( forKey: DefaultsKeys.controllerListKey ) as? [String] {
            
            for s in gatheredLayout {
                
                let newController = mController(controllerID: s)
                controllers.append(newController)
                
                if(selectedControllerID == s) {
                    UserData.currentController = newController
                    defaultExists = true
                    
                    print("th439uno found default:" , selectedControllerID)
                }
            }
            
        }
        
        if(controllers.isEmpty) {
            let defaultController = mController()
            controllers.append(defaultController)
            
            SaveLayout(defaultController)
            SaveLayouts()
            
            UserData.currentController = defaultController
            SaveController.SaveSelectedController(UserData.currentController!)
            
        } else if(!defaultExists) {
            
            UserData.currentController = controllers.first(where: { c in c.controllerID == mController.defaultUUID })
            SaveController.SaveSelectedController(UserData.currentController!)
        }
         
        
        return controllers
    }
}
 
