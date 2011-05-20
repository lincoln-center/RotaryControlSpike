//
//  RotaryControl.m
//  RotaryCustomControl
//
//  Created by Sam Coward on 5/19/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "RotaryControl.h"
#import <QuartzCore/QuartzCore.h>

CGFloat const ROTARY_SIZE = 220.f;

@interface RotaryControl()

-(CGFloat)calculateRotationDeltaFrom:(CGPoint)fromLocation to:(CGPoint)toLocation;

@end

@implementation RotaryControl

@synthesize trackedTouchLocation, trackedTouchPtrValue, rotatingLayer;

- (void)dealloc
{
    self.trackedTouchPtrValue = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];

        self.rotatingLayer = [CALayer layer];
        //self.rotatingLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
        self.rotatingLayer.bounds = CGRectMake(0.f, 0.f, ROTARY_SIZE, ROTARY_SIZE);
        self.rotatingLayer.anchorPoint = CGPointMake(0.5f, 0.5f);

        [[self layer] addSublayer: self.rotatingLayer];
        self.rotatingLayer.position = CGPointMake(self.layer.frame.size.width/2.f, self.layer.frame.size.height/2.f);

        CALayer * dataPointsLayer = [CALayer layer];
        dataPointsLayer.delegate = self;
        dataPointsLayer.bounds = CGRectMake(0.f, 0.f, ROTARY_SIZE, ROTARY_SIZE);
        dataPointsLayer.anchorPoint = CGPointMake(0.5f, 0.5f);

        [[self layer] addSublayer:dataPointsLayer];
        dataPointsLayer.position = CGPointMake(ROTARY_SIZE/2.f, ROTARY_SIZE/2.f);

        [dataPointsLayer setNeedsDisplay];
    }
    return self;
}

#pragma mark - Drawing data points
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
//    CGMutablePathRef path = CGPathCreateMutable();
//    
//    CGFloat height = (rand()%100) + 20.f;
//    CGPoint points[4] = {{110.f, 110.f}, {110.f, 110.f+height}, {111.f, 110.f+height}, {111.f, 110.f}};
//    CGPathAddLines(path, NULL, points, 4);
//    
//    
////    CGPathAddCurveToPoint(thePath,
////                          NULL,
////                          15.f,250.0f,
////                          295.0f,250.0f,
////                          295.0f,15.0f);
//    
//    CGContextBeginPath(ctx);
//    CGContextAddPath(ctx, path);
//    
//    CGContextSetLineWidth(ctx, [[layer valueForKey:@"lineWidth"] floatValue]);
//    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
//    CGContextStrokePath(ctx);
//
//    // release the path
//    CFRelease(path);
    
    
    CGMutablePathRef thePath = CGPathCreateMutable();
    
    CGPathMoveToPoint(thePath,NULL,15.0f,15.f);
    CGPathAddCurveToPoint(thePath,
                          NULL,
                          15.f,250.0f,
                          295.0f,250.0f,
                          295.0f,15.0f);
    
    CGContextBeginPath(ctx);
    CGContextAddPath(ctx, thePath );
    
    CGContextSetLineWidth(ctx,
                          [[layer valueForKey:@"lineWidth"] floatValue]);
    CGContextStrokePath(ctx);
    
    // release the path
    CFRelease(thePath);
    
    
//    CAShapeLayer * dataPoint = [CAShapeLayer layer];
//    dataPoint.anchorPoint = CGPointMake(0.5f, 1.f);
//    CGMutablePathRef path = CGPathCreateMutable();
//    for (int i=0; i<360; i++) {
//        CGFloat height = (rand()%100) + 20.f;
//        CGPoint points[4] = {{0.f, 0.f}, {0.f, height}, {1.f, height}, {1.f, 0.f}};
//        
//        
//        if (i%3 == 0) {
//            dataPoint.strokeColor = [UIColor redColor].CGColor;
//        } else if (i%3 == 1) {
//            dataPoint.strokeColor = [UIColor blueColor].CGColor;
//        } else {
//            dataPoint.strokeColor = [UIColor greenColor].CGColor;                
//        }
//        
//        CGPathAddLines(path, &CGAffineTransformIdentity, points, 4);
//        dataPoint.path = path;
//        
//        dataPoint.position = CGPointMake(self.rotatingLayer.frame.size.width/2.f, self.rotatingLayer.frame.size.height/2.f);
//        dataPoint.transform = CATransform3DMakeRotation(i, 0.f, 0.f, 0.1f);
//        
//        
//    }
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
                
                CGFloat angleDelta = [self calculateRotationDeltaFrom:self.trackedTouchLocation to:newLocation];
                if (angleDelta != 0.f) {
                    [CATransaction setAnimationDuration:0.f];
                    self.rotatingLayer.transform = CATransform3DRotate(self.rotatingLayer.transform, angleDelta, 0.f, 0.f, 1.0f);

                }
                
                if (!CGPointEqualToPoint(newLocation, CGPointZero)) {
                    self.trackedTouchLocation = newLocation;                    
                }
            }
        }
    }
}

#pragma mark - Private
-(CGFloat)calculateRotationDeltaFrom:(CGPoint)fromLocation to:(CGPoint)toLocation
{
    CGFloat angle = 0.0f;
    CGFloat x1 = fromLocation.x - 160.f;
    CGFloat y1 = fromLocation.y - 160.f;
    CGFloat x2 = toLocation.x - 160.f;
    CGFloat y2 = toLocation.y - 160.f;
    
    
    if ((x1 != 0.f || y1 != 0.f) && (x2 != 0.f || y2 != 0.f)) {
        CGFloat l1 = sqrtf(x1*x1 + y1*y1);
        CGFloat l2 = sqrtf(x2*x2 + y2*y2);
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
