//
//  BDKMapViewController.m
//  BDKAutomatic
//
//  Created by Ben Kreeger on 2/4/14.
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

#import "BDKMapViewController.h"

#import <BDKAutomatic/BDKAutomaticTrip.h>

@interface BDKMapViewController ()

@end

@implementation BDKMapViewController

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Properties

- (void)setTrip:(BDKAutomaticTrip *)trip {
    self.title = [NSString stringWithFormat:@"%@", trip.identifier];
}

@end
