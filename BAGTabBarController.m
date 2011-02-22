/** 
 * BAGTabBarController.m
 * Copyright (c) 2009, Benjamin Guest. 
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without 
 * modification, are permitted provided that the following conditions are met:
 * 
 * -Redistributions of source code must retain the above copyright
 *  notice, this list of conditions and the following disclaimer.
 * -Redistributions in binary form must reproduce the above copyright
 *  notice, this list of conditions and the following disclaimer in the 
 *  documentation and/or other materials provided with the distribution.
 * -Neither the name of Benjamin Guest nor the names of its 
 *  contributors may be used to endorse or promote products derived from 
 *  this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 * POSSIBILITY OF SUCH DAMAGE. 
 */

#import "BAGTabBarController.h"

@implementation BAGTabBarController

@synthesize tabbarHeight;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)theOrientation {
	// Return YES for supported orientations
	return [self.selectedViewController shouldAutorotateToInterfaceOrientation:theOrientation];;
}

/**
 * Sets tab bar to show/hide
 */
- (void)setTabBarHidden:(BOOL)hide{
	
	if ([self.view.subviews count] <2)
		return;
	
	UIView* contentView;
	if ([[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]])
		contentView = [self.view.subviews objectAtIndex:1];
	else 
		contentView = [self.view.subviews objectAtIndex:0];
	
	if (hide){
		contentView.frame = self.view.bounds;
		tabbarHeight = 0;
	}else {
		CGRect newFrame = self.view.bounds;
		tabbarHeight = self.tabBar.frame.size.height;
		newFrame.size.height -= tabbarHeight;
		contentView.frame = newFrame;
	}
	self.tabBar.hidden = hide;	
}

-(void)deviceDidRotate{
	
	UIDeviceOrientation theOrientation = [[UIDevice currentDevice] orientation];
	
	//If shouldn't rotate, don't do anything...
	if (![self.selectedViewController shouldAutorotateToInterfaceOrientation:theOrientation])
		return;

	//Deterimine if should show tabbar
	BOOL showBottomBarInPortrait = YES;
	UIViewController* topViewController = self.selectedViewController;
	
	//Cycle through View Controller stack and see if hidesBottomBarWhen Pushed is pressent.
	if ([topViewController isKindOfClass:[UINavigationController class]])
	{
		NSArray* controllers = [(UINavigationController*)topViewController viewControllers];
		for (UIViewController* aController in controllers)
			if (aController.hidesBottomBarWhenPushed){
				showBottomBarInPortrait = NO;
				break;
			}
	}else 
		showBottomBarInPortrait = ![topViewController hidesBottomBarWhenPushed];
	
	if 	(theOrientation == UIInterfaceOrientationLandscapeLeft ||
		 theOrientation == UIInterfaceOrientationLandscapeRight)
		[self setTabBarHidden:YES];
	else if (showBottomBarInPortrait &&
			 (theOrientation == UIInterfaceOrientationPortrait ||
			  theOrientation == UIInterfaceOrientationPortraitUpsideDown))
		[self setTabBarHidden:NO];
}

#pragma mark -
#pragma mark Life Cycle
//-----------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//Orientation Notification
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(deviceDidRotate) 
												 name:UIDeviceOrientationDidChangeNotification 
											   object:[UIDevice currentDevice]];
}

- (void)viewDidUnload {
	[[NSNotificationCenter defaultCenter] removeObserver:self];	
}

@end
