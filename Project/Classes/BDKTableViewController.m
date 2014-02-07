//
//  BDKTableViewController.m
//  BDKAutomatic
//
//  Created by Ben Kreeger on 2/2/14.
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

#import "BDKTableViewController.h"

#import "BDKMapViewController.h"

#import <BDKAutomatic/BDKAutomatic.h>
#import <BDKAutomatic/BDKAutomaticTrip.h>

@interface BDKTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (weak, nonatomic) BDKAutomatic *automatic;

@property (strong, nonatomic) NSDictionary *tripDict;
@property (strong, nonatomic) NSArray *sectionKeys;

- (void)tableViewDidPullToRefresh:(UIRefreshControl *)control;
- (void)logoutButtonTapped:(UIBarButtonItem *)sender;

@end

@implementation BDKTableViewController

#pragma mark - Lifecycle

+ (instancetype)viewControllerWithAutomaticAdapter:(BDKAutomatic *)adapter {
    id instance = [self new];
    [instance setAutomatic:adapter];
    return instance;
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tripDict = [NSDictionary dictionary];
    self.title = @"Trips";
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(tableViewDidPullToRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(logoutButtonTapped:)];
    self.navigationItem.leftBarButtonItem = logoutButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.refreshControl beginRefreshing];
    [self tableViewDidPullToRefresh:self.refreshControl];
}

#pragma mark - Properties

- (UITableView *)tableView {
    if (_tableView) return _tableView;
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    // Not so fast; we're using subtitle-styled cells
    // [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    return _tableView;
}

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter) return _dateFormatter;
    _dateFormatter = [NSDateFormatter new];
    [_dateFormatter setDateFormat:@"h:mm:ss a"];
    return _dateFormatter;
}

#pragma mark - Private methods

- (void)tableViewDidPullToRefresh:(UIRefreshControl *)control {
    [self.automatic getTrips:^(NSError *error, id responseObject) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:responseObject[@"message"]
                                        message:responseObject[@"documentation_url"]
                                       delegate:nil
                              cancelButtonTitle:@"Close"
                              otherButtonTitles:nil, nil] show];
            NSLog(@"Error! %@", responseObject);
            [control endRefreshing];
            return;
        }
        
        NSMutableDictionary *mTrips = [NSMutableDictionary dictionary];
        NSMutableSet *orderedKeys = [NSMutableSet set];
        NSDateFormatter *sectionDF = [NSDateFormatter new];
        [sectionDF setDateFormat:@"yyyy-MM-dd"];
        NSDateFormatter *titleDF = [NSDateFormatter new];
        [titleDF setDateFormat:@"MMMM d, yyyy"];
        [responseObject enumerateObjectsUsingBlock:^(BDKAutomaticTrip *trip, NSUInteger idx, BOOL *stop) {
            NSString *sectionString = [sectionDF stringFromDate:trip.startTime];
            [orderedKeys addObject:sectionString];
            if (mTrips[sectionString]) {
                [mTrips[sectionString][@"trips"] addObject:trip];
            } else {
                mTrips[sectionString] = @{@"title": [titleDF stringFromDate:trip.startTime],
                                          @"trips": [NSMutableArray arrayWithObject:trip]};
            }
        }];
        
        NSArray *ordered = [[orderedKeys allObjects] sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
        self.sectionKeys = [[ordered reverseObjectEnumerator] allObjects];
        self.tripDict = [mTrips copy];
        [control endRefreshing];
        
        [self.tableView reloadData];
    }];
}

- (void)logoutButtonTapped:(UIBarButtonItem *)sender {
    if (self.userDidLogout) {
        self.userDidLogout();
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sectionKeys count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *key = self.sectionKeys[section];
    return self.tripDict[key][@"title"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *title = self.sectionKeys[section];
    return [self.tripDict[title][@"trips"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    NSString *title = self.sectionKeys[indexPath.section];
    BDKAutomaticTrip *trip = self.tripDict[title][@"trips"][indexPath.row];
    cell.textLabel.text = [self.dateFormatter stringFromDate:trip.startTime];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f km", [trip.distanceInMeters floatValue] / 1000];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BDKMapViewController *mapVC = [BDKMapViewController new];
    NSString *title = self.sectionKeys[indexPath.section];
    mapVC.trip = self.tripDict[title][@"trips"][indexPath.row];
    [self.navigationController pushViewController:mapVC animated:YES];
}

@end
