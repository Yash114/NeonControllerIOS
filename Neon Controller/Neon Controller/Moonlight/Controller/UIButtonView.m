//
//  UIButtonView.m
//  Neon Controller
//
//  Created by Yashua Evans on 10/30/23.
//

#import "UIButtonView.h"
#import "DataManager.h"


@implementation UIButtonView  {
    
    ControlButton* controlButtonData;
    ControllerSupport* controllerSupport;
    Controller* oscController;
    
    UILabel *buttonTitle;
    UIImageView *buttonImage;
    
    NSMutableArray* keybindList;
    NSMutableArray* keybindPressedSet;
    
    CGPoint originalOnTap;
    
    UIView* streamView;
    
    UIImpactFeedbackGenerator *generator;
    
    int keybindIndex;
    int scrollAmount;
    
    bool didScroll;

    bool pressed;
    
    bool enabledVibration;
    
}

static NSMutableArray *buttonImageList;


// MARK: - Init Div

- (id) initWithControlButton:(ControlButton*) controlButton rect:(CGRect) rect {
    
    self = [self init];
    
    // Create an instance of UIImpactFeedbackGenerator with the desired style
    generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
    // Prepare the generator
    [generator prepare];
    
    TemporarySettings* data = [[[DataManager alloc] init] getSettings];
    enabledVibration = data.enableVibration;
    
    keybindList = [NSMutableArray array];
    keybindPressedSet = [NSMutableArray array];

    if(controlButton == nil) { return self; }
    
    [controlButton updateObjcVars];

    [self createButton: controlButton rect: rect];
    
    controlButtonData = controlButton;
    
    pressed = false;

    return self;
}

- (id) init {
    
    self = [super init];
    
        
    if(buttonImageList == nil) {
        buttonImageList = [[NSMutableArray alloc] init];

        [buttonImageList addObject:@"normalButton"];
        [buttonImageList addObject:@"stickyButton"];
        [buttonImageList addObject:@"cycleButton"];
        [buttonImageList addObject:@"joyButton"];
        [buttonImageList addObject:@"scrollButton"];
    }
    
    return self;
}

- (void)addControllerSupport: (ControllerSupport*) _controllerSupport {
    controllerSupport = _controllerSupport;
    oscController = [controllerSupport getOscController];
}

- (void)createButton: (ControlButton*) controlButton rect:(CGRect) rect {
    
    // Setup main view
    int sizeHalf = controlButton.size / 2;
    
    self.frame = CGRectMake(
                            controlButton.position.width - sizeHalf + rect.size.width / 2,
                            controlButton.position.height - sizeHalf + rect.size.height / 2,
                            controlButton.size,
                            controlButton.size * (controlButton.objcType == 4 ? 0.6 : 1));
    
    // Setup touch controllers
    [self addTarget:self action:@selector(onTouchEvent:) forControlEvents: UIControlEventAllTouchEvents];
    [self addTarget:self action:@selector(onPress:) forControlEvents: UIControlEventTouchDown];
    [self addTarget:self action:@selector(onRelease:) forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
    UIPanGestureRecognizer *onDrag = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onDrag:)];
    [self addGestureRecognizer:onDrag];
    
    // Setup UI views
    CGRect buttonImageFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    UIImage* originalImage = [UIImage imageNamed: [buttonImageList objectAtIndex: controlButton.objcType]];
    
    UIImage *coloredImage = [originalImage imageWithTintColor: [controlButton objcColor] renderingMode:UIImageRenderingModeAutomatic];
    
    buttonImage = [[UIImageView alloc] initWithFrame: buttonImageFrame];
    [buttonImage setImage: coloredImage];
    
    NSLog(@"Button Color: %@", controlButton.objcColor);

    [self addSubview:buttonImage];
    
    [buttonTitle setContentMode:UIViewContentModeScaleAspectFill];
    
    
    UIEdgeInsets padding = UIEdgeInsetsMake(16, 16, 16, 16); // Top, left, bottom, right padding
    CGRect labelFrame = CGRectMake(padding.left, padding.top, self.frame.size.width, self.frame.size.height);
    labelFrame.size.width -= padding.right + padding.left;
    labelFrame.size.height -= padding.bottom + padding.top;

    buttonTitle = [[UILabel alloc] initWithFrame:labelFrame];
    
    [buttonTitle setFont:[UIFont fontWithName:@"Oswald-Medium" size:200.0]]; // Replace 20.0 with your desired font size
    [buttonTitle transform];
    [buttonTitle setTextAlignment: NSTextAlignmentCenter];
    [buttonTitle setTextColor:[UIColor whiteColor]];

    buttonTitle.adjustsFontSizeToFitWidth = true;
    
    [self addSubview: buttonTitle];
    
    
    // Setup keybind cycle
    keybindIndex = 0;
    int prevStartIndex = 0;
    NSString* keybind = controlButton.keybind;
    if([controlButton.keybind containsString: @":"]) {
        for(int i = 0; i < keybind.length; i++) {
            if([keybind characterAtIndex:i] == ':') {
                
                NSRange range = NSMakeRange(prevStartIndex, i - prevStartIndex);
                NSString* subKeybind = [keybind substringWithRange: range];
                prevStartIndex = i + 1;
                
                [keybindList addObject:subKeybind];
                                                
            }
        }
    }
    
    NSRange range = NSMakeRange(prevStartIndex, keybind.length - prevStartIndex);
    NSString* subKeybind = [keybind substringWithRange: range];
    [keybindList addObject:subKeybind];

    // Button keybind title setup
    
    // If the button is scroll or cycle set the first keybind to the title
    if(controlButton.objcType == 2 || controlButton.objcType == 4) {
        [buttonTitle setText: [keybindList objectAtIndex:keybindIndex]];
    } else {
        [buttonTitle setText: [controlButton.visibleTitle uppercaseString]];
    }

}


// MARK: - UI Update Div

- (void)updateButtonText:(NSString*) text {
    
    if(buttonTitle == nil) { return; }
    
    NSString *uppercaseText = [text uppercaseString];

    [buttonTitle setText:uppercaseText];
}

- (void)updateButtonType:(int) type {
    
    if(buttonImage == nil) { return; }
    
    [buttonImage setImage: [UIImage imageNamed: [buttonImageList objectAtIndex: type]]];

}

// MARK: - Send Action
- (void)sendMouseAction: (NSString*) keybind down: (BOOL) down {
    
    if([keybind isEqual: @"click"] || [keybind isEqual: @"left_click"] ) {
        
        LiSendMouseButtonEvent(down ? BUTTON_ACTION_PRESS : BUTTON_ACTION_RELEASE, BUTTON_LEFT);
        
    } else if([keybind isEqual: @"right_click"]) {
        
        LiSendMouseButtonEvent(down ? BUTTON_ACTION_PRESS : BUTTON_ACTION_RELEASE, BUTTON_RIGHT);
        
    } else if([keybind isEqual: @"scrollwheel"]) {
        
        LiSendMouseButtonEvent(down ? BUTTON_ACTION_PRESS : BUTTON_ACTION_RELEASE, BUTTON_RIGHT);
        
    }
}

// MARK: - Interaction Interface Div
- (void)controllerButtonClicked:(nullable NSString*) appliedKeybind clicked: (bool) clicked {
    
    self.alpha = clicked ? 0.41 : 1;
    
    NSString* keybind;
    
    if(appliedKeybind != nil) {
        keybind = appliedKeybind;
    } else {
        keybind = [controlButtonData keybind];
    }
    
    NSInteger buttonType = [controlButtonData objcType];
    
    //if keybind is normal
    if([ButtonHandler getKeycodeType: keybind] == 0) {
         
                
        unichar outputCharacter = [[ButtonHandler getKeycodeKeyboard:keybind buttonType:buttonType] characterAtIndex:0];
        [KeyboardSupport mSendKeyEvent: outputCharacter isDown: clicked];
        
    //if keybind is mouse
    } else if([ButtonHandler getKeycodeType: keybind] == 1) {
        
        [self sendMouseAction:keybind down:clicked];
        
    //if keybind is action
    } else if([ButtonHandler getKeycodeType: keybind] == 2) {
        
        
        [KeyboardSupport mSendKeyEventAction:[ButtonHandler getKeycodeAction: keybind] isDown:clicked];

    //if keybind is controller
    } else if([ButtonHandler getKeycodeType: keybind] == 3) {

        if(controllerSupport != nil) {

            int n = [ButtonHandler getControllerButtonCode:keybind];
            [controllerSupport sendButtonKeycode:oscController buttonKeyCode:n down:clicked];

        }

        
    }
}

// MARK: - Button Function Implentation

- (void)handleTap:(UITapGestureRecognizer *)sender {
    // Handle the tap event here
    // Make sure not to call [super handleTap:sender] or any other method that might propagate the event
}

- (void)onPress:(id) sender {
        
    [self vibrate];

    switch(controlButtonData.objcType) {
            
        // Normal Button
        case 0:
            [self controllerButtonClicked: nil clicked: true];
            
            break;
            
        // Sticky Button
        case 1:
            pressed = !pressed;
            
            [self controllerButtonClicked: nil clicked: pressed];
            
            break;
            
        // Cycle Button
        case 2:
            
            [self controllerButtonClicked: [keybindList objectAtIndex:keybindIndex] clicked: true];

            break;
            
        // Joy Button
        case 3:
            [keybindPressedSet removeAllObjects];
            break;
            
        // Scroll Button
        case 4:
            didScroll = false;

            scrollAmount = 0;
            originalOnTap = CGPointZero;
            
            break;
            
        default:
            NSLog(@"hi");

    }

}

- (void)onTouchEvent:(id) sender {
    //just consume
}

- (void)onRelease:(id) sender {
    
    switch(controlButtonData.objcType) {
            
        // Normal Button
        case 0:
            [self controllerButtonClicked: nil clicked: false];
            
            break;
            
        // Sticky Button
        case 1:
            //Don't do anything
            
            break;
            
        // Cycle Button                                     
        case 2:
            
            [self controllerButtonClicked: [keybindList objectAtIndex:keybindIndex] clicked: false];
            
            keybindIndex += 1;
            keybindIndex = keybindIndex % keybindList.count;
            
            // Update the button title
            [buttonTitle setText: [keybindList objectAtIndex:keybindIndex]];

            NSLog(@"Text: %@", [keybindList objectAtIndex:keybindIndex]);

            
            break;
            
        // Joy Button
        case 3:
            
            for(NSString* keybinds in keybindPressedSet ) {
                [self controllerButtonClicked: keybinds clicked: false];
            }
            
            [keybindPressedSet removeAllObjects];
            
            [buttonTitle setText: [controlButtonData.visibleTitle capitalizedString]];
            
            self.alpha = 1;

            break;

        // Scroll Button
        case 4:
            
            if(!didScroll) {
                [self controllerButtonClicked: [keybindList objectAtIndex:keybindIndex % keybindList.count] clicked: true];
                
                NSTimeInterval delayInSeconds = 0.05;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self controllerButtonClicked: [self->keybindList objectAtIndex:self->keybindIndex % self->keybindList.count] clicked: false];
                });
            }
            
            didScroll = false;

            break;
            
            
        default:
            NSLog(@"hi");

    }
    
    originalOnTap = CGPointZero;
}


- (void)onDrag:(UIPanGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        
        [self onRelease:self];
        
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        // Get the touch point in the coordinate system of the button
        CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view];
        
        if(originalOnTap.x == 0 && originalOnTap.y == 0) {
            originalOnTap = touchPoint;
        }
        
        int xDiff = touchPoint.x - originalOnTap.x;
        int yDiff = touchPoint.y - originalOnTap.y;

        // Joy Button
        if(controlButtonData.objcType == 3) {
            
            double touchMagnitude = sqrt(pow(xDiff, 2) + pow(yDiff, 2));
            if(touchMagnitude > 10) {
                
                // Calculate scroll direction
                double angle = acos(xDiff / sqrt(pow(xDiff, 2) + pow(yDiff, 2)));
                
                if(yDiff < 0) {
                    angle = 2 * M_PI - angle;
                }
                
                NSLog(@"direction: %f", angle);
                
                NSMutableArray* keybindPressedSetTemp = [NSMutableArray array];
            
                
                // Left
                if (angle < 4 * M_PI / 3 && angle > 2 * M_PI / 3) {
                    [keybindPressedSetTemp addObject: [keybindList objectAtIndex:1]];
                }
                
                //Down
                if (angle < 5 * M_PI / 6 && angle > M_PI / 6) {
                    [keybindPressedSetTemp addObject: [keybindList objectAtIndex:2]];
                }
                
                //Right
                if (angle < M_PI / 3 || angle > 5 * M_PI / 3) {
                    [keybindPressedSetTemp addObject: [keybindList objectAtIndex:3]];
                }
                
                //Up
                if (angle < 11 * M_PI / 6 && angle > 7 * M_PI / 6) {
                    [keybindPressedSetTemp addObject: [keybindList objectAtIndex:0]];
                }
                
                
                if(![keybindPressedSetTemp isEqualToArray:keybindPressedSet]) {
                    
                    [self vibrate];
                    
                    for(NSString* keybinds in keybindPressedSet ) {
                        [self controllerButtonClicked: keybinds clicked: false];
                    }
                    
                    [keybindPressedSet removeAllObjects];
                    [keybindPressedSet addObjectsFromArray:keybindPressedSetTemp];
                    
                    NSString* buttonTitleString = @"";
                    
                    for(NSString* keybind in keybindPressedSet ) {
                        [self controllerButtonClicked: keybind clicked: true];
                        
                        buttonTitleString = [buttonTitleString stringByAppendingString: keybind];
                        
                        if(![[keybindPressedSet lastObject] isEqual:keybind]) {
                            buttonTitleString = [buttonTitleString stringByAppendingString: @"&"];
                        }
                    }
                    
                    [buttonTitle setText: [buttonTitleString capitalizedString]];
                    
                }
            } else {
                for(NSString* keybinds in keybindPressedSet ) {
                    [self controllerButtonClicked: keybinds clicked: false];
                }
                
                [keybindPressedSet removeAllObjects];
                [buttonTitle setText: [controlButtonData.keybind capitalizedString]];


            }
            

        }
        
        // Scroll Button
        if(controlButtonData.objcType == 4) {
            
            int scroll = floor(xDiff / 30);
            
            if(scroll != 0) {
                                
                didScroll = true;

                keybindIndex += scroll;
                
                [buttonTitle setText: [keybindList objectAtIndex:keybindIndex % keybindList.count]];
                
                originalOnTap = touchPoint;
                
                [self vibrate];
                
            }
        }
    }
}

- (void) vibrate {
    if (@available(iOS 10.0, *)) {

        // Trigger the haptic feedback
        
        if(enabledVibration) {
            [generator impactOccurred];
        }
    }
}

@end
