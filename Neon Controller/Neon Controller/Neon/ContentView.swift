//
//  ContentView.swift
//  Neon Controller
//
//  Created by Yashua Evans on 8/8/23.
//

import SwiftUI

struct ContentView: View {
    
    @SwiftUI.State var continueToRoot = false
    let userData = UserData()

    
    var body: some View {
        
        ZStack {
            if(continueToRoot) {
                userData.rootView
            } else {
                IntroView()
            }
        }
        .onAppear() {
            
            Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (_) in
                
                withAnimation {
                    continueToRoot = true
                }
            }
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
