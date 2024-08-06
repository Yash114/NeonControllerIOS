#import <UIKit/UIKit.h>

@interface RoundedRect : UIView

@end

@implementation RoundedRect {
    UIColor* backgroundColor;
    int radius;
}



- (id) init:(CGRect)frame radius:(int) radius backgroundColor:(UIColor*) backgroundColor {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = backgroundColor;
        self.layer.cornerRadius = radius;
        self.layer.masksToBounds = YES; // Ensure the corner radius is visible
        
        // Other custom initialization if needed
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Get the current graphics context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Create a rounded rectangle path
    UIBezierPath *roundedRectPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                           cornerRadius: self->radius];
    
    // Set the fill color
    [self.backgroundColor setFill];
    
    // Fill the rounded rectangle
    [roundedRectPath fill];
    
    // Optional: Stroke the path if you want an outline
    // [[UIColor blackColor] setStroke];
    // [roundedRectPath stroke];
}

@end
