//
//  Structs.swift
//  Neon Controller
//
//  Created by Yashua Evans on 8/8/23.
//

import SwiftUI

@objc
final class c_AnimatedBackground : NSObject {
    
    @objc static func makeBackground(_ coder : NSCoder!) -> UIViewController {
        return UIHostingController.init(coder: coder, rootView: AnimatedBackground())!
    }
}

struct AnimatedBackground: View {
    
    @SwiftUI.State private var particleSystem = ParticleSystem(particleCount: 100, shapeCount: 0, bounds: Vector(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height))
    
    var body: some View {
        
        ZStack {
            
            ViewObjc3DRepresentable()
                .ignoresSafeArea()


            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    
                    let timelineDate = timeline.date.timeIntervalSinceReferenceDate
                    particleSystem.update(bounds: Vector(x: size.width, y: size.height), date: timelineDate)
                    particleSystem.draw(context: context)
                    
                }
            }
        }
        .ignoresSafeArea()
        .background(.black)
        
    }

}

struct drawerItem: View {
    
    let itemName: String
    
    @SwiftUI.State var selected = false
    @Binding var selectedItem : Int
    let index : Int
    
    var body: some View {
        VStack {
            Text(itemName)
                .font(.custom("Oswald-Medium", size: 24))
                .foregroundColor(selectedItem == index ? .black : .white)
                .padding(.horizontal, 8)
                .background(selectedItem == index ? .white : .black)
                .onTapGesture {
                    RootView.sVibrate()
                    withAnimation {
                        
                        if(index == 3) {
                            UIApplication.shared.open (URL(string: "https://discord.gg/VbjxkKhTqh")!)
                        } else {
                            selectedItem = index

                        }
                    }
                }
        }
        .shadow(radius: selectedItem == index ? 8 : 0)
    }
}

struct drawerView : View {
     
    @Binding var drawerOpen : Bool
    @Binding var selectedItem : Int

    let onSelectItem : (Int) -> ()
    
    var body: some View {
        GeometryReader { geo in
            
            HStack {
                Spacer()
                
                VStack(alignment: .trailing, spacing: 0) {
                    drawerItem(itemName: "Play", selectedItem: $selectedItem, index: 0)
                    drawerItem(itemName: "Controllers", selectedItem: $selectedItem, index: 1)
                    drawerItem(itemName: "Settings", selectedItem: $selectedItem, index: 2)
                    drawerItem(itemName: "Premium", selectedItem: $selectedItem, index: 4)
                    drawerItem(itemName: "Discord", selectedItem: $selectedItem, index: 3)
                    drawerItem(itemName: "Info", selectedItem: $selectedItem, index: 5)

                }
                .padding(.vertical, 8)
//                .background(Color(uiColor: UIColor(named: "Secondary")!))
                .offset(CGSize(width: drawerOpen ? 0 : 300, height: 0))
            }
            .shadow(radius: 8)
            .onChange(of: selectedItem) { newValue in
                drawerOpen = false
                selectedItem = selectedItem
                
                onSelectItem(selectedItem)
                
                let customNotificationName = Notification.Name("ApplicationDidChangeTab")
                NotificationCenter.default.post(name: customNotificationName, object: nil)
            }
            
        }
    }
}

struct iconImage_circle : View {
    
    var image : Image
    
    init(_ image : Image) {
        self.image = image
    }
    
    var body: some View {
        
        ZStack {
            Circle()
                .foregroundColor(.white)
            
            image
                .resizable()
                .padding(4)
                .colorMultiply(.black)
        }
        .frame(width: 36, height: 36)
    }
}

struct layoutListItem : View {
    
    @Binding var selectedController : mController
    
    @SwiftUI.State var selected : Bool = false
    @SwiftUI.State var locked : Bool = false
    
    let controller : mController
    
    var body: some View {
        
        ZStack {
            
            VStack(alignment: .leading, spacing: 0) {
                
                Text("*Selected Controller*")
                    .font(.custom("Oswald-Medium", size: 6))
                    .foregroundColor(.black)
                    .offset(CGSize(width: 0, height: 4))

                Text(controller.controllerName)
                    .font(.custom("Oswald-Medium", size: 20))
                    .lineLimit(1)
                    .foregroundColor(!selected ? .white : .black)
                
                Text(controller.controllerDescription)
                    .font(.custom("OpenSans-Light", size: 14))
                    .lineLimit(4)
                    .foregroundColor(!selected ? .white : .black)
                
                
                HStack { Spacer() }
                
                Spacer()

            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)


            if(locked) {
                //Put in an image of a lock
            }
            
        }
        .frame(width: 143, height: 158)
        .background(RoundedRectangle(cornerRadius: 8)
            .foregroundColor(selected ? .white : .black.opacity(0.6)))
        .padding(.horizontal, 8)

        .onChange(of: selectedController, perform: { newValue in
            withAnimation(.linear(duration: 0.1)) {
                selected = controller == newValue
            }
        })
        .onAppear {
            selected = selectedController == controller
         }
        .onTapGesture {
            RootView.sVibrate()
            withAnimation(.linear(duration: 0.1)) {
                selectedController = controller
                SaveController.SaveSelectedController(controller)

                
            }
            
        
        }

        
    }
}

struct layoutListAddItem : View {
        
    var body: some View {
        
        VStack(spacing: 0) {
            Spacer()
            
            Image("plus_icon")
                .resizable()
                .frame(width: 64, height: 64)
            
            Text("Create New Controller")
                .font(.custom("Oswald-Medium", size: 22))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .multilineTextAlignment(.center)
                .lineSpacing(-36)
            
            Spacer()


        }
        .frame(width: 143, height: 158)
        .background(RoundedRectangle(cornerRadius: 8)
            .foregroundColor(Color(UIColor(named: "Secondary")!)))

                        
    }
}

struct LayoutList : View {
    
    @Binding var selected : mController
    let newControllerCallback : () -> ()
    
    var body: some View {
        
        ScrollView(.horizontal) {
            HStack {
                
                layoutListAddItem()
                    .onTapGesture {
                        RootView.sVibrate()
                        newControllerCallback()
                    }
                
                ForEach(Array(UserData.savedControllers.enumerated()), id: \.offset) {
                    layoutListItem(selectedController: $selected, controller: $1)
                    
                }
                
                Spacer()
            }
        }
        .scrollIndicators(.never)
    }
    
}
                        
struct layoutListAddItem_Previews: PreviewProvider {
    static var previews: some View {
        layoutListAddItem()
    }
}

struct iconText : View {
    
    let iconImage : Image
    let iconText : String
    let iconColor : Color
    
    var body: some View {
        
        HStack {
            
            iconImage
                .resizable()
                .scaledToFit()
                .foregroundColor(iconColor)
                .frame(width: 24, height: 24)
            
        }
    }
}
                      
struct ControllerViewOptions : View {
    
    var callback : (RootView.Actions) -> ()
    
    var body: some View {
        HStack {

            ControllerViewOption(image: Image("pencil_icon"), tint: .black, text: "Edit/View")
                .padding(.horizontal, 16)
                .onTapGesture {
                    RootView.sVibrate()
                    callback(RootView.Actions.Edit)
                }
            
            ControllerViewOptionBIG(image: Image("play_icon"), tint: Color(UIColor(named: "Secondary")!), text: "Play")
                .padding(.horizontal, 16)
                .onTapGesture {
                    RootView.sVibrate()
                    callback(RootView.Actions.Play)
                }
            
            ControllerViewOption(image: Image("trash_icon"), tint: .red, text: "Delete")
                .padding(.horizontal, 16)
                .onTapGesture {
                    RootView.sVibrate()
                    callback(RootView.Actions.Delete)
                }

        }
    }
}

struct ControllerViewOption : View {
    
    var image : Image
    var tint : Color
    var text : String
    
    var body: some View {
        VStack {
            image
                .resizable()
                .colorMultiply(tint)
                .frame(width: 28, height: 28)
                .padding(4)
                .background(Circle()
                    .foregroundColor(.white))
            
            Text(text)
                .foregroundColor(.white)
                .font(.custom("Oswald-Medium", size: 12))
        }
    }
}

struct ControllerViewOptionBIG : View {
    
    var image : Image
    var tint : Color
    var text : String
    
    var body: some View {
        VStack(spacing: 0) {
            image
                .resizable()
                .colorMultiply(Color(uiColor: UIColor(named: "Primary1")!))
                .frame(width: 56, height: 56)
                .padding(4)
                .background(Circle()
                    .foregroundColor(tint))
            
            Text(text)
                .foregroundColor(tint)
                .font(.custom("Oswald-Medium", size: 16))
        }
    }
}

struct IconWithText : View {

    var image : String
    var tint : Color
    var text : String
    
    var body : some View {
        
        HStack {
            Image(image)
                .resizable()
                .frame(width: 24, height: 24)
                .colorMultiply(tint)
            
            Text(text)
                .font(.custom("Oswald-Medium", size: 16))
                .foregroundColor(tint)
        }
    }
}

struct PopupView : View {
    
    @Binding var currentPopup : LayoutCreateView.Popup
    let popupType : LayoutCreateView.Popup
    
    let Title : String!
    let Content : String!
    
    let onSubmit : (Bool) -> ()
    
    var body: some View {
        
        GeometryReader { geo in
            
            VStack {
                
                Spacer()
                    .frame(width: geo.size.width)
                
                HStack {
                    
                    Spacer()
                    
                    VStack {
                        
                        Text(Title)
                            .font(.custom("Oswald-Medium", size: 24))
                            .foregroundColor(.black)
                        
                        Text(Content)
                            .font(.custom("OpenSans-Light", size: 14))
                            .foregroundColor(.black)
                            .padding(.bottom, 16)
                        
                        HStack {
                            
                            
                            Text("Yes")
                                .font(.custom("Oswald-Medium", size: 18))
                                .foregroundColor(.black)
                                .onTapGesture {
                                    RootView.sVibrate()
                                    onSubmit(true)
                                    currentPopup = LayoutCreateView.Popup.NONE
                                }
                            
                            Spacer()
                                .frame(width: 36)
                            
                            Text("Cancel")
                                .font(.custom("Oswald-Medium", size: 18))
                                .foregroundColor(.red)
                                .onTapGesture {
                                    RootView.sVibrate()
                                    onSubmit(false)
                                    currentPopup = LayoutCreateView.Popup.NONE
                                }
                            

                        }
                        
                    }
                    .padding(16)
                    .background(RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.white))
                    
                    Spacer()

                }
                
                Spacer()
                    .frame(width: geo.size.width)

                
            }
            .background(.black.opacity(0.4))
            
        }
        
    }
    
}

struct CheckmarkView : View {
    
    let selectable : Bool
    @Binding var selected : Bool
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.black)
                .frame(width: 20, height: 20)
            
            Image(systemName: selected ? "checkmark" : "xmark")
                .resizable()
                .foregroundColor(selected ? .green : .red)
                .frame(width: 10, height: 10)
        }
        .onTapGesture {

            if(selectable) {
                RootView.sVibrate()

                selected.toggle()
            }
        }
        .frame(width: 20, height: 20)
    }
}

struct AutoCompleteList : View {
    
    @Binding var text : String
    @SwiftUI.State var displayWords = [String]()
    @Binding var autoCompleteType : ControlButton.type?
    let selectedKeybind : (String) -> ()

    var body: some View {
        
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                
                ForEach(displayWords, id: \.hash) {text in
                    Text(text)
                        .colorMultiply(.black)
                        .font(.custom("DMMono-Regular", size: 12))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 8)
                        .background(content: {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(.gray)
                        })
                        .onTapGesture {
                            selectedKeybind(text)
                            RootView.sVibrate()
                        }
                    
                    
                }
            }
        }
        .onChange(of: text, perform: { newString in
            displayWords = ButtonHandler.getKeybindList(for: autoCompleteType ?? ControlButton.type.Normal).filter { s in
                s.uppercased().contains(newString.uppercased())
            }
        })
        .onAppear {
            displayWords = ButtonHandler.getKeybindList(for: autoCompleteType ?? ControlButton.type.Normal).filter { s in
                s.uppercased().contains(text.uppercased())
            }
        }
    }
}

struct KeybindInputView : View {
    
    @Binding var text : String
    @SwiftUI.State var defaultText = "default"
    @Binding var checkmarkEnabled : Bool
    @SwiftUI.State var checkmarkSelectable : Bool = true
        
    let titleText : String
    @SwiftUI.State var checkmarkText : String = ""
    
    var isAutoComplete = false
    @Binding var autoCompleteType : ControlButton.type?
    
    var body: some View {
        
            VStack {
                
                    HStack {
                        Text(titleText)
                            .font(.custom("Oswald-Medium", size: 12))
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        if(isAutoComplete) {
                            //AutoCompleteView
                            AutoCompleteList(text: $text, autoCompleteType: $autoCompleteType) { text in
                                self.text = text
                            }
                            
                            Spacer()
                        }

                        
                        if(!checkmarkText.isEmpty) {
                            HStack {
                                
                                Text(checkmarkText)
                                    .font(.custom("Oswald-Medium", size: 12))
                                    .foregroundColor(.black)
                                
                                CheckmarkView(selectable: checkmarkSelectable, selected: $checkmarkEnabled)
                            }
                        }
                    }
                
                
                TextField(defaultText, text: $text)
                    .font(.custom("Oswald-Medium", size: 12))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .disableAutocorrection(true)
                    .keyboardType(.asciiCapable)/// KEYBOARD TYPE
                    .foregroundColor(.white)

                    .background(RoundedRectangle(cornerSize: CGSize(width: 16, height: 16))
                        .foregroundColor(.black.opacity(0.8)))
                    .offset(CGSize(width: 0, height: -10))

                
            }
            .ignoresSafeArea(.keyboard)
            .onChange(of: text) { newValue in
                
                if isAutoComplete && autoCompleteType != nil {
                    checkmarkEnabled = ButtonHandler.validateKeybind(text, buttonType: autoCompleteType!)
                }
                
            }
            .onAppear {
                if isAutoComplete && autoCompleteType != nil {
                    checkmarkEnabled = ButtonHandler.validateKeybind(text, buttonType: autoCompleteType!)
                }
            }
        
    }
}

struct KeybindPopupView : View {
    
    @Binding var currentPopup : LayoutCreateView.Popup
    let popupType : LayoutCreateView.Popup
    
    let onSubmitted : (ControlButton) -> ()
    
    @Binding var referenceButton : ControlButton?
    @SwiftUI.State var outputButton = ControlButton()

    @SwiftUI.State var nameEnabled = true
    @SwiftUI.State var validKeybind = true
    @SwiftUI.State var hapticsEnabled = true
    
    @SwiftUI.State var nameText = ""
    @SwiftUI.State var keybindText = ""
    
    @SwiftUI.State var buttonType : ControlButton.type?
    
    var body: some View {
        
        if(popupType == currentPopup) {
            GeometryReader { geo in
                
                VStack {
                    
                    Spacer()
                        .frame(height: 48)
                    
                    HStack {
                        
                        Spacer()
                            .frame(width: geo.size.width / 4)
                        
                        
                        VStack {
                            
                            HStack {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .foregroundColor(.black)
                                    .frame(width: 16, height: 16)
                                    .onTapGesture {
                                        RootView.sVibrate()
                                        currentPopup = LayoutCreateView.Popup.NONE
                                    }
                                
                                Spacer()
                                
                                Text("Apply")
                                    .font(.custom("Oswald-Medium", size: 16))
                                    .foregroundColor(.black)
                                    .onTapGesture {
                                        RootView.sVibrate()

                                        currentPopup = LayoutCreateView.Popup.NONE

                                        outputButton.isHapticsEnabled = hapticsEnabled
                                        outputButton.keybind = keybindText
                                        outputButton.name = nameText
                                        outputButton.showName = nameEnabled
                                        
                                        onSubmitted(outputButton)
                                    }
                            }
                            
                            ScrollView {
                                
                                VStack {
                                    
                                    KeybindInputView(text: $nameText, defaultText: "Ex: Jump", checkmarkEnabled: $nameEnabled, titleText: "Enter Name", checkmarkText: "Show Name:", isAutoComplete: false, autoCompleteType: $buttonType)
                                    
                                    KeybindInputView(text: $keybindText, defaultText: "Ex: Space", checkmarkEnabled: $validKeybind, checkmarkSelectable: false, titleText: "Enter Keybind", checkmarkText: "Valid Keybind", isAutoComplete: true, autoCompleteType: $buttonType)
                                    
                                    
                                    HStack {
                                        
                                        Text("Enabled Haptics:")
                                            .font(.custom("Oswald-Medium", size: 12))
                                            .foregroundColor(.black)
                                        
                                        CheckmarkView(selectable: true, selected: $hapticsEnabled)
                                    }
                                    
                                    Text("Set keybinds to xbox controller buttons, keyboard keys or mouse buttons")
                                        .font(.custom("DMMono-Regular", size: 16))
                                        .foregroundColor(.black)
                                    
                                }
                            }
                            
                            
                        }
                        .padding(16)
                        .background(RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.white))
                        
                        Spacer()
                            .frame(width: geo.size.width / 4 ,height: 64)
                        
                    }
                    
                    
                    
                }
                .background(.black.opacity(0.4))
            }
            .onAppear {
                if(referenceButton == nil) {
                    currentPopup = LayoutCreateView.Popup.NONE
                }
                
                outputButton.copyInfo(referenceButton!)

                buttonType = outputButton.type
                print(outputButton.type.rawValue)
                
                nameEnabled = outputButton.showName
                hapticsEnabled = outputButton.isHapticsEnabled
                
                nameText = outputButton.name
                keybindText = outputButton.keybind
                                                
            }
            
        }
        
    }
    
}

struct TexturePopupView : View {
    @Binding var currentPopup : LayoutCreateView.Popup
    let popupType : LayoutCreateView.Popup
    
    let onSubmitted : (ControlButton) -> ()
    
    @Binding var referenceButton : ControlButton?
    @SwiftUI.State var outputButton = ControlButton()
    
    @SwiftUI.State var bgColor = Color.red
    
    var body: some View {
        if(popupType == currentPopup) {
            GeometryReader { geo in
                
                VStack {
                    
                    Spacer()
                        .frame(height: 48)
                    
                    HStack {
                        
                        Spacer()
                            .frame(width: geo.size.width / 4)
                        
                        
                        VStack {
                            
                            HStack {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .foregroundColor(.black)
                                    .frame(width: 16, height: 16)
                                    .onTapGesture {
                                        RootView.sVibrate()
                                        currentPopup = LayoutCreateView.Popup.NONE
                                    }
                                
                                Spacer()
                                
                                Text("Apply")
                                    .font(.custom("Oswald-Medium", size: 16))
                                    .foregroundColor(.black)
                                    .onTapGesture {
                                        RootView.sVibrate()

                                        currentPopup = LayoutCreateView.Popup.NONE
                                        
                                        onSubmitted(outputButton)
                                    }
                            }
                            
                                
                            VStack {
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)

                            
                            
                        }
                        .padding(16)
                        .background(RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.white))
                        
                        Spacer()
                            .frame(width: geo.size.width / 4 ,height: 64)
                        
                    }
                    
                    
                    
                }
                .background(.black.opacity(0.4))
            }
            .onAppear {
                if(referenceButton == nil) {
                    currentPopup = LayoutCreateView.Popup.NONE
                }
                
                outputButton.copyInfo(referenceButton!)
            }
            
        }
    }
}

