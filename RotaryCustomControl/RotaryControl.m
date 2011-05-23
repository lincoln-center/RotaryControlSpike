//
//  RotaryControl.m
//  RotaryCustomControl
//
//  Created by Sam Coward on 5/19/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "RotaryControl.h"
#import "RotaryControlRenderer.h"
#import <QuartzCore/QuartzCore.h>

@interface RotaryControl()

-(CGFloat)calculateRotationDeltaForDragFrom:(CGPoint)fromLocation to:(CGPoint)toLocation;

@end

@implementation RotaryControl

@synthesize trackedTouchLocation, controlRenderer, trackedTouchPtrValue, rotatingLayer;

- (void)dealloc
{
    self.controlRenderer = nil;
    self.trackedTouchPtrValue = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];
        halfWidth = self.layer.bounds.size.width / 2.f;
        halfHeight = self.layer.bounds.size.height / 2.f;
        self.controlRenderer = [RotaryControlRenderer rendererWithWidth:self.layer.bounds.size.width andHeight:self.layer.bounds.size.height];

        self.rotatingLayer = [CALayer layer];
        self.rotatingLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
        self.rotatingLayer.bounds = CGRectMake(0.f, 0.f, self.layer.bounds.size.width, self.layer.bounds.size.height);
        [[self layer] addSublayer:self.rotatingLayer];
        self.rotatingLayer.position = CGPointMake(halfWidth, halfHeight);

        self.rotatingLayer.delegate = self.controlRenderer;
        [[self rotatingLayer] setNeedsDisplay];
    }
    return self;
}

#pragma mark - Touch handling
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch * touch in touches) {
        if (touch.phase == UITouchPhaseBegan && nil == self.trackedTouchPtrValue) {
            self.trackedTouchPtrValue = [NSValue valueWithPointer:touch];
            self.trackedTouchLocation = [touch locationInView:self];
            NSLog(@"Tracking touch at %0.2f, %0.2f", self.trackedTouchLocation.x, self.trackedTouchLocation.y);
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (nil != self.trackedTouchPtrValue) {
        for (UITouch * touch in touches) {
            if (touch.phase == UITouchPhaseCancelled && [self.trackedTouchPtrValue isEqualToValue:[NSValue valueWithPointer:touch]]) {
                NSLog(@"=> Cancelled tracked touch");
                self.trackedTouchPtrValue = nil;
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (nil != self.trackedTouchPtrValue) {
        for (UITouch * touch in touches) {
            if (touch.phase == UITouchPhaseEnded && [self.trackedTouchPtrValue isEqualToValue:[NSValue valueWithPointer:touch]]) {
                NSLog(@"=> Ended tracked touch");
                self.trackedTouchPtrValue = nil;
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (nil != self.trackedTouchPtrValue) {
        for (UITouch * touch in touches) {
            if (touch.phase == UITouchPhaseMoved && [self.trackedTouchPtrValue isEqualToValue:[NSValue valueWithPointer:touch]]) {
                CGPoint newLocation = [touch locationInView:self];
                
                CGFloat angleDelta = [self calculateRotationDeltaForDragFrom:self.trackedTouchLocation to:newLocation];
                if (angleDelta != 0.f) {
                    [CATransaction setAnimationDuration:0.f];
                    self.rotatingLayer.transform = CATransform3DRotate(self.rotatingLayer.transform, angleDelta, 0.f, 0.f, 1.0f);
                    [self.rotatingLayer setNeedsDisplay];
                }
                
                if (!CGPointEqualToPoint(newLocation, CGPointZero)) {
                    self.trackedTouchLocation = newLocation;                    
                }
            }
        }
    }
}

#pragma mark - Private
-(CGFloat)calculateRotationDeltaForDragFrom:(CGPoint)fromLocation to:(CGPoint)toLocation
{
    CGFloat angle = 0.0f;
    CGFloat x1 = fromLocation.x - halfWidth;
    CGFloat y1 = fromLocation.y - halfHeight;
    CGFloat x2 = toLocation.x - halfWidth;
    CGFloat y2 = toLocation.y - halfHeight;
    CGFloat l1 = sqrtf(x1*x1 + y1*y1);
    CGFloat l2 = sqrtf(x2*x2 + y2*y2);    
    if (l1 != 0.f && l2 != 0.f) {
        CGFloat dx = x2 - x1;
        CGFloat dy = y2 - y1;
        CGFloat direction = 1.0f;
        
        if (fabsf(dy) > fabsf(dx)) {
            if (dy < 0.f && x1 >= 0.f) {
                direction = -1.0f;
            } else if (dy >= 0.f && x1 < 0.f) {
                direction = -1.0f;
            }
        } else {
            if (dx < 0.f && y1 < 0.f) {
                direction = -1.0f;
            } else if (dx >= 0.f && y1 >= 0.f) {
                direction = -1.0f;
            }
        }
        
        angle = direction * acosf((x1 * x2 + y1 * y2) / (l1 * l2));
    }

    return angle;
}

@end
