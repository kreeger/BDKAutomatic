//
//  NLAppDelegate.m
//  NLAutomatic
//
//  Created by Ben Kreeger on 1/20/14.
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

#import "NLAppDelegate.h"
#import "NLAuthViewController.h"
#import "NLTableViewController.h"

#import <NLAutomatic/NLAutomatic.h>

@interface NLAppDelegate ()

- (void)setupAutomaticAPI;

@end

@implementation NLAppDelegate

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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"NLAutomaticSecrets" ofType:@"plist"];
    NSAssert(path, @"You must copy NLAutomaticSecrets.plist.example to NLAutomaticSecrets.plist and fill out your\
             information.");
    
    NSDictionary *secrets = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *clientId = secrets[@"NLAutomaticClientId"];
    NSAssert(clientId, @"Must fill in Automatic API Client ID in NLAutomaticSecrets.plist.");
    NSString *clientSecret = secrets[@"NLAutomaticClientSecret"];
    NSAssert(clientSecret, @"Must fill in Automatic API Client Secret in NLAutomaticSecrets.plist.");
    NSString *redirectUrlString = secrets[@"NLAutomaticRedirectUrl"];
    NSAssert(redirectUrlString, @"Must fill in Automatic API Redirect URL in NLAutomaticSecrets.plist.");
    
    NSURL *redirectUrl = [NSURL URLWithString:redirectUrlString];
    _automatic = [[NLAutomatic alloc] initWithClientId:clientId clientSecret:clientSecret redirectUrl:redirectUrl];
    
    NSData *tokenData = [[NSUserDefaults standardUserDefaults] objectForKey:@"NLAutomaticToken"];
    if (tokenData) {
        NLAutomaticToken *token = [NSKeyedUnarchiver unarchiveObjectWithData:tokenData];
        _automatic.token = token;
    }
}

- (void)showAuthenticatedFlow {
    NLTableViewController *tableVC = [NLTableViewController viewControllerWithAutomaticAdapter:self.automatic];
    tableVC.userDidLogout = ^{
        self.automatic.token = nil;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"NLAutomaticToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self showUnauthenticatedFlow];
    };
    UINavigationController *tableNav = [[UINavigationController alloc] initWithRootViewController:tableVC];
    self.window.rootViewController = tableNav;
}

- (void)showUnauthenticatedFlow {
    NLAuthViewController *authVC = [NLAuthViewController viewControllerWithAutomaticAdapter:self.automatic];
    authVC.userAuthenticated = ^(NLAutomaticToken *token) {
        // Save it to defaults; in your real app, PLEASE save this data to Keychain instead.
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:token];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"NLAutomaticToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self showAuthenticatedFlow];
    };
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:authVC];
    self.window.rootViewController = nav;
}

@end
