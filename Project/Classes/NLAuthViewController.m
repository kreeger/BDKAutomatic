//
//  NLAuthViewController.m
//  NLAutomatic
//
//  Created by Ben Kreeger on 2/2/14.
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

#import "NLAuthViewController.h"

#import <NLAutomatic/NLAutomatic.h>

@interface NLAuthViewController () <UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (weak, nonatomic) NLAutomatic *automatic;

- (void)handleAutomaticAuthenticationQueryString:(NSString *)queryString;

@end

@implementation NLAuthViewController

+ (instancetype)viewControllerWithAutomaticAdapter:(NLAutomatic *)adapter {
    id instance = [self new];
    [instance setAutomatic:adapter];
    return instance;
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Login to Automatic";
    NSURLRequest *request = [self.automatic authenticationRequestForStandardScopes];
    [self.webView loadRequest:request];
}

#pragma mark - Properties

- (UIWebView *)webView {
    if (_webView) return _webView;
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _webView.delegate = self;
    return _webView;
}

#pragma mark - Private methods

- (void)handleAutomaticAuthenticationQueryString:(NSString *)queryString {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [[queryString componentsSeparatedByString:@"&"] enumerateObjectsUsingBlock:^(NSString *segment, NSUInteger idx, BOOL *stop) {
        NSArray *components = [segment componentsSeparatedByString:@"="];
        NSString *key = [components[0] stringByRemovingPercentEncoding];
        NSString *value = [components[1] stringByRemovingPercentEncoding];
        params[key] = value ?: [NSNull null];
    }];
    
    [self.automatic getAccessTokenForCode:params[@"code"] completion:^(NSError *error, NLAutomaticToken *token) {
        if (self.userAuthenticated) {
            self.userAuthenticated(token);
        }
    }];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView
    shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    if ([[[request URL] absoluteString] hasPrefix:[self.automatic.redirectUrl absoluteString]]) {
        NSString *queryString = [[[[request URL] absoluteString] componentsSeparatedByString:@"?"] lastObject];
        [self handleAutomaticAuthenticationQueryString:queryString];
        return NO;
    }
    return YES;
}

@end
