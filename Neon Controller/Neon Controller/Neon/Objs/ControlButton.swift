//
//  Button.swift
//  Neon Controller
//
//  Created by Yashua Evans on 8/9/23.
//

import Foundation
import SwiftUI

@objc class ControlButton : NSObject, ObservableObject {
    
    let id = UUID()
    
    public enum type: Int {
        case Normal
        case Sticky
        case Cycle
        case Joy
        case Scroll
    }
    
    static func == (lhs: ControlButton, rhs: ControlButton) -> Bool {
        return lhs.id == rhs.id
    }
    
    static let buttonImages : [type:String] = [
        type.Normal: "normalButton",
        type.Sticky: "stickyButton",
        type.Cycle: "cycleButton",
        type.Joy: "joyButton",
        type.Scroll: "scrollButton"
    ]
        
    var type = type.Normal
    
    @objc var objcColor : UIColor = UIColor.white;
    @objc var objcType : Int = 0;
     
    @objc var alpha = 1.0
    @objc var position = CGSize.zero
    
    @objc var visibleTitle = ""
    
    @Published var color : Color = Color.white
    
    @Published @objc var size : Double = 100
    
    @Published @objc var keybind : String = ""
    @Published @objc var name : String = ""
    
    @Published @objc var showName = false
    @Published @objc var isHapticsEnabled = true
        
    
    override init() {
        
    }
    
    init(_ type : ControlButton.type) {
        self.type = type
    }
    
    func copyInfo(_ reference: ControlButton) {
        self.keybind = reference.keybind
        self.name = reference.name
        self.showName = reference.showName
        self.isHapticsEnabled = reference.isHapticsEnabled
        self.type = reference.type
        self.position = reference.position
        self.size = reference.size

        self.alpha = reference.alpha
        self.color = reference.color
    }
    
    @objc public func updateObjcVars() {
        self.objcColor = UIColor(self.color)
        self.objcType = self.type.rawValue
        self.visibleTitle = showName && self.name.count > 0 ? self.name : self.keybind
    }
}


struct ControlButtonView : View {
    @ObservedObject var buttonData : ControlButton
    @SwiftUI.State var selected = false
    
    var Index : Int = -1
    @Binding var SelectedIndex : Int
    
    @GestureState var gestureState = CGPoint.zero
    @SwiftUI.State var offset = CGSize.zero

    let minSize = 25.0
    let maxSize = 250.0
    let scaleStepSize = 10.0
    
    @SwiftUI.State var touchOrigin = CGSize.zero
    @SwiftUI.State var buttonOrigin = CGSize.zero
    
    @SwiftUI.State var dragStarted = false
    
    @SwiftUI.State var jiggleAnimation = false
    
    var body : some View {
        
        ZStack {
            Image(ControlButton.buttonImages[buttonData.type]!)
                .resizable()
                .colorMultiply(buttonData.color)
            
            Text(buttonData.showName || buttonData.name.count != 0 ? buttonData.name : buttonData.keybind)
                .font(.custom("Oswald-Medium", size: 500))
                .minimumScaleFactor(0.01)
                .textCase(.uppercase)
                .padding(16)
                .foregroundColor(.white)

            
            if(Index == SelectedIndex) {
                VStack {
                    HStack {
                        
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                            .onTapGesture {
                                if(buttonData.size <= maxSize - scaleStepSize) {
                                    buttonData.size += scaleStepSize
                                }
                            }
                        
                        Spacer()
                        
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                            .onTapGesture {
                                if(buttonData.size >= minSize + scaleStepSize) {
                                    buttonData.size -= scaleStepSize
                                }
                            }
                    }
                    
                    Spacer()
                }
            }
        }
        .frame(width: buttonData.size, height: buttonData.size)
        .offset(buttonData.position.add(offset))
        .animation(nil)
        .onChange(of: SelectedIndex, perform: { newValue in
            
            if(SelectedIndex != Index) {
                jiggleAnimation = false
            }
            
        })
        .gesture(
            DragGesture(minimumDistance: 5)
                
                .onChanged({ state in
                    jiggleAnimation = true

                    let temp = CGSize(width: state.location.x - buttonData.size / 2, height: state.location.y - buttonData.size / 2)

                    if(!dragStarted) {
                        RootView.sVibrate()

                        dragStarted = true
                        SelectedIndex = Index
                        touchOrigin = temp
                    }
                    
                    offset = temp.substract(touchOrigin)
                })
                .updating($gestureState, body: { s, p, t in
                    p = s.location

                })
                .onEnded({ v in
                    if(Index == SelectedIndex) {
                        buttonData.position = buttonData.position.add(offset)
                        offset = CGSize.zero
                        
                        dragStarted = false
                    }
                }))
        .onTapGesture {
            SelectedIndex = Index
            RootView.sVibrate()
        }
    }
}
