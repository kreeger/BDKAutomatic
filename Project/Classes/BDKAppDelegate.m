//
//  BDKAppDelegate.m
//  BDKAutomatic
//
//  Created by Ben Kreeger on 1/20/14.
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

#import "BDKAppDelegate.h"
#import "BDKAuthViewController.h"
#import "BDKTableViewController.h"

#import <BDKAutomatic/BDKAutomatic.h>

@interface BDKAppDelegate ()

- (void)setupAutomaticAPI;

@end

@implementation BDKAppDelegate

@synthesize automatic = _automatic;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self setupAutomaticAPI];
    
    self.automatic.token ? [self showAuthenticatedFlow] : [self showUnauthenticatedFlow];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setupAutomaticAPI {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"BDKAutomaticSecrets" ofType:@"plist"];
    NSAssert(path, @"You must copy BDKAutomaticSecrets.plist.example to BDKAutomaticSecrets.plist and fill out your\
             information.");
    
    NSDictionary *secrets = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *clientId = secrets[@"BDKAutomaticClientId"];
    NSAssert(clientId, @"Must fill in Automatic API Client ID in BDKAutomaticSecrets.plist.");
    NSString *clientSecret = secrets[@"BDKAutomaticClientSecret"];
    NSAssert(clientSecret, @"Must fill in Automatic API Client Secret in BDKAutomaticSecrets.plist.");
    NSString *redirectUrlString = secrets[@"BDKAutomaticRedirectUrl"];
    NSAssert(redirectUrlString, @"Must fill in Automatic API Redirect URL in BDKAutomaticSecrets.plist.");
    
    NSURL *redirectUrl = [NSURL URLWithString:redirectUrlString];
    _automatic = [[BDKAutomatic alloc] initWithClientId:clientId clientSecret:clientSecret redirectUrl:redirectUrl];
    
    NSData *tokenData = [[NSUserDefaults standardUserDefaults] objectForKey:@"BDKAutomaticToken"];
    if (tokenData) {
        BDKAutomaticToken *token = [NSKeyedUnarchiver unarchiveObjectWithData:tokenData];
        _automatic.token = token;
    }
}

- (void)showAuthenticatedFlow {
    BDKTableViewController *tableVC = [BDKTableViewController viewControllerWithAutomaticAdapter:self.automatic];
    tableVC.userDidLogout = ^{
        self.automatic.token = nil;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"BDKAutomaticToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self showUnauthenticatedFlow];
    };
    UINavigationController *tableNav = [[UINavigationController alloc] initWithRootViewController:tableVC];
    self.window.rootViewController = tableNav;
}

- (void)showUnauthenticatedFlow {
    BDKAuthViewController *authVC = [BDKAuthViewController viewControllerWithAutomaticAdapter:self.automatic];
    authVC.userAuthenticated = ^(BDKAutomaticToken *token) {
        // Save it to defaults; in your real app, PLEASE save this data to Keychain instead.
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:token];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"BDKAutomaticToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self showAuthenticatedFlow];
    };
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:authVC];
    self.window.rootViewController = nav;
}

@end
