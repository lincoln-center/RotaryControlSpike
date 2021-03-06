//
//  RotaryControlRenderer.m
//  RotaryCustomControl
//
//  Created by Sam Coward on 5/19/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "RotaryControlRenderer.h"


@implementation RotaryControlRenderer

static CGFloat data[720];
static CGFloat costable[720];
static CGFloat sintable[720];

+(RotaryControlRenderer *)rendererWithWidth:(CGFloat)width andHeight:(CGFloat)height {
    return [[[RotaryControlRenderer alloc] initWithWidth:width andHeight:height] autorelease];
}

-(RotaryControlRenderer *)initWithWidth:(CGFloat)width andHeight:(CGFloat)height {
    self = [super init];
    if (self) {
        halfWidth = width/2.f;
        halfHeight = height/2.f;
        for (int i=0; i<360; i++) {
            data[i] = (rand()%100) + 20.f;
            costable[i] = cosf(i * M_PI / 180.f);
            sintable[i] = sinf(i * M_PI / 180.f);
        }
    }
    return self;
}

#pragma mark - Drawing data points
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);

    CGContextSetLineWidth(ctx, 1.0f);
    for (NSInteger i=0; i<360; i+=1) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGFloat dataHeight = data[i];
        CGFloat cosAngle = costable[i];
        CGFloat sinAngle = sintable[i];
        CGPoint points[2] = {{halfWidth, halfHeight}, {halfWidth + (dataHeight * cosAngle), halfHeight + (dataHeight * sinAngle)}};
        CGPathAddLines(path, &CGAffineTransformIdentity, points, 2);

        CGContextBeginPath(ctx);
        CGContextAddPath(ctx, path);
        if (abs(i)%3==0) {
            CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
        } else if (abs(i)%3==1) {
            CGContextSetStrokeColorWithColor(ctx, [UIColor blueColor].CGColor);
        } else {
            CGContextSetStrokeColorWithColor(ctx, [UIColor greenColor].CGColor);
        }
        CGContextStrokePath(ctx);

        CFRelease(path);
    }

    //Center cap
    CGFloat smallCapRadius = halfWidth/2.f;
    CGRect ellipseBox = CGRectMake(halfWidth - (smallCapRadius/2.f), halfHeight - (smallCapRadius/2.f), smallCapRadius, smallCapRadius);
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextFillEllipseInRect(ctx, ellipseBox);
    CGContextSetStrokeColorWithColor(ctx, [UIColor grayColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, ellipseBox);

    //Outer circumference
    CGFloat bigCapRadius = (halfWidth*2.f) - 5.0f;
    CGContextStrokeEllipseInRect(ctx, CGRectMake(halfWidth - (bigCapRadius/2.f), halfHeight - (bigCapRadius/2.f), bigCapRadius, bigCapRadius));

    CGContextRestoreGState(ctx);
}
@end
