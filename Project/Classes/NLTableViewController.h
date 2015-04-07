//
//  NLTableViewController.h
//  NLAutomatic
//
//  Created by Ben Kreeger on 2/2/14.
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

@import UIKit;

@class NLAutomatic;

@interface NLTableViewController : UIViewController

@property (readonly, weak) NLAutomatic *automatic;
@property (readonly, nonatomic) UITableView *tableView;
@property (copy, nonatomic) void(^userDidLogout)(void);

+ (instancetype)viewControllerWithAutomaticAdapter:(NLAutomatic *)adapter;

@end
