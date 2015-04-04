//
//  NLAppDelegate.h
//  NLAutomatic
//
//  Created by Ben Kreeger on 1/20/14.
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

@import UIKit;

@class NLAutomatic;

@interface NLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly) NLAutomatic *automatic;

@end
