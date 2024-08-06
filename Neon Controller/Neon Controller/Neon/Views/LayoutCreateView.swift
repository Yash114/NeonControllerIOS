//
//  CreateView.swift
//  Neon Controller
//
//  Created by Yashua Evans on 8/9/23.
//

import SwiftUI

struct LayoutCreateView : View {
    
    public enum Popup {
        case Delete
        case Reset
        case Info
        case Edit
        case Texture
        case Settings
        case Save
        case NONE
    }
    
    @SwiftUI.State var maxButtons = UserData.defaultMaxButtons
    
    var callback : (RootView.Actions) -> ()
    
    @SwiftUI.State var errorPopup = false
    
    @SwiftUI.State var buttons = [ControlButton]()
    
    @SwiftUI.State var selectedButtonIndex = -1
    @SwiftUI.State var selectedButton : ControlButton?

    @SwiftUI.State var showTools = false
    
    @SwiftUI.State var VisiblePopup = Popup.NONE
    
    @SwiftUI.State var hasUnsavedChanges = false
    
    @Binding var refController : mController
    @SwiftUI.State var outputController : mController?
    
    @SwiftUI.State var controlButtonColor = Color.white
    @SwiftUI.State var isTooManyButtonsAlertPresented = false

    func createNewButton(type: ControlButton.type) {
        
        UserData.sendEvent("New Button Created", data: [:])

        if(buttons.count < maxButtons) {
            
            buttons.append(ControlButton(type))
            
            selectedButtonIndex = buttons.count - 1
            
            selectedButton = buttons[selectedButtonIndex]
            

        } else {
            
            errorPopup = true
            isTooManyButtonsAlertPresented = true

            UserData.sendEvent("Error", data: ["message" : "too many buttons created"])

        }
        
    }

    var body: some View {
        ZStack {
            
            ButtonDisplay(buttons: $buttons, selectedIndex: $selectedButtonIndex, callback: callback)
            
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    
                    IconWithText(image: "play_icon", tint: Color(UIColor(named: "Secondary")!), text: "Play")
                        .padding(.leading, 16)
                        .onTapGesture {
                            
                            RootView.sVibrate()

                            //Save
                            outputController!.updateButtons(buttons: buttons)
                            outputController!.save()
                            
                            outputController!.buttons.forEach { b in
                                print(b.keybind)
                            }
                            
                            refController = outputController!
                            print(buttons.count)

                            callback(RootView.Actions.Saved)
                            callback(RootView.Actions.Play)

                        }
                    
                    IconWithText(image: "folder_icon", tint: .white, text: "Save")
                        .padding(.leading, 16)
                        .onTapGesture {
                            
                            RootView.sVibrate()

                            //Save
                            outputController!.updateButtons(buttons: buttons)
                            outputController!.save()
                            
                            outputController!.buttons.forEach { b in
                                print(b.keybind)
                            }
                            
                            refController = outputController!
                            print(buttons.count)

                            callback(RootView.Actions.Saved)

                        }
                    
                    Image("cancel_icon")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .colorMultiply(.red)
                        .padding(.leading, 16)
                        .onTapGesture {
                            RootView.sVibrate()

                            if(!hasUnsavedChanges) {
                                
                                //Show Save Popup & Save
                                callback(RootView.Actions.List)
                                
                            } else {
                                
                                //Show Save Popup
                                VisiblePopup = Popup.Save

                            }

                        }
                }
                .padding(.top, 16)
                
                Spacer()
                
                CreateDrawer(createButtonCallback: createNewButton)
                    .padding(.top, 16)
                
                Spacer()

                ZStack {
                    HStack {
                        
                        Spacer()
                        
                        BottomEditorTools(showTools: $showTools, popup: $VisiblePopup, controlButtonColor: $controlButtonColor, callback: callback)
                        
                        Spacer()
                        

                        
                    }
                    .padding(.leading, 4)
                    .background(RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.black.opacity(0.3)))
                    
                    
                    HStack(alignment: .bottom, spacing: 0) {
                        
                        IconWithText(image: "trash_icon", tint: Color.red, text: "Delete")
                            .onTapGesture {
                                RootView.sVibrate()
                                
                                if(selectedButtonIndex >= 0) {
                                    buttons.remove(at: selectedButtonIndex)
                                }
                                
                            }
                        
                        Spacer()
                        
                    }
                    
//                    HStack {
//                        Spacer()
//
//                        
//                        IconWithText(image: "options_icon", tint: Color.white, text: "Settings")
//                            .onTapGesture {
//                                RootView.sVibrate()
//                            
//                                
//                            }
//                        
//                        Spacer()
//                            .frame(width: 64)
//
//                    }
                }
            }
            
            
            PopupController(VisiblePopup: $VisiblePopup, referenceButton: $selectedButton) { newButton in
                buttons[selectedButtonIndex] = newButton
                selectedButton = newButton
            }
        }
        .onChange(of: selectedButtonIndex) { newButton in
            if(selectedButtonIndex >= 0) {
                
                withAnimation {
                    showTools = true
                }
                
                selectedButton = buttons[selectedButtonIndex]
                controlButtonColor = selectedButton!.color

            }
        }
        .onChange(of: controlButtonColor) { newButton in
            if(selectedButton != nil) {
                if(controlButtonColor != selectedButton!.color) {
                    
                    selectedButton!.color = controlButtonColor
                    
                }
            }
        }
        .onAppear {
            refController.retrieve()

            outputController = mController(ref: refController)
            
            //Update the buttons and settings
            Task {
                try await Task.sleep(for: Duration.milliseconds(500))
                buttons = outputController!.buttons
            }
            
            if(UserData.isPremium) {
                maxButtons = 100000
            }
            
        }
        .alert("You need Premium!", isPresented: $isTooManyButtonsAlertPresented) {
            Button("OK", role: .destructive) {
                print("open premium screen")
                callback(RootView.Actions.Premium)
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Please upgrade to premium to use more buttons")
        }
    }
}



struct PopupController : View {

    @Binding var VisiblePopup : LayoutCreateView.Popup
    @Binding var referenceButton : ControlButton?
    
    let onEditSubmitted : (ControlButton) -> ()
//    let onPopupFinish : (Bool) -> ()
    
    var body: some View {
        
        ZStack {
            
            if(VisiblePopup == LayoutCreateView.Popup.Reset) {
                PopupView(currentPopup: $VisiblePopup,
                          popupType: LayoutCreateView.Popup.Reset,
                          Title: "Reset Controller",
                          Content: "Do you want to reset this controller?") { success in
                    
                    
                }
            }
            
            if(VisiblePopup == LayoutCreateView.Popup.Delete) {
                PopupView(currentPopup: $VisiblePopup,
                          popupType: LayoutCreateView.Popup.Delete,
                          Title: "Delete Button",
                          Content: "Do you want to delete this button?") { success in
                    
                }
            }
            
            if(VisiblePopup == LayoutCreateView.Popup.Save) {
                PopupView(currentPopup: $VisiblePopup,
                          popupType: LayoutCreateView.Popup.Save,
                          Title: "Save Layout",
                          Content: "Do you want to close without saving?") { success in
                    
                }
            }
            
            if(VisiblePopup == LayoutCreateView.Popup.Edit) {
                KeybindPopupView(currentPopup: $VisiblePopup, popupType: LayoutCreateView.Popup.Edit, onSubmitted: onEditSubmitted, referenceButton: $referenceButton)
            }
            
            if(VisiblePopup == LayoutCreateView.Popup.Texture) {
                TexturePopupView(currentPopup: $VisiblePopup, popupType: LayoutCreateView.Popup.Texture, onSubmitted: onEditSubmitted, referenceButton: $referenceButton)
            }
        }

    }
 }

struct BottomEditorTools : View {
    
    @Binding var showTools : Bool
    @Binding var popup : LayoutCreateView.Popup
    
    @Binding var controlButtonColor : Color
    
    @SwiftUI.State var colorPicker : ColorPicker<Text>?
    @SwiftUI.State var isPremiumFeaturesNeededPopupVisible = false

    var callback : (RootView.Actions) -> ()
    
    var body: some View {
                    
            HStack {
                IconWithText(image: "info_icon", tint: .white, text: "Info")
                    .padding(.horizontal, 8)
                
                IconWithText(image: "keyboard_icon", tint: .white, text: "Edit")
                    .padding(.horizontal, 8)
                    .onTapGesture {
                        RootView.sVibrate()

                        popup = LayoutCreateView.Popup.Edit
                    }
                
                
                ZStack {
                    
                    HStack {
                        
                        colorPicker
                            .frame(width: 30)
                        
                        Text("Color")
                            .font(.custom("Oswald-Medium", size: 12))
                            .foregroundColor(.white)
                        
                    }
                    
                    if(!UserData.isPremium) {
                        Spacer()
                            .clipShape(RoundedRectangle(cornerRadius: 3))
                            .background(.gray.opacity(0.01))
                            .onTapGesture {
                                isPremiumFeaturesNeededPopupVisible = true
                                RootView.eVibrate()
                            }
                    }
                }
//                IconWithText(image: "color_icon", tint: .white, text: "Texture")
//                    .padding(.horizontal, 8)
//                    .onTapGesture {
//                        RootView.sVibrate()
//
//
//
//                    }
                
            }
            .opacity(showTools ? 1 : 0)
            .onAppear {
                colorPicker = ColorPicker("", selection: $controlButtonColor, supportsOpacity: true)
            }
            .alert("You need Premium!", isPresented: $isPremiumFeaturesNeededPopupVisible) {
                Button("OK", role: .destructive) {
                    callback(RootView.Actions.Premium)
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Please upgrade to premium to use more buttons")
            }
        
    }
}

struct DrawerItem : View {
    
    let Title : String
    let Content : String
    
    let ButtonID : ControlButton.type
    let onTouch : (ControlButton.type) -> ()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(Title)
                .font(.custom("Oswald-Medium", size: 24))
                .foregroundColor(.black)

            Text(Content)
                .font(.custom("DMMono-Normal", size: 12))
                .foregroundColor(.black)
        }
        .onTapGesture {
            RootView.sVibrate()

            onTouch(ButtonID)
        }
    }
}

struct CreateDrawer : View {
    
    @SwiftUI.State var drawerOpen = true
    
    let createButtonCallback : (ControlButton.type) -> ()
    
    func DrawerItemSelect(ID: ControlButton.type) {
        createButtonCallback(ID)
        drawerOpen = false
    }
    
    var body: some View {
        
        HStack(alignment: .center) {
            ScrollView {
                VStack(alignment: .leading) {
                    DrawerItem(Title: "Normal", Content: "Basic button object", ButtonID: ControlButton.type.Normal, onTouch: DrawerItemSelect)
                    
                    Seperator()
                    
                    DrawerItem(Title: "Sticky", Content: "Click once to hold, click again to release", ButtonID: ControlButton.type.Sticky, onTouch: DrawerItemSelect)
                    
                    
                    Seperator()
                    
                    DrawerItem(Title: "Cycle", Content: "Click to cycle through a list of keybinds", ButtonID: ControlButton.type.Cycle, onTouch: DrawerItemSelect)
                    
                    Seperator()
                    
                    DrawerItem(Title: "Joy", Content: "Joystick action button", ButtonID: ControlButton.type.Joy, onTouch: DrawerItemSelect)
                    
                    Seperator()
                    
                    DrawerItem(Title: "Scroll", Content: "Scroll throuh a list of keybinds", ButtonID: ControlButton.type.Scroll, onTouch: DrawerItemSelect)
                }
                .padding(.vertical, 8)
            
            }
            .foregroundColor(.white)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background {
                RoundedRectangle(cornerSize: CGSize(width: 8, height: 8))
                    .foregroundColor(.white)
            }
            .frame(width: 182)
            .offset(CGSize(width: drawerOpen ? 0 : -182, height: 0))
            .opacity(drawerOpen ? 1 : 0)
            
            
            
            ZStack {
                if(drawerOpen) {
                    Image("left_icon")
                        .resizable()
                        .colorMultiply(Color(UIColor(named: "Secondary")!))
                } else {
                    Image("plus_icon")
                        .resizable()
                        .colorMultiply(Color(UIColor(named: "Secondary")!))
                }
            }
                .onTapGesture {
                    RootView.sVibrate()
                    withAnimation{
                        drawerOpen.toggle()
                    }
                }
                .background(Circle()
                    .foregroundColor(.white))
                .offset(CGSize(width: drawerOpen ? 0 : -182, height: 0))
                .frame(width: 36, height: 36)
                .animation(.spring(), value: UUID())

            
        }
    }
}

struct ButtonDisplay : View {
    
    @Binding var buttons : [ControlButton]
    
    @Binding var selectedIndex : Int
    @SwiftUI.State var externalScale = 1.0
    
    @SwiftUI.State var maxButtons = UserData.defaultMaxButtons
    
    @SwiftUI.State var isTooManyButtonsAlertPresented = false
    
    var callback : (RootView.Actions) -> ()
            
    var body: some View {
        
        ZStack {
            ForEach (0..<(min(buttons.count, UserData.defaultMaxButtons)), id: \.self) { index in
                ControlButtonView(buttonData: buttons[index], Index: index, SelectedIndex: $selectedIndex)
            }
        }
        .onAppear {
            if(UserData.isPremium) {
                maxButtons = 100000
            }
        }
        .alert("You need Premium!", isPresented: $isTooManyButtonsAlertPresented) {
            Button("OK", role: .destructive) {
                callback(RootView.Actions.Premium)
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Please upgrade to premium to use more buttons")
        }
        .onChange(of: buttons) { newValue in
            if(buttons.count > maxButtons) {
                isTooManyButtonsAlertPresented = true
                RootView.eVibrate()
            }
            
            print("button count: " + String(buttons.count));
        }
    }
}

struct Seperator : View {
    var body: some View {
        Rectangle()
            .foregroundColor(Color(UIColor(named: "Secondary")!))
            .frame(width: 32, height: 2)
    }
}
