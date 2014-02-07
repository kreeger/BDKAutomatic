//
//  BDKMapViewController.m
//  BDKAutomatic
//
//  Created by Ben Kreeger on 2/4/14.
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

#import "BDKMapViewController.h"

@import MapKit;

#import <BDKAutomatic/BDKAutomaticTrip.h>
#import <BDKAutomatic/MKPolyline+BDKEncodedString.h>

@interface BDKMapViewController () <MKMapViewDelegate>

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) MKPolyline *mapPath;

@end

@implementation BDKMapViewController

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mapView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.mapView addOverlay:self.mapPath level:MKOverlayLevelAboveRoads];
    NSLog(@"mapView=%p, overlay count = %d", self.mapView, self.mapView.overlays.count);
    [self.mapView setVisibleMapRect:[self.mapPath boundingMapRect]
                        edgePadding:UIEdgeInsetsMake(100, 100, 100, 100)
                           animated:YES];
}

- (void)dealloc {
    self.mapView.delegate = nil;
}

#pragma mark - Properties

- (MKMapView *)mapView {
    if (_mapView) return _mapView;
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _mapView.delegate = self;
    return _mapView;
}

- (void)setTrip:(BDKAutomaticTrip *)trip {
    self.title = [NSString stringWithFormat:@"%@", trip.identifier];
    self.mapPath = [MKPolyline polylineWithEncodedString:trip.path];
}

#pragma mark - MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        renderer.lineWidth = 3.0;
        renderer.strokeColor = [UIColor blueColor];
        return renderer;
    } else {
        return nil;
    }
}

@end
