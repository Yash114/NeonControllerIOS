//
//  UserData.swift
//  Neon Controller
//
//  Created by Yashua Evans on 8/9/23.
//

import Foundation
import RevenueCat
import Mixpanel

@objc class UserData : NSObject, ObservableObject {
    
    @objc public static let defaultMaxButtons = 6
    
    public let rootView = RootView()

    @objc public enum Pages: Int {
        case Layouts = 0;
        case Create = 1;
        case Computers = 2;
        case Games = 3;
        case Play = 4;
        case Settings = 5;
        case Premium = 8;
        case Info = 9;

        case FirstTimeOpen = 6;
        case NONE = 7;

    }

    @objc static public var savedControllers = [mController]()
    @objc static public var currentController : mController?
    
    @objc static public var currentFragment = Pages.NONE
    
    @objc static public var isPremium = false

    
    @objc public func setCurrentPage(page : Pages) {
                
        UserData.currentFragment = page;

    }

    @objc public func getCurrentPage() -> Pages {
        return UserData.currentFragment
    }
    
    @objc static public func initializeMixpanel() {
        Mixpanel.initialize(token: "0a927c88c5da2677f2796a6e57420110", trackAutomaticEvents: true)
    }
    
    @objc static public func sendEvent(_ eventName : String, data : [String: String]) {
        Mixpanel.mainInstance().track(event: eventName, properties: data);
    }
    
    
    public static func startup() {
        initializeMixpanel()
        
        UserData.savedControllers = SaveController.GetLayouts()
        HelpData.createHelpNotes()
                
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            // access latest customerInfo

            if(customerInfo != nil) {

                if customerInfo!.entitlements["Premium Subscription"]?.isActive == true {
                    UserData.isPremium = true

                    print("customer is premium")

                    let notification = Notification.Name("flagUpdate")

                    let data = ["isPremium" : true];

                    NotificationCenter.default.post(name: notification, object: nil, userInfo: data)
                }
            }
        }

    }
        
}
