//
//  NLAuthViewController.h
//  NLAutomatic
//
//  Created by Ben Kreeger on 2/2/14.
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

@import UIKit;

@class NLAutomatic, NLAutomaticToken;

@interface NLAuthViewController : UIViewController

@property (readonly, nonatomic, weak) NLAutomatic *automatic;
@property (copy, nonatomic) void (^userAuthenticated)(NLAutomaticToken *token);

+ (instancetype)viewControllerWithAutomaticAdapter:(NLAutomatic *)adapter;

@end
