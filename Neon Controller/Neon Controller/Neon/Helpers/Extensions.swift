//
//  Extensions.swift
//  Neon Controller
//
//  Created by Yashua Evans on 8/8/23.
//

import Foundation
import SwiftUI

extension UnitPoint {
    func add(_ other : UnitPoint, multiplier : Double = 1) -> UnitPoint {
        let X = self.x + other.x * multiplier
        let Y = self.y + other.y * multiplier
        
        return UnitPoint(x: X, y: Y)
    }
    
    func constrain() -> UnitPoint {
        
        var X = self.x > 1 ? 1 : self.x
        X = self.x < 0 ? 0 : self.x
        
        var Y = self.y > 1 ? 1 : self.y
        Y = self.y < 0 ? 0 : self.y
        
        return UnitPoint(x: X, y: Y)
    }
    
    func invert(_ xVal : Bool, _ yVal : Bool) -> UnitPoint {
        return UnitPoint(x: self.x * (xVal ? -1 : 1), y: self.y * (yVal ? -1 : 1))
    }
}

extension Color {
    public init?(hex: String) {
        let a, r, g, b: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    a = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    r = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    b = CGFloat((hexNumber & 0x000000ff) >> 0) / 255
                    
                    self.init(red: r, green: g, blue: b, opacity: a)

                    return
                }
            }
        }
        
        self.init("#FFFFFFFF")

        return nil
    }
    
    func toARGBHexString() -> String {
        guard let components = cgColor?.components else {
            return ""
        }

        let red = Int(components[0] * 255)
        let green = Int(components[1] * 255)
        let blue = Int(components[2] * 255)
        let alpha = Int(components[3] * 255)

        let argbHex = String(format: "#%02X%02X%02X%02X", alpha, red, green, blue)
        return argbHex
    }
}

extension CGSize {
    func add(_ otherPoint: CGSize) -> CGSize {
        return CGSize(width: self.width + otherPoint.width, height: self.height + otherPoint.height)
    }
    
    func substract(_ otherPoint: CGSize) -> CGSize {
        return CGSize(width: self.width - otherPoint.width, height: self.height - otherPoint.height)
    }
}

extension String {
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
