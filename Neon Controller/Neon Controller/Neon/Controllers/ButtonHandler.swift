//
//  ButtonHandler.swift
//  Neon Controller
//
//  Created by Yashua Evans on 9/11/23.
//

import Foundation
import UIKit

@objc
class ButtonHandler : NSObject {
    
    static let alphabetList = [
        "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t",
        "u", "v", "w", "x", "y", "z"
    ];
    
    static let numberList = [
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
    ];
    
    static let symbolList = [
        "-", "=", "[", "]", "\\", ";", "'", ",", ".", "/", "`",
    ]
    
    static let mouseButtonList = [
        "click", "left_click", "right_click", "scrollwheel"
    ]
    
    static let actionButtonList = [
        "backspace", "tab", "caps", "enter", "shift", "right_shift", "ctrl", "alt", "alt_right", "right_alt", "ctrl_right", "right_ctrl", "left_alt", "left_ctrl", "left", "up", "down", "right", "ins", "delete", "home", "end", "page_up", "page_down", "scrlck", "numlock", "windows", "right_windows", "left_windows", "gui", "left_gui", "right_gui", "del", "delete", "space"
    ]
    
    @objc 
    static let xboxControllerList = [
        "xbox_up","xbox_down","xbox_left","xbox_right","xbox_start","x_back","x_left_thumb_button",
        "x_right_thumb_button","xbox_left_shoulder","xbox_right_shoulder","xbox_a","xbox_b",
        "xbox_x","xbox_y","xbox_left_trigger","xbox_right_trigger", "xbox_right_bumper", "xbox_left_bumper",
        "xbox_button"
    ]
    
    static let xboxVecControllerList = [
        "xbox_right_joystick", "xbox_left_joystick", "xlj", "xrj"
    ]
        
        
    static let NormalKeybindList = [
        "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "backspace",
        "tab", "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "[", "]", "\\",
        "caps", "a", "s", "d", "f", "g", "h", "j", "k", "l", ";", "'", "enter",
        "shift", "z", "x", "c", "v", "b", "n", "m", ",", ".", "/", "right_shift",  "`",
        "ctrl", "alt", "space", "alt_right", "right_alt", "ctrl_right", "right_ctrl", "left_alt", "left_ctrl", "left", "up", "down", "right",
        "ins", "delete", "home", "end", "page_up", "page_down", "scrlck", "numlock", "/", "-",
        "enter", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", ".", "right_ctrl","click",
        "right_click","left_click","caps","f1","f2","f3","f4","f5","f6","f7","f8","f9","f9","f10","f11",
        "f12","xbox_up","xbox_down","xbox_left","xbox_right","xbox_start","x_back","x_left_thumb_button",
        "x_right_thumb_button","xbox_left_shoulder","xbox_right_shoulder","xbox_a","xbox_b",
        "xbox_x","xbox_y","xbox_left_trigger","xbox_right_trigger", "escape", "xbox_right_bumper", "xbox_left_bumper",
        "scroll_wheel", "mouse_wheel", "keyboard_toggle",
        "gyro_toggle", "xbox_button", "windows", "right_windows", "left_windows", "gui", "left_gui", "right_gui",
        "grave", "period", "dash", "equal", "simicolon", "apostrophe", "backslash", "comma", "minus"
    ]
    
    static let JoystickKeybindList = [
        "w:a:s:d", "xbox_right_joystick", "xbox_left_joystick", "up:left:down:right", "xbox_up:xbox_left:xbox_down:xbox_right", "xlj", "xrj",
        "mouse"
    ]
    
    static let ScrollNCycleKeybindList = [
        "1:2:3:4:5:6:7:8:9"
    ]
    
    public static func getKeybindList(for type : ControlButton.type) -> [String] {
        
        if(type == ControlButton.type.Normal || type == ControlButton.type.Sticky) {
            return ButtonHandler.NormalKeybindList
        }
        
        if(type == ControlButton.type.Joy) {
            return ButtonHandler.JoystickKeybindList
        }
        
        if(type == ControlButton.type.Scroll || type == ControlButton.type.Cycle) {
            return ButtonHandler.ScrollNCycleKeybindList
        }
        
        
        return []
    }
    
    enum keybindType: Int {
        case NORMAL = 0
        case MOUSE = 1
        case ACTION = 2
        case CONTROLLER = 3
        case CONTROLLER_VEC = 4

    }
    
    @objc
    public static func getKeycodeType(_ keybind : String) -> Int {
        
        if(alphabetList.contains(where: { k in k == keybind }) || numberList.contains(where: { k in k == keybind }) || symbolList.contains(where: { k in k == keybind })) {
            return keybindType.NORMAL.rawValue
        }
        
        if(actionButtonList.contains(where: { k in k == keybind })) {
            return keybindType.ACTION.rawValue
        }
        
        if(mouseButtonList.contains(where: { k in k == keybind })) {
            return keybindType.MOUSE.rawValue

        }
        
        if(xboxControllerList.contains(where: { k in k == keybind })) {
            return keybindType.CONTROLLER.rawValue

        }
        
        if(xboxVecControllerList.contains(where: { k in k == keybind })) {
            return keybindType.CONTROLLER_VEC.rawValue

        }


        return keybindType.NORMAL.rawValue
    }
    
    
    @objc
    public static func getControllerButtonCode(_ keybind : String) -> Int {
        if(!xboxControllerList.contains(keybind)) { return 0x00 }
           
        return xboxControllerList.lastIndex(of: keybind)!
    }
    
    @objc
    public static func getKeycodeAction(_ keybind : String) -> Int {
        if(!ButtonHandler.validateKeybind(keybind.lowercased(), buttonType: ControlButton.type.Normal)) { return 0 }
        
        if(!actionButtonList.contains(where: { k in k == keybind })) { return 0 }

        if(keybind == "space" ) {
            return UIKeyboardHIDUsage.keyboardSpacebar.rawValue
        }
        
        if(keybind == "home" ) {
            return UIKeyboardHIDUsage.keyboardHome.rawValue
        }
        
        if(keybind == "pg_up" ) {
            return UIKeyboardHIDUsage.keyboardPageUp.rawValue
        }
        
        if(keybind == "pg_down" ) {
            return UIKeyboardHIDUsage.keyboardPageDown.rawValue
        }
        
        if(keybind == "up" ) {
            return UIKeyboardHIDUsage.keyboardUpArrow.rawValue
        }
        
        if(keybind == "down" ) {
            return UIKeyboardHIDUsage.keyboardDownArrow.rawValue
        }
        
        if(keybind == "left" ) {
            return UIKeyboardHIDUsage.keyboardLeftArrow.rawValue
        }
        
        if(keybind == "right" ) {
            return UIKeyboardHIDUsage.keyboardRightArrow.rawValue
        }
        
        if(keybind == "backspace" || keybind == "bksp" || keybind == "del" || keybind == "delete") {
            return UIKeyboardHIDUsage.keyboardDeleteOrBackspace.rawValue
        }
        
        if(keybind == "caps" || keybind == "caps_lock") {
            return UIKeyboardHIDUsage.keyboardCapsLock.rawValue
        }
        
        if(keybind == "enter") {
            return UIKeyboardHIDUsage.keypadEnter.rawValue
        }

        if(keybind == "right_shift") {
            return UIKeyboardHIDUsage.keyboardRightShift.rawValue
        }
        
        if(keybind == "left_shift" || keybind == "shift") {
            return UIKeyboardHIDUsage.keyboardLeftShift.rawValue
        }
        
        if(keybind == "alt" || keybind == "left_alt") {
            return UIKeyboardHIDUsage.keyboardLeftAlt.rawValue
        }
        
        if(keybind == "right_alt") {
            return UIKeyboardHIDUsage.keyboardRightAlt.rawValue
        }
        
        if(keybind == "windows" || keybind == "left_windows" || keybind == "gui" || keybind == "left_gui") {
            return UIKeyboardHIDUsage.keyboardLeftGUI.rawValue
        }

        if(keybind == "right_windows" || keybind == "right_gui") {
            return UIKeyboardHIDUsage.keyboardRightGUI.rawValue
        }
        
        if(keybind == "numlock") {
            return UIKeyboardHIDUsage.keypadNumLock.rawValue
        }

        if(keybind == "scrlock" || keybind == "scroll_lock" ) {
            return UIKeyboardHIDUsage.keyboardScrollLock.rawValue
        }
        
        return 0
    }
    
    @objc
    public static func getKeycodeKeyboard(_ keycodeInput : String, buttonType: Int) -> String? {
        
        let keybind = keycodeInput.lowercased()
        
//        if(!ButtonHandler.validateKeybind(keybind, buttonType: ControlButton.type(rawValue: buttonType) ?? ControlButton.type.Normal)) { return nil }
        
        if(alphabetList.contains(where: { k in keybind == k }) ) {
            
            let charOrigin = 97; //a
            let charPos = charOrigin + alphabetList.firstIndex(of: keybind)!
            
            // Convert Int to a UnicodeScalar.
            let u = UnicodeScalar(charPos)!
            
            return String(repeating: Character(u), count: 1)
            
        } else if(numberList.contains(where: { k in keybind == k }) ) {

            let charOrigin = 48 //0
            let charPos = charOrigin + numberList.firstIndex(of: keybind)!

            // Convert Int to a UnicodeScalar.
            let u = UnicodeScalar(charPos)!
             
            return String(repeating: Character(u), count: 1)
            
        } else {
            
            // Symbols
            if(keybind == "`" || keybind == "grave") {
                return String(repeating: Character(UnicodeScalar(96)), count: 1)
            }
            
            if(keybind == "[") {
                return String(repeating: Character(UnicodeScalar(91)), count: 1)
            }
            
            if(keybind == "]") {
                return String(repeating: Character(UnicodeScalar(93)), count: 1)
            }
            
            if(keybind == "/") {
                return String(repeating: Character(UnicodeScalar(47)), count: 1)
            }
            
            if(keybind == "." || keybind == "period") {
                return String(repeating: Character(UnicodeScalar(46)), count: 1)
            }
            
            if(keybind == "-" || keybind == "dash" || keybind == "minus") {
                return String(repeating: Character(UnicodeScalar(45)), count: 1)
            }
            
            if(keybind == "=" || keybind == "equal") {
                return String(repeating: Character(UnicodeScalar(61)), count: 1)
            }
            
            if(keybind == ";" || keybind == "simicolon") {
                return String(repeating: Character(UnicodeScalar(59)), count: 1)
            }
            
            if(keybind == "'" || keybind == "apostrophe") {
                return String(repeating: Character(UnicodeScalar(39)), count: 1)
            }
            
            if(keybind == "\\" || keybind == "backslash") {
                return String(repeating: Character(UnicodeScalar(92)), count: 1)
            }
            
            if(keybind == "," || keybind == "comma") {
                return String(repeating: Character(UnicodeScalar(44)), count: 1)
            }

            if(keybind == "esc" || keybind == "escape") {
                return String(repeating: Character(UnicodeScalar(27)), count: 1)
            }
            
        }
        
        return nil
    }
    
    public static func validateKeybind(_ keybind : String, buttonType: ControlButton.type) -> Bool {
        
        if(buttonType == ControlButton.type.Cycle || buttonType == ControlButton.type.Scroll) {
            
            var keybindList = [String]()
            var lastColonIndex = 0
            
            if(keybind.contains(":")) {
                for i in 0..<keybind.count {
                    
                    if(keybind[keybind.index(keybind.startIndex, offsetBy: i)] == ":") {
                        
                        let startIndex = keybind.index(keybind.startIndex, offsetBy: lastColonIndex)
                        let endIndex = keybind.index(keybind.startIndex, offsetBy: i)

                        let subKeybind = keybind[startIndex..<endIndex].description
            
                        keybindList.append(subKeybind)
                        
                        lastColonIndex = i + 1;
                    }
                }
            }
            
            let startIndex = keybind.index(keybind.startIndex, offsetBy: lastColonIndex)
            let endIndex = keybind.endIndex

            let subKeybind = keybind[startIndex..<endIndex].description

            keybindList.append(subKeybind)
            
            for k in keybindList {
                if !validateKeybind(k, buttonType: ControlButton.type.Normal) {
                    return false
                }
            }
                   
            return true;
            
        }
        
        return getKeybindList(for: buttonType).contains { s in s == keybind.lowercased() } || keybind.isEmpty
    }
}
