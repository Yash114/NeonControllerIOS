//
//  PremiumPage.swift
//  Neon Controller
//
//  Created by Yashua Evans on 11/17/23.
//

import SwiftUI
import RevenueCat


struct PremiumPage: View {
    
    @SwiftUI.State var selectedChoice : Int = 0
    
    @SwiftUI.State var products = [Package]()
    
    @SwiftUI.State var isRestorePurchasesVisisble = false
    
    var body: some View {
        
        GeometryReader { geo in
            
            ZStack {
                
                
                VStack {
                    
                    Spacer()
                        .frame(height: 64)
                    
                    HStack(alignment: .center) {
                        
                        List(products) { product in
                            PremiumChoiceSelector(index: products.lastIndex(of: product)!, selectedIndex: $selectedChoice, product: product)
                                .listRowInsets(.init(top: 0, leading: 0, bottom: 8, trailing: 0))
                            
                        }
                        .listSectionSeparator(.hidden)
                        .listStyle(.plain)
                        .frame(width: geo.size.width / 2)
                        
                        
                        
                        VStack(alignment: .leading) {
                            CheckmarkedText(text: "Infinite Buttons")
                            CheckmarkedText(text: "Infinite Custom Layouts")
                            CheckmarkedText(text: "Texture Customization")
                            CheckmarkedText(text: "Motion Controls (coming soon)")
                            CheckmarkedText(text: "Command Editor (coming soon)")
                            CheckmarkedText(text: "Layout Library (coming soon)")
                            
                        }
                        .frame(width: geo.size.width / 2)
                        
                    }
                    
                    Text("SUBSCRIBE")
                        .font(.custom("Oswald-Medium", size: 24))
                        .foregroundColor(.white)
                        .padding(.horizontal, 144)
                        .padding(.vertical, 8)
                        .background(
                            GoldenGradientView2()
                                .clipShape(RoundedRectangle(cornerRadius: 800))
                            
                        )
                        .padding(.top, 16)
                        .onTapGesture {
                            UserData.sendEvent("Purchase Subscription Clicked", data: [:])

                            RootView.sVibrate()
                            
                            Purchases.shared.purchase(package: products[selectedChoice]) { (transaction, customerInfo, error, userCancelled) in
                                if(customerInfo != nil) {
                                    if customerInfo!.entitlements["Premium Subscription"]?.isActive == true {
                                        UserData.isPremium = true
                                        SaveController.SaveFlags()
                                        
                                        print("customer is premium")
                                        
                                        let notification = Notification.Name("flagUpdate")
                                        
                                        let data = ["isPremium" : true];
                                        
                                        NotificationCenter.default.post(name: notification, object: nil, userInfo: data)
                                    }
                                }
                            }
                            
                        }
                    
                    if(products.count > 0) {
                                                
                        Text("Play like a Pro!")
                            .font(.custom("OpenSans-Light", size: 12))
                            .foregroundColor(.white)
                        
                    }
                    
                }
                
                VStack {
                    
                    Spacer()
                    
                    HStack {
                        
                        Text("Restore Purchases")
                            .font(.custom("Oswald-Medium", size: 8))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 4)
                            .background(
                                .gray
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 800))
                            .onTapGesture {
                                
                                UserData.sendEvent("Restore Purchases Clicked", data: [:])
                                
                                isRestorePurchasesVisisble = true
                                
                                RootView.sVibrate()
                                
                                Purchases.shared.restorePurchases { customerInfo, error in
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
                        
                        Spacer()
                        
                    }
                    .padding(.bottom, 32)
                }
            }
            .onAppear {
                Purchases.shared.getOfferings { (offerings, error) in
                    if let gatheredPackages = offerings?.current?.availablePackages {
                        products = gatheredPackages
                    }
                }
            }
            .alert("Purchases Restored", isPresented: $isRestorePurchasesVisisble) {
                Button("OK", role: .cancel) { }
            }
        }
    }
}

struct CheckmarkedText : View {
    
    @SwiftUI.State var text : String
        
    var body: some View {
        
        HStack {
                        
            ZStack {
                Circle()
                    .foregroundColor(Color(hex: "#FFFFD700"))
                    .frame(width: 20, height: 20)
                
                Image(systemName: "checkmark")
                    .resizable()
                    .foregroundColor(.black)
                    .frame(width: 10, height: 10)
            }
            
            Text(text)
                .font(.custom("Oswald-Medium", size: 12))
                .foregroundColor(.white)


        }
    }
    
}

struct PremiumChoiceSelector : View {
    
    @SwiftUI.State var isBestValueVisible : Bool = true
    
    @SwiftUI.State var index : Int
    @Binding var selectedIndex : Int
    
    @SwiftUI.State var product : Package
    @SwiftUI.State var priceText : String = ""
    @SwiftUI.State var saveText : String = ""

    var body: some View {
        
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    if(isBestValueVisible) {
                        Text("Best Value")
                            .foregroundColor(selectedIndex == index ? .black : .white)
                            .font(.custom("OpenSans-Light", size: 10))
                        
                        Spacer()

                        Text(saveText)
                            .foregroundColor(selectedIndex == index ? .black : .white)
                            .font(.custom("Oswald-Medium", size: 10))
                    }
                    
                }
                
                HStack {
                    
                    if(!isBestValueVisible) {
                        
                        Text(priceText)
                            .foregroundColor(selectedIndex == index ? .black : .white)
                            .font(.custom("Oswald-Medium", size: 20))
                        
                        Spacer()
                        
                        VStack {
                            
                            Text(saveText)
                                .foregroundColor(selectedIndex == index ? .black : .white)
                                .font(.custom("Oswald-Medium", size: 10))
                            
                            Spacer()
                                .frame(height: 24)
                        }
                            
                    }
                }
                
                if(isBestValueVisible) {
                    
                    Text(priceText)
                        .foregroundColor(selectedIndex == index ? .black : .white)
                        .font(.custom("Oswald-Medium", size: 20))
                    
                }
            }
            .padding(.horizontal,12)
            .padding(.vertical,4)

            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.white, lineWidth: 3)
                        
                    
                    Group {
                        if(selectedIndex == index) {
                            GoldenGradientView()
                        } else {
                            Color.black
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                
            }
            .padding(4)
            .onTapGesture {
                withAnimation {
                    selectedIndex = index
                    RootView.sVibrate()
                    
                    UserData.sendEvent("Premium Sub Term Clicked", data:
                                        ["term" : translateUnit(sub: product.storeProduct.subscriptionPeriod!),
                                         "cost" : product.storeProduct.price.description,
                                        "currency" : product.storeProduct.currencyCode!])

                }
            }
            .onAppear {
                
                //0: day, 1: week, 2: month, 3: year
                let subPeriod = translateUnit(sub: product.storeProduct.subscriptionPeriod! )
                
                priceText = product.storeProduct.currencyCode! + " \(product.storeProduct.price) / " +
                    subPeriod
                    
                saveText = "Charged " +
                    translateUnit(sub: product.storeProduct.subscriptionPeriod!) +
                    "ly"

                isBestValueVisible = product.storeProduct.subscriptionPeriod!.unit.rawValue == 3
                
                if(subPeriod == "Week") {
                    saveText = ""
                }
                
                if(subPeriod == "Month") {
                    saveText = "Save 20%"
                }
                
                if(subPeriod == "Year") {
                    saveText = "Save 35%"
                }
            }
            

        }
    }
    
    func translateUnit(sub : SubscriptionPeriod) -> String {
        if(sub.unit.rawValue == 1) {
            return "Week"
        }
        
        if(sub.unit.rawValue == 2) {
            return "Month"
        }
        
        if(sub.unit.rawValue == 3) {
            return "Year"
        }
        
        return "Day"
    }
}

struct GoldenGradientView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color(red: 1, green: 0.97, blue: 0.858), Color(red: 1, green: 0.858, blue: 0.36)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .edgesIgnoringSafeArea(.all)
    }
}


struct GoldenGradientView2: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color(red: 0.675, green: 0.549, blue: 0.1019), Color(red: 1, green: 0.858, blue: 0.36)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .edgesIgnoringSafeArea(.all)
    }
}


struct PremiumPage_Previews: PreviewProvider {
    static var previews: some View {
        PremiumPage()
    }
}
