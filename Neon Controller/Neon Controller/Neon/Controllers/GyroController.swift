//
//  GyroController.swift
//  Neon Controller
//
//  Created by Yashua Evans on 11/22/23.
//

import Foundation
import CoreMotion

@objc
class GyroController : NSObject {
    
    var motion : CMMotionManager?
    var timer : Timer?
    
    var numberArray = [NSNumber]()
    
    @objc
    func startGyros(_ callback : @escaping ([Double]) -> ()) {
        
        motion = CMMotionManager()
        
       if motion!.isGyroAvailable {
          self.motion!.gyroUpdateInterval = 1.0 / 50.0
          self.motion!.startGyroUpdates()


          // Configure a timer to fetch the accelerometer data.
          self.timer = Timer(fire: Date(), interval: (1.0/50.0),
                 repeats: true, block: { (timer) in
             // Get the gyro data.
              if let data = self.motion!.gyroData {
                 
                 let x = data.rotationRate.x
                 let y = data.rotationRate.y
                 let z = data.rotationRate.z
                  
                 let rData = [x, y, z];

                callback(rData)
             }
          })


          // Add the timer to the current run loop.
          RunLoop.current.add(self.timer!, forMode: RunLoop.Mode.default)
       }
    }


    @objc
    func stopGyros() {
       if self.timer != nil {
          self.timer?.invalidate()
          self.timer = nil


          self.motion!.stopGyroUpdates()
       }
    }
    
}
