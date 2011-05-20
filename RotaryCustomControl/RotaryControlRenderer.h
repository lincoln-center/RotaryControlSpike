#import <Foundation/Foundation.h>


@interface RotaryControlRenderer : NSObject {
    CGFloat halfWidth, halfHeight;
}

+(RotaryControlRenderer *)rendererWithWidth:(CGFloat)width andHeight:(CGFloat)height;
-(RotaryControlRenderer *)initWithWidth:(CGFloat)width andHeight:(CGFloat)height;

@end
