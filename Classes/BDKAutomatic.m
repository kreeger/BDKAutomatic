//
//  BDKAutomatic.m
//  BDKAutomatic
//
//  Created by Ben Kreeger on 1/20/14.
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

#import "BDKAutomatic.h"

#import "BDKAutomaticTrip.h"

@implementation BDKAutomatic

@synthesize clientId = _clientId;
@synthesize clientSecret = _clientSecret;
@synthesize redirectUrl = _redirectUrl;

#pragma mark - Lifecycle

- (instancetype)initWithClientId:(NSString *)clientId
                    clientSecret:(NSString *)clientSecret
                     redirectUrl:(NSURL *)redirectUrl {
    return [self initWithClientId:clientId clientSecret:clientSecret redirectUrl:redirectUrl token:nil];
}

- (instancetype)initWithClientId:(NSString *)clientId
                    clientSecret:(NSString *)clientSecret
                     redirectUrl:(NSURL *)redirectUrl
                           token:(BDKAutomaticToken *)token {
    self = [super initWithBaseURL:[NSURL URLWithString:@"https://api.automatic.com"]];
    if (!self) return nil;

    _clientId = clientId;
    _clientSecret = clientSecret;
    _redirectUrl = redirectUrl;
    [self setToken:token];
    
    return self;
}

#pragma mark - Properties

- (void)setToken:(BDKAutomaticToken *)token {
    _token = token;
    NSString *value = token ? [NSString stringWithFormat:@"token %@", token.accessToken] : @"";
    [self.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
}

#pragma mark - Authentication and authorization

- (NSURLRequest *)authenticationRequestForAllScopes {
    NSArray *scopes = @[BDKAutomaticScopeIgnitionOff,
                        BDKAutomaticScopeIgnitionOn,
                        BDKAutomaticScopeLocation,
                        BDKAutomaticScopeMILOff,
                        BDKAutomaticScopeMILOn,
                        BDKAutomaticScopeNotificationHardAcceleration,
                        BDKAutomaticScopeNotificationHardBrake,
                        BDKAutomaticScopeNotificationSpeeding,
                        BDKAutomaticScopeParkingChanged,
                        BDKAutomaticScopeRegionChanged,
                        BDKAutomaticScopeTripSummary,
                        BDKAutomaticScopeVehicle,
                        ];
    return [self authenticationRequestForScopes:scopes];
}

- (NSURLRequest *)authenticationRequestForScopes:(NSArray *)scopes {
    NSDictionary *params = @{@"client_id": self.clientId,
                             @"scope": [scopes componentsJoinedByString:@" "],
                             @"response_type": @"code"};
    NSMutableArray *components = [NSMutableArray array];
    [params enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        key = [key urlEncodeUsingEncoding:NSUTF8StringEncoding];
        value = [value urlEncodeUsingEncoding:NSUTF8StringEncoding];
        [components addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
    }];
    NSString *joinedParams = [components componentsJoinedByString:@"&"];
    NSString *baseURL = @"https://www.automatic.com/oauth/authorize";
    NSString *fullUrl = [NSString stringWithFormat:@"%@?%@", baseURL, joinedParams];
    NSLog(@"Generated URL %@", fullUrl);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fullUrl]];
    return request;
}

- (void)getAccessTokenForCode:(NSString *)code completion:(BDKAutomaticTokenCompletionBlock)completion {
    NSString *url = @"https://www.automatic.com/oauth/access_token";
    NSDictionary *params = @{@"client_id": self.clientId,
                             @"client_secret": self.clientSecret,
                             @"code": code,
                             @"grant_type": @"authorization_code"};
    [self POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.token = [BDKAutomaticToken tokenWithDictionary:responseObject];
        if (completion) {
            completion(nil, self.token);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(error, nil);
        }
    }];
}

#pragma mark - Trip data

- (void)getTrips:(BDKAutomaticCompletionBlock)completion {
    NSString *url = @"/v1/trips";
    NSDictionary *params = @{};
    [self GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *mResults = [NSMutableArray array];
        [responseObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [mResults addObject:[[BDKAutomaticTrip alloc] initWithAPIObject:obj]];
        }];
        if (completion) {
            completion(nil, [mResults copy]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(error, operation.responseObject);
        }
    }];
}

@end


@implementation NSString (URLEncoding)

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
    CFStringRef toEncode = (CFStringRef)@"!*'\"();@&=$,/?%#[]% ";
    CFStringEncoding cEncoding = CFStringConvertNSStringEncodingToEncoding(encoding);
    CFStringRef stringRef = CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, toEncode, cEncoding);
	return (NSString *)CFBridgingRelease(stringRef);
}

@end