//
//  LayoutListView.swift
//  Neon Controller
//
//  Created by Yashua Evans on 8/8/23.
//

import SwiftUI

struct LayoutListView: View {
    
    @Binding var selectedController : mController
    @SwiftUI.State var isNewControllerVisible = false
    
    var callback : (RootView.Actions) -> ()

    var body: some View {
        
        ZStack {
            VStack {
                LayoutList(selected: $selectedController) {
                    isNewControllerVisible = true
                }
                    .padding([.bottom, .horizontal], 16)
                    
                    ControllerViewOptions { action in
                        callback(action)
                    }
                    
                }
                .padding(.top, 64)
                
                if(isNewControllerVisible) {
                    CreateNewControllerView(visible: $isNewControllerVisible, onCreateNewView: { controller in
                        UserData.savedControllers.append(controller)
                        UserData.currentController = controller
                        
                        SaveController.SaveLayout(controller)
                        SaveController.SaveLayouts()
                        SaveController.SaveSelectedController(controller)
                        
                        selectedController = controller
                        
                        callback(RootView.Actions.Edit)
                    })
                }
            }
    }
}

struct CreateNewControllerView : View {
    
    @Binding var visible : Bool
    
    @SwiftUI.State var controllerTitle = ""
    @SwiftUI.State var controllerDescription = ""
    @SwiftUI.State var isPremiumPopupVisible = false
    
    let onCreateNewView : (mController) -> ()

    var body: some View {
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
                                    visible  = false
                                }
                            
                            Spacer()
                            
                        }
                        
                        Text("New Controller")
                            .font(.custom("Oswald-Medium", size: 24))
                            .foregroundColor(.black)
                        
                        TextField("Enter Controller Title", text: $controllerTitle)
                            .font(.custom("Oswald-Medium", size: 12))
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .disableAutocorrection(true)
                            .keyboardType(.asciiCapable)/// KEYBOARD TYPE
                            .foregroundColor(.white)

                            .background(RoundedRectangle(cornerSize: CGSize(width: 16, height: 16))
                                .foregroundColor(.black.opacity(0.8)))
                        
                        TextField("Enter Controller Description", text: $controllerDescription)
                            .font(.custom("Oswald-Medium", size: 12))
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .disableAutocorrection(true)
                            .keyboardType(.asciiCapable)/// KEYBOARD TYPE
                            .foregroundColor(.white)

                            .background(RoundedRectangle(cornerSize: CGSize(width: 16, height: 16))
                                .foregroundColor(.black.opacity(0.8)))
                        
                        Text("Create")
                            .padding(.top, 16)
                            .font(.custom("Oswald-Medium", size: 24))
                            .foregroundColor(Color(UIColor(named: "Secondary")!))
                            .onTapGesture {
                                
                                if(UserData.isPremium) {
                                    onCreateNewView(mController(controllerName: controllerTitle, controllerDescription: controllerDescription))
                                } else {
                                    isPremiumPopupVisible = true
                                    RootView.eVibrate()
                                }
                            }
                        
                        Spacer()
                            .frame(height: 16)
                        
                    }
                    .padding(16)
                    .background(RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.white))
                    
                    Spacer()
                        .frame(width: geo.size.width / 4 ,height: 64)
                    
                }
                
                Spacer()
                
            }
            .background(.black.opacity(0.4))
            .alert("You need Premium!", isPresented: $isPremiumPopupVisible) {
                Button("OK", role: .destructive) {
                    print("open premium screen")
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Please upgrade to premium to create more layouts")
            }
        }
    }
}
