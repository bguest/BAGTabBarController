//
//  BAGTabBarController.h
//  iRef-Kickball
//
//  Created by Benjamin Guest on 5/28/10.
//  Copyright 2010 Table 14 Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BAGTabBarController : UITabBarController {
	
	NSInteger tabbarHeight;
}
@property (readonly) NSInteger tabbarHeight;

- (void)setTabBarHidden:(BOOL)hide;

- (void)deviceDidRotate;


@end
