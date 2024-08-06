//
//  UIOverlayView.swift
//  Neon Controller
//
//  Created by Yashua Evans on 8/8/23.
//

import SwiftUI

class UIOverlayController : ObservableObject {
    @Published var showPlayOptions = false
    
    init() {
        let myThread = Thread(target: self, selector: #selector(performWork), object: nil)
        myThread.start()
    }
    
    @objc
    func performWork() {
        
        while(true) {
            
            if(showPlayOptions != (UserData.currentFragment == UserData.Pages.Play)) {
                
                DispatchQueue.main.async {
                    self.showPlayOptions = (UserData.currentFragment == UserData.Pages.Play)
                    
                    if(self.showPlayOptions) {
                        print("this is happening")
                    }

                }
            }
            
            sleep(1)
            
        }
    }
}

    struct UIOverlayView: View {
        
        @SwiftUI.State var OpenDrawer = false
        
        @Binding var TitleText : String
        
        @Binding var isDrawerVisible : Bool
        
        @Binding var isHelpVisible : Bool
        
        @Binding var selectedDrawerItem : Int
        
        @SwiftUI.State var isPremium = false
        
        @SwiftUI.State var hideUIElements = false
                
        @SwiftUI.ObservedObject var uicontroller  = UIOverlayController()
                
        let onSelectItem : (Int) -> ()
        
        var body: some View {
            if(!hideUIElements) {
                
                VStack {
                    
                    HStack {
                        
                        Image("LogoImage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text(TitleText)
                                .font(.custom("Oswald-Medium", size: 32))
                                .foregroundColor(.white)
                            
                            HStack(spacing: 0) {
                                Image("shine_icon")
                                    .resizable()
                                    .scaledToFit()
                                    .colorMultiply(isPremium ? Color.yellow : Color.purple)
                                    .frame(width: 16, height: 16)
                                    .padding(.trailing, 4)
                                
                                
                                Text(isPremium ? "Premium" : "Basic")
                                    .font(.custom("Oswald-Medium", size: 12))
                                    .foregroundColor(isPremium ? Color.yellow : Color.purple)
                                
                                
                            }
                            .offset(CGSize(width: 0, height: -8))
                        }
                        .frame(height: 64)
                        
                        
                        Spacer()
                        
                        if(isDrawerVisible) {
                            
                            Image(systemName: "line.3.horizontal")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                                .padding(8)
                                .background(Color(UIColor(named: "Secondary")!))
                                .onTapGesture {
                                    withAnimation {
                                        
                                        OpenDrawer.toggle()
                                        RootView.sVibrate()
                                        
                                        print("clicked drawer")
                                    }
                                }
                                .shadow(radius: 8)
                        }
                    }
                    
                    Spacer()
                    
                    HStack(alignment: .center) {
                        
                        Spacer()
                        
                        drawerView(drawerOpen: $OpenDrawer, selectedItem: $selectedDrawerItem, onSelectItem: onSelectItem)
                        
                        Spacer()

                    }
                    
                    
                    Spacer()
                    
                    
                    HStack {
                        
                        
                        //Add fullscreen & back to create
                        if(uicontroller.showPlayOptions) {
                            
                            Image("fullscreen_icon")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(8)
                                .background(Circle()
                                    .foregroundColor(.black))
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    hideUIElements = true
                                    let notificationName = Notification.Name("FullscreenCallback")
                                    let notif = Notification(name: notificationName, object: nil, userInfo: ["fullscreen" : true]);
                                    NotificationCenter.default.post(notif)
                                }
                            
//                            HStack {
//                                Image("pencil_icon")
//                                    .resizable()
//                                    .colorMultiply(Color(uiColor: UIColor(named: "Secondary")!))
//                                    .frame(width: 20, height: 20)
//                                
//                                
//                                Text("Edit Controller")
//                                    .font(.custom("Oswald-Medium", size: 16))
//                                    .foregroundColor(Color(uiColor: UIColor(named: "Secondary")!))
//                                
//                            }
//                            .padding(.leading, 8)
                        }
                        
                        
                        Spacer()
                        
                        Image("help_icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .padding(.horizontal)
                            .contentShape(Rectangle())
                            .background(.clear)
                            .onTapGesture {
                                RootView.sVibrate()
                                
                                isHelpVisible = true
                                print("clicked help")
                            }
                        
                    }
                }
                .onAppear {
                    isPremium = UserData.isPremium
                    
                    let notificationName = Notification.Name("flagUpdate")
                    NotificationCenter.default.addObserver(forName: notificationName, object: nil, queue: .main) { Notification in
                        if let isPremiumFlag = Notification.userInfo?["isPremium"] {
                            isPremium = isPremiumFlag as! Bool
                            RootView.sVibrate()
                        }
                    }
                }
                
                
            }
            
            if(hideUIElements) {
                
                VStack {
                    Image("fullscreen_icon")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(8)
                        .background(Circle()
                            .foregroundColor(.black))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            hideUIElements = false
                            
                            let notificationName = Notification.Name("FullscreenCallback")
                            let notif = Notification(name: notificationName, object: nil, userInfo: ["fullscreen" : false]);
                            NotificationCenter.default.post(notif)
                        }
                    
                    Spacer()
                }
            }
            
        }
}
