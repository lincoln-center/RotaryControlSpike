//
//  RotaryCustomControlAppDelegate.h
//  RotaryCustomControl
//
//  Created by Sam Coward on 5/19/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RotaryCustomControlViewController;

@interface RotaryCustomControlAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet RotaryCustomControlViewController *viewController;

@end
