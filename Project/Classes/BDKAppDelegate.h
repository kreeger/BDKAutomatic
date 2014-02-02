//
//  BDKAppDelegate.h
//  BDKAutomatic
//
//  Created by Ben Kreeger on 1/20/14.
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

@import UIKit;

@class BDKAutomatic;

@interface BDKAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly) BDKAutomatic *automatic;

@end
