//
//  NLMapViewController.m
//  NLAutomatic
//
//  Created by Ben Kreeger on 2/4/14.
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

#import "NLMapViewController.h"

@import MapKit;

#import <NLAutomatic/NLAutomaticTrip.h>
#import <NLAutomatic/MKPolyline+NLEncodedString.h>

@interface NLMapViewController () <MKMapViewDelegate>

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) MKPolyline *mapPath;
@property (strong, nonatomic) UISegmentedControl *segmentedControl;

- (void)segmentedControlChanged:(UISegmentedControl *)sender;

@end

@implementation NLMapViewController

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mapView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.mapView addOverlay:self.mapPath level:MKOverlayLevelAboveRoads];
    
    self.navigationController.toolbarHidden = NO;
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                          target:nil action:nil];
    self.toolbarItems = @[flex, [[UIBarButtonItem alloc] initWithCustomView:self.segmentedControl], flex];
    
    UIEdgeInsets mapPadding = UIEdgeInsetsMake(100, 100, 100, 100);
    [self.mapView setVisibleMapRect:[self.mapPath boundingMapRect] edgePadding:mapPadding animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
    _mapView.mapType = MKMapTypeHybrid;
    return _mapView;
}

- (UISegmentedControl *)segmentedControl {
    if (_segmentedControl) return _segmentedControl;
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Standard", @"Hybrid", @"Satellite"]];
    [_segmentedControl addTarget:self
                          action:@selector(segmentedControlChanged:)
                forControlEvents:UIControlEventValueChanged];
    
    [self.segmentedControl setSelectedSegmentIndex:1];
    return _segmentedControl;
}

- (void)setTrip:(NLAutomaticTrip *)trip {
    self.title = [NSString stringWithFormat:@"%@", trip.identifier];
    self.mapPath = [MKPolyline polylineWithEncodedString:trip.path];
}

#pragma mark - Private methods

- (void)segmentedControlChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.mapView.mapType = MKMapTypeStandard;
    } else if (sender.selectedSegmentIndex == 1) {
        self.mapView.mapType = MKMapTypeHybrid;
    } else if (sender.selectedSegmentIndex == 2) {
        self.mapView.mapType = MKMapTypeSatellite;
    }
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
