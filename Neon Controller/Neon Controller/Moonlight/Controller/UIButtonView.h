//
//  UIComputerView.h
//  Neon Controller
//
//  Created by Yashua Evans on 10/30/23.
//

#import <UIKit/UIKit.h>
#import "KeyboardSupport.h"
#include <Limelight.h>
#import "ControllerSupport.h"

#import "Neon_Controller-Swift.h"


@interface UIButtonView : UIButton

typedef NS_ENUM(NSInteger, ControlButtonType) {
    NORMAL = 0,
    STICKY = 1,
    CYCLE = 2,
    JOY = 3,
    SCROLL = 4
};

-(id) init;

-(id) initWithControlButton:(ControlButton*) controlButton rect:(CGRect) rect;

- (void)addControllerSupport: (ControllerSupport*) _controllerSupport;

-(void) updateButtonText:(NSString*) text;

@end
