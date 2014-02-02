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
    
    BDKAuthViewController *authVC = [BDKAuthViewController viewControllerWithAutomaticAdapter:self.automatic];
    authVC.userAuthenticated = ^(BDKAutomaticToken *token) {
        BDKTableViewController *tableVC = [BDKTableViewController viewControllerWithAutomaticAdapter:self.automatic];
        UINavigationController *tableNav = [[UINavigationController alloc] initWithRootViewController:tableVC];
        self.window.rootViewController = tableNav;
    };
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:authVC];
    self.window.rootViewController = nav;
    
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
    // TODO: Also load in stored token object if available
}

@end
