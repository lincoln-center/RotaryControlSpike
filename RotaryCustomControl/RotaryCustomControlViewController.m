//
//  RotaryCustomControlViewController.m
//  RotaryCustomControl
//
//  Created by Sam Coward on 5/19/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "RotaryCustomControlViewController.h"
#import "RotaryControl.h"

@implementation RotaryCustomControlViewController

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat yPos = (self.view.frame.size.height - 270.f) / 2.f;
    CGRect rotaryControlFrame = CGRectMake(((self.view.frame.size.width - 270.f) / 2.f), yPos, 270.f, 270.f);
    RotaryControl * rotaryControl = [[[RotaryControl alloc] initWithFrame:rotaryControlFrame] autorelease];
    [[self view] addSubview:rotaryControl];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
