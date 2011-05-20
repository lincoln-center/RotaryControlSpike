//
//  RotaryControl.h
//  RotaryCustomControl
//
//  Created by Sam Coward on 5/19/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RotaryControl : UIView {
    CGFloat halfWidth;
    CGFloat halfHeight;
}

@property (nonatomic, assign) CALayer * rotatingLayer;//not retained b/c the parent layer already does

@property (nonatomic, assign) CGPoint trackedTouchLocation;
@property (nonatomic, retain) NSValue * trackedTouchPtrValue;

@end
