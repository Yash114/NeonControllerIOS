//
//  SettingsView.swift
//  Neon Controller
//
//  Created by Yashua Evans on 11/14/23.
//

import SwiftUI


struct SettingsView: View {
    let videoResolutions = ["360p", "720p", "1080p", "4K", "Native Resolution"]
    let videoFramerates = ["30FPS", "60FPS"]
    
    @SwiftUI.State var selectedResolutionIndex = 0
    @SwiftUI.State var selectedFrameratesIndex = 0

    @SwiftUI.State var bitrate : Double = 0
    
    @SwiftUI.State var stretchVideo = false
    @SwiftUI.State var fillVideo = false
    @SwiftUI.State var enableVibration = true
    @SwiftUI.State var audioOnPC = true


    private let SettingsDataManager = DataManager()
    
    private func StringToSettingValue(_ string : String, default : Any) -> Any? {
        if(videoResolutions.contains(string)) {
            
            switch (string) {
                case ("360p"):
                    return CGSize(width: 640, height: 360);
                    
                case ("720p"):
                    return CGSize(width: 1280, height: 720);

                case ("1080p"):
                    return CGSize(width: 1920, height: 1080);

                case ("4K"):
                    return CGSize(width: 3840, height: 2160);
                
                case ("Native Resolution"):
                    return CGSize(
                        width: UIScreen.main.bounds.width,
                        height: UIScreen.main.bounds.height
                    );
                
                default:
                    return nil
                
            }
        }
        
        if(videoFramerates.contains(string)) {
            
            switch (string) {
                case ("30FPS"):
                    return 30
                    
                case ("60FPS"):
                    return 60
                
                default:
                    return nil
                
            }
        }
        
        return nil
    }

    
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            VStack {
                StylizedSliderView(title: "Video Bitrate", description: "Increase for better video quality. Decrease to improve performance.", valueSuffix: "kbps", sliderMin: 500, sliderMax: 150000, sliderValue: $bitrate)
                
                HorizontalScrollableStackView(title: "Video Resolution", description: "Increase to impove video clarity. Descrease to improve performance", items: videoResolutions, selected: $selectedResolutionIndex)
                
                HorizontalScrollableStackView(title: "Frame Rate", description: "Increase for a smoother video stream. Descrease to improve performance", items: videoFramerates, selected: $selectedFrameratesIndex)
                
//                StylizedCheckmarkView(title: "Strech Video to full-screen?", description: "", isChecked: $stretchVideo)

//                StylizedCheckmarkView(title: "Fill Video to full-screen?", description: "", isChecked: $fillVideo)

                StylizedCheckmarkView(title: "Enable Vibration", description: "", isChecked: $enableVibration)
                
                StylizedCheckmarkView(title: "Enable Audio on PC", description: "", isChecked: $audioOnPC)

                
                Button("Save Settings") {
                    
                    RootView.sVibrate()
                    
                    let screenRes : CGSize = StringToSettingValue(videoResolutions[selectedResolutionIndex], default: 0) as! CGSize
                    
                    SettingsDataManager.saveSettings(
                        withBitrate: Int(bitrate),
                        framerate: StringToSettingValue(videoFramerates[selectedFrameratesIndex], default: "n") as! Int,
                        height: Int(screenRes.height),
                        width: Int(screenRes.width),
                        audioConfig: 2,
                        onscreenControls: 0,
                        enableVibration: enableVibration,
                        optimizeGames: false,
                        multiController: false,
                        swapABXYButtons: false,
                        audioOnPC: true,
                        useHevc: true,
                        useFramePacing: true,
                        enableHdr: false,
                        btMouseSupport: false,
                        absoluteTouchMode: false,
                        statsOverlay: true)
                }
                .font(.custom("Oswald-Medium", size: 24))
                .foregroundColor(Color(uiColor: UIColor(named: "Primary1")!))
                .padding(.horizontal, 16)
                .padding(.vertical, 4)
                .background(
                    Rectangle()
                        .foregroundColor(Color(uiColor: UIColor(named: "Secondary")!))
                    )
                
                Spacer()
                    .frame(height: 48)
            }
            
        }
        .padding(.top, 64)
        .onAppear {
            let settings = SettingsDataManager.getSettings()!
            
            bitrate = settings.bitrate.doubleValue
            enableVibration = settings.enableVibration
            audioOnPC = settings.playAudioOnPC
            
            // Framerate group
            do {
                if(settings.framerate == 30) {
                    selectedFrameratesIndex = 0
                }
                
                if(settings.framerate == 60) {
                    selectedFrameratesIndex = 1
                }
            }
            
            do {
                if(settings.height == 360) {
                    selectedResolutionIndex = 0
                } else
                
                if(settings.height == 720) {
                    selectedResolutionIndex = 1
                } else
                
                if(settings.height == 1080) {
                    selectedResolutionIndex = 2
                } else
                
                if(settings.height == 2160) {
                    selectedResolutionIndex = 3
                } else
                
                if(settings.height.doubleValue == UIScreen.main.bounds.height) {
                    selectedResolutionIndex = 4
                }
                    else
                {
                    selectedResolutionIndex = 1
                }
            }
        }

    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

struct StylizedSliderView: View {
    
    let title : String
    let description : String
    
    var valueSuffix : String = ""

    @SwiftUI.State var sliderMin: Double = 500
    @SwiftUI.State var sliderMax: Double = 150000

    @Binding var sliderValue: Double

    var body: some View {
        VStack( alignment: .leading, spacing: 0) {
            Text("\(title): \(Int(sliderValue))\(valueSuffix)")
                .font(.custom("Oswald-Medium", size: 20))
                .foregroundColor(Color(uiColor: UIColor(named: "Secondary")!))

            Text(description)
                .font(.custom("OpenSans-Light", size: 16))
                .foregroundColor(Color(uiColor: UIColor(named: "Primary1")!))
            
            Slider(value: $sliderValue, in: sliderMin...sliderMax)
                .accentColor(Color(uiColor: UIColor(named: "Secondary")!)) // Set the slider color
                .colorMultiply(Color(uiColor: UIColor(named: "Primary1")!))
                .padding(.horizontal, 20)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(uiColor: UIColor(named: "Primary1")!).opacity(0.5)) // Set the background color
                        .frame(height: 10)
                )
                .padding(.bottom, 8)
        
            // You can customize the appearance further as needed
        }
        .padding()
    }
}

struct StylizedCheckmarkView: View {
    let title : String
    let description : String
    @Binding var isChecked: Bool

    var body: some View {
        
        HStack {
            
            VStack {
                Text(title)
                    .font(.custom("Oswald-Medium", size: 20))
                    .foregroundColor(Color(uiColor: UIColor(named: "Secondary")!))

                Text(description)
                    .font(.custom("OpenSans-Light", size: 16))
                    .foregroundColor(Color(uiColor: UIColor(named: "Primary1")!))
            }
            
            Spacer()
            
            Button(action: {
                isChecked.toggle()
                RootView.sVibrate()

            }) {
                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(Color(uiColor: UIColor(named: isChecked ? "Secondary" : "Primary1")!))
            }
            
        }
        .padding()
    }
}
struct HorizontalScrollableStackView: View {
    
    let title : String
    let description : String
    
    let items: [String]
    
    @Binding var selected: Int

    var body: some View {
        
        VStack( alignment: .leading, spacing: 0) {

            Text(title)
                .font(.custom("Oswald-Medium", size: 20))
                .foregroundColor(Color(uiColor: UIColor(named: "Secondary")!))

            Text(description)
                .font(.custom("OpenSans-Light", size: 16))
                .foregroundColor(Color(uiColor: UIColor(named: "Primary1")!))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(items, id: \.self) { item in
                        Text(item)
                            .font(.headline)
                            .padding()
                            .background(Color(uiColor: UIColor(named: selected == items.index(of: item)!.magnitude ? "Secondary" : "Primary1")!))
                            .foregroundColor(selected == items.index(of: item)!.magnitude ? .white : .black)
                            .cornerRadius(10)
                            .onTapGesture {
                                withAnimation {
                                    selected = Int(items.index(of: item)!.magnitude)
                                    RootView.sVibrate()
                                }
                            }
                    }
                }
            }
            .padding(.top, 8)
        }
        .padding()

    }
}
