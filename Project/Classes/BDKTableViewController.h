//
//  BDKTableViewController.h
//  BDKAutomatic
//
//  Created by Ben Kreeger on 2/2/14.
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

@import UIKit;

@class BDKAutomatic;

@interface BDKTableViewController : UIViewController

@property (readonly) BDKAutomatic *automatic;
@property (readonly, nonatomic) UITableView *tableView;
@property (copy, nonatomic) void(^userDidLogout)(void);

+ (instancetype)viewControllerWithAutomaticAdapter:(BDKAutomatic *)adapter;

@end
