//
//  HelpController.swift
//  Neon Controller
//
//  Created by Yashua Evans on 11/13/23.
//

import SwiftUI

struct HelpController: View {
    
    @Binding var visible : Bool
    @SwiftUI.State var currentPage : Int = 0
    
    var body: some View {
        
        if(visible) {
            HStack (alignment: .bottom) {
                
                Spacer()
                
                VStack (alignment: .trailing) {
                    
                    Spacer()
                    
                    VStack {
                        
                        Text(
                            (HelpData.helpNotes[UserData.currentFragment.rawValue] ?? HelpData.helpNotes[UserData.Pages.Layouts.rawValue])!.helpText[currentPage])
                        
                            .font(.custom("OpenSans-Light", size: 14))
                            .foregroundColor(.black)
                            .padding(.bottom, 16)
                        
                        HStack {
                            Text("Close")
                                .font(.custom("Oswald-Medium", size: 16))
                                .bold()
                                .foregroundColor(Color(uiColor: UIColor(named: "Secondary")!))
                                .onTapGesture {
                                    visible = false
                                    currentPage = 0

                                    RootView.sVibrate()
                                }
                            
                            Spacer()
                                .frame(width: 72)
                            
                            Text((HelpData.helpNotes[UserData.currentFragment.rawValue] ?? HelpData.helpNotes[UserData.Pages.Layouts.rawValue])!.helpText.count - 2 < currentPage ? "Done" : "Next ->")
                                .font(.custom("Oswald-Medium", size: 16))
                                .bold()
                                .foregroundColor(Color(uiColor: UIColor(named: "Secondary")!))
                                .onTapGesture {
                                    
                                    if((HelpData.helpNotes[UserData.currentFragment.rawValue] ?? HelpData.helpNotes[UserData.Pages.Layouts.rawValue])! == nil) { return }
                                    
                                    if((HelpData.helpNotes[UserData.currentFragment.rawValue] ?? HelpData.helpNotes[UserData.Pages.Layouts.rawValue])!.helpText.count > currentPage + 1) {
                                        currentPage += 1
                                    } else {
                                        
                                        currentPage = 0
                                        visible = false
                                    }
                                    
                                    RootView.sVibrate()
                                }
                        }
                        
                    }
                    .padding(16)
                    .frame(maxWidth: 188)
                    .background( RoundedRectangle(cornerSize: CGSize(width: 8, height: 8))
                        .foregroundColor(Color(uiColor: UIColor(named: "Primary1")!))
                    )
                    .shadow(radius: 8)
                    
                }
            }
            .onChange(of: visible) { newValue in
            
                currentPage = 0
            }
        }
    }
}

class HelpPage {
    
    var helpText : [String]
    
    init(_ textValues : [String]) {
        
        helpText = textValues
        
    }
    
}

class HelpData {
    
    static var helpNotes = [Int : HelpPage]()
    
    public static func createHelpNotes() {
        
        helpNotes.updateValue(
            HelpPage([
                "Welcome to Neon Controller! The app that allows you to play your PC games on mobile!",
                "To get started click on the PLAY button!"
            ] as! [String]), forKey: UserData.Pages.FirstTimeOpen.rawValue)
        
        helpNotes.updateValue(
            HelpPage([
                "This is the Layouts Page, here you can see your PC Game Controllers",
                "To create a new custom controller click on the NEW button",
                "To delete a controller click on the DELETE button",
                "To customize a controller click on the EDIT button",
                "To copy a controller click and hold a the selected cotroller",
                "To use your controller to play PC games click on hold the PLAY button"
                
            ] as! [String]), forKey: UserData.Pages.Layouts.rawValue)
        
        
        helpNotes.updateValue(
            HelpPage([
                "Welcome to WiFi Play! After connecting to your computer you can remote play your games!",
                "Please go to neoncontroller.com to get the host PC software.",
                "Your mobile device and computer MUST be on the same network to connect.",
                "Once you finish paring your PC and mobile device you can play.",
                "Have Fun!"
                
            ] as! [String]), forKey: UserData.Pages.Computers.rawValue)
        
        helpNotes.updateValue(
            HelpPage([
                "Here you can select the game you want to play.",
                "Select one of the presented options to begin playing",
            ] as! [String]), forKey: UserData.Pages.Games.rawValue)
        
        helpNotes.updateValue(
            HelpPage([
                "Here is where you can actually play your games.",
                "Move the mouse by swiping on the screen and click by tapping the screen.",
                "Right click by tapping with 2 fingers and scroll by sliding with 2 fingers.",
                "To customize your controls from here click on the \"edit controls\" button.",
                "Happy Gaming!",
            ] as! [String]), forKey: UserData.Pages.Play.rawValue)
        
        helpNotes.updateValue(
            HelpPage([
                "Welcome to the Create Page! Here you can customize the controls for your games.",
                "On the left is a drawer that contains all of the button types.",
                "After selecting a button, you can customize the button using the bottom menu.",
                "When you are done, click on the play button!"
            ] as! [String]), forKey: UserData.Pages.Create.rawValue)
        
        helpNotes.updateValue(
            HelpPage([
                "Welcome to the Premium Page",
                "This is where you can purchase a subscription to unlock all of Neon's Premium features!",
                "Simply Click on a subscription offer on the left then click SUBSCRIBE."
            ] as! [String]), forKey: UserData.Pages.Premium.rawValue)
    }
    
}

//struct HelpController_Previews: PreviewProvider {
//    static var previews: some View {
////        HelpController()
//    }
//}
