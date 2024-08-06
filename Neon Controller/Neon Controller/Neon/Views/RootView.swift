//
//  RootView.swift
//  Neon Controller
//
//  Created by Yashua Evans on 8/8/23.
//

import SwiftUI

extension AnyTransition {
    static var MoveUp: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .bottom),
            removal: .move(edge: .top)
        )
    }
    
    static var MoveDown: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .top),
            removal: .move(edge: .bottom)
        )
    }
}

struct RootView: View {
    
    public enum Actions {
        case Edit
        case List
        case Delete
        case Settings
        case Play
        case Saved
        case Premium
        case Info
        case UIVisible
        case UIINVisible

        case NONE
    }
    
    static let generator = UIImpactFeedbackGenerator(style: .light)
    static let generator2 = UINotificationFeedbackGenerator()

    @SwiftUI.State var currentPage = UserData.Pages.NONE
    
    @SwiftUI.State var showDrawer = true
    
    @SwiftUI.State var transistionAnimation = AnyTransition.opacity
    
    @SwiftUI.State var selectedController : mController?
    
    @SwiftUI.State var titleText : String = "Controller List"
    
    @SwiftUI.State var isSavedPopupVisible = false
    
    @SwiftUI.State var isHelpVisible = false
    
    @SwiftUI.State var selectedDrawerItem = 1
    
    static public func sVibrate() {
        generator.impactOccurred()
    }
    
    static public func eVibrate() {
        generator2.notificationOccurred(.error)
    }
    
    func transistion(page: UserData.Pages) {
        
        UserData.currentFragment = page
        
        if(page == currentPage) { return }
        withAnimation { currentPage = page }
    }
    
    func rootCallback(action: RootView.Actions) {
        
        //Set animation type
        if(action == RootView.Actions.Edit) {
            
            UserData.currentFragment = UserData.Pages.Create

            transistionAnimation = .MoveUp
            transistion(page: UserData.Pages.Create)
            
            UserData.sendEvent("Page Changed", data: ["Page" : "Create Page"])

        } else if(action == RootView.Actions.List){
            
            transistionAnimation = .MoveDown
            transistion(page: UserData.Pages.Layouts)
            UserData.sendEvent("Page Changed", data: ["Page" : "List Page"])

        } else if(action == RootView.Actions.Delete) {
            
            if(selectedController!.controllerID == mController.defaultUUID) {
                RootView.eVibrate()
                return
                
            }
            UserData.sendEvent("Layout Deleted", data:
                                ["Layout Name" : selectedController!.controllerName,
                                 "Layout Description" : selectedController!.description,
                                 "Button Count" : selectedController!.buttons.count.description])

            selectedController!.delete()
            
            selectedController = UserData.savedControllers.first
            SaveController.SaveSelectedController(selectedController!)
            

            
        } else if(action == RootView.Actions.Saved) {
            
            isSavedPopupVisible = true
            
        } else if(action == RootView.Actions.Play) {
            
            transistionAnimation = .opacity
            transistion(page: UserData.Pages.Computers)
            
            UserData.currentController = selectedController
            

            selectedDrawerItem = 0

            UserData.sendEvent("Page Changed", data: ["Page" : "Play Page",
                                                      "Layout Name" : selectedController!.controllerName])


        } else if(action == RootView.Actions.Settings) {
            
            transistionAnimation = .move(edge: .trailing)
            transistion(page: UserData.Pages.Settings)
            
            UserData.sendEvent("Page Changed", data: ["Page" : "Settings Page"])

        } else if(action == RootView.Actions.Premium) {
            
            transistionAnimation = .move(edge: .trailing)
            transistion(page: UserData.Pages.Premium)
            UserData.sendEvent("Page Changed", data: ["Page" : "Premium Page Page"])

            
        } else if(action == RootView.Actions.Info) {
            
            transistionAnimation = .move(edge: .trailing)
            transistion(page: UserData.Pages.Info)
            
            UserData.sendEvent("Page Changed", data: ["Page" : "Info Page"])

            
        }
    }

    var body: some View {
        ZStack {
            
            // Don't show the animated background if play page is present
            // Play page has it's own animated background
            if(currentPage != UserData.Pages.Play
               && currentPage != UserData.Pages.Computers
               && currentPage != UserData.Pages.Games) {
                
                AnimatedBackground()

            }
            
            if(currentPage == UserData.Pages.Layouts) {
                LayoutListView(selectedController: Binding(($selectedController))!, callback: rootCallback)
                    .transition(transistionAnimation)
                
            } else if(currentPage == UserData.Pages.Create) {
                LayoutCreateView(callback: rootCallback, refController: Binding($selectedController)!)
                    .transition(transistionAnimation)
                
            } else if(currentPage == UserData.Pages.Computers ||
                      currentPage == UserData.Pages.Games ||
                      currentPage == UserData.Pages.Play) {
                
                PlayView()
                    .transition(transistionAnimation)
                
            } else if(currentPage == UserData.Pages.Settings) {
                
                SettingsView()
                    .transition(transistionAnimation)
                
            } else if(currentPage == UserData.Pages.Premium) {
                
                PremiumPage()
                    .transition(transistionAnimation)
                
            } else if(currentPage == UserData.Pages.Info) {
                
                InfoPage()
                    .transition(transistionAnimation)
                
            }
            
            UIOverlayView(TitleText: $titleText, isDrawerVisible: $showDrawer, isHelpVisible: $isHelpVisible, selectedDrawerItem: $selectedDrawerItem) { selectedTab in
                
                //Play Tab
                if(selectedTab == 0) {
                    rootCallback(action: RootView.Actions.Play)
                }
                
                //Controller Tab
                if(selectedTab == 1) {
                    rootCallback(action: RootView.Actions.List)
                }
                
                //Settings Tab
                if(selectedTab == 2) {
                    rootCallback(action: RootView.Actions.Settings)
                }
                
                //Discord Tab (don't do anything)
                if(selectedTab == 3) {
//                    rootCallback(action: RootView.Actions.Play)
                    
                }
                
                //Discord Tab (don't do anything)
                if(selectedTab == 4) {
                    rootCallback(action: RootView.Actions.Premium)
                    
                }
                
                if(selectedTab == 5) {
                    rootCallback(action: RootView.Actions.Info)
                    
                }
            }
            
            HelpController(visible: $isHelpVisible)
        }
        .onChange(of: currentPage) { newView in
            showDrawer = newView != UserData.Pages.Create
            
            if newView == UserData.Pages.Create {
                titleText = selectedController!.controllerName
            }
            
            if newView == UserData.Pages.Layouts {
                titleText = "Controller List"

            }
            
            if newView == UserData.Pages.Computers {
                titleText = "Wifi Play"

            }
            
            if newView == UserData.Pages.Info {
                titleText = "Neon Controller"

            }
        }
        .onAppear() {
            
            UserData.startup()
            selectedController = UserData.currentController!
            rootCallback(action: RootView.Actions.List)
        

    
        }
    }
}
