//
//  InfoView.swift
//  Neon Controller
//
//  Created by Yashua Evans on 12/13/23.
//

import SwiftUI

struct InfoPage: View {
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                
                Text("Privacy Policy: ")
                    .font(.custom("Oswald-Medium", size: 20))
                    .foregroundColor(.white)
                
                Link("neoncontroller.app", destination: URL(string: "https://www.neoncontroller.app/privacy-policy")!)
                    .font(.headline)
                    .foregroundColor(.blue)
                
            }
            
            HStack {
                
                Text("Terms of Use: ")
                    .font(.custom("Oswald-Medium", size: 20))
                    .foregroundColor(.white)
                
                Link("apple.com", destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                    .font(.headline)
                    .foregroundColor(.blue)
                
            }
            
            Spacer()
            
            Text("Gingertech Inc. 2023")
                .font(.custom("Oswald-Medium", size: 12))
                .foregroundColor(.gray)

        }
    }
}

struct InfoPage_Previews: PreviewProvider {
    static var previews: some View {
        InfoPage()
    }
}
