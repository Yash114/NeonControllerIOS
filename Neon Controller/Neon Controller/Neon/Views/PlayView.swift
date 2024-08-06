//
//  PlayView.swift
//  Neon Controller
//
//  Created by Yashua Evans on 10/15/23.
//

import SwiftUI

struct PlayView: View {
    var body: some View {
        GeometryReader { geo in
            TestViewControllerWrapper()
                .background(Color.clear)
                .foregroundColor(.clear)
                .edgesIgnoringSafeArea(.all)
        }

    }
}

struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        PlayView()
    }
}
