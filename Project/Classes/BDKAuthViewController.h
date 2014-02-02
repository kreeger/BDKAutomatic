//
//  BDKAuthViewController.h
//  BDKAutomatic
//
//  Created by Ben Kreeger on 2/2/14.
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

@import UIKit;

@class BDKAutomatic, BDKAutomaticToken;

@interface BDKAuthViewController : UIViewController

@property (readonly, nonatomic) BDKAutomatic *automatic;
@property (copy, nonatomic) void (^userAuthenticated)(BDKAutomaticToken *token);

+ (instancetype)viewControllerWithAutomaticAdapter:(BDKAutomatic *)adapter;

@end
