//
//  NLAutomatic.m
//  NLAutomatic
//
//  Created by Ben Kreeger on 1/20/14.
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

#import "NLAutomatic.h"

#import "NLAutomaticTrip.h"
#import "NLAutomaticUser.h"
#import "NLAutomaticVehicle.h"
#import "NLAutomaticToken.h"
#import "NLAutomaticOperation.h"
#import "AFHTTPRequestOperation+NLAutomaticOperation.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>

static NSString * const kAutomaticAPIBaseURLString = @"https://api.automatic.com/v1";
static NSString * const kAutomaticAuthBaseURLString = @"https://accounts.automatic.com/oauth";

@interface NLAutomatic ()

@property (nonatomic, strong, readwrite) NSString *clientId;
@property (nonatomic, strong, readwrite) NSString *clientSecret;
@property (nonatomic, strong, readwrite) NSURL *redirectUrl;
@property (nonatomic, strong) AFHTTPRequestOperationManager *operationManager;

@end

@implementation NLAutomatic

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
                           token:(NLAutomaticToken *)token {
    self = [super init];
    if (self)
    {
        _operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kAutomaticAPIBaseURLString]];
        _clientId = clientId;
        _clientSecret = clientSecret;
        _redirectUrl = redirectUrl;
        [self setToken:token];
    }
    
    return self;
}

#pragma mark - Properties

- (void)setToken:(NLAutomaticToken *)token {
    _token = token;
    NSString *value = token ? [NSString stringWithFormat:@"token %@", token.accessToken] : @"";
    [self.operationManager.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
}

#pragma mark - Authentication and authorization

- (NSURLRequest *)authenticationRequestForAllScopes {
    NSArray *scopes = @[NLAutomaticScopePublic,
                        NLAutomaticScopeUserProfile,
                        NLAutomaticScopeUserFollow,
                        NLAutomaticScopeLocation,
                        NLAutomaticScopeCurrentLocation,
                        NLAutomaticScopeVehicleProfile,
                        NLAutomaticScopeVehicleEvents,
                        NLAutomaticScopeVehicleVIN,
                        NLAutomaticScopeTrip,
                        NLAutomaticScopeBehavior,
                        NLAutomaticScopeAdapterBasic
                        ];
    return [self authenticationRequestForScopes:scopes];
}

- (NSURLRequest *)authenticationRequestForStandardScopes
{
    NSArray *scopes = @[NLAutomaticScopePublic,
                        NLAutomaticScopeUserProfile,
                        NLAutomaticScopeLocation,
                        NLAutomaticScopeVehicleProfile,
                        NLAutomaticScopeVehicleEvents,
                        NLAutomaticScopeTrip,
                        NLAutomaticScopeBehavior,
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
    NSString *baseURL = [NSString stringWithFormat:@"%@/%@", kAutomaticAuthBaseURLString, @"authorize"];
    NSString *fullUrl = [NSString stringWithFormat:@"%@?%@", baseURL, joinedParams];
    NSLog(@"Generated URL %@", fullUrl);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fullUrl]];
    return request;
}

- (void)getAccessTokenForCode:(NSString *)code completion:(NLAutomaticTokenCompletionBlock)completion {
    NSString *url = [NSString stringWithFormat:@"%@/%@", kAutomaticAuthBaseURLString, @"access_token"];
    NSDictionary *params = @{@"client_id": self.clientId,
                             @"client_secret": self.clientSecret,
                             @"code": code,
                             @"grant_type": @"authorization_code"};
    [self.operationManager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.token = [NLAutomaticToken tokenWithDictionary:responseObject];
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

- (id<NLAutomaticOperation>)getTrips:(NLAutomaticCompletionBlock)completion {
    NSString *url = @"trips";
    NSDictionary *params = @{};
    id<NLAutomaticOperation> automaticOp = [self.operationManager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *mResults = [NSMutableArray array];
        [responseObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [mResults addObject:[[NLAutomaticTrip alloc] initWithAPIObject:obj]];
        }];
        if (completion) {
            completion(nil, [mResults copy]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(error, operation.responseObject);
        }
    }];
    
    return automaticOp;
}

- (id<NLAutomaticOperation>)getTripForId:(NSString *)identifier completion:(NLAutomaticCompletionBlock)completion
{
    NSString *url = [NSString stringWithFormat:@"%@/%@", @"trips", identifier];
    NSDictionary *params = @{};
    id<NLAutomaticOperation> automaticOp = [self.operationManager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NLAutomaticTrip *trip = [[NLAutomaticTrip alloc] initWithAPIObject:responseObject];
        if (completion) {
            completion(nil, trip);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(error, operation.responseObject);
        }
    }];
    
    return automaticOp;
}

#pragma mark - User data

- (id<NLAutomaticOperation>)getUser:(NLAutomaticCompletionBlock)completion
{
    NSString *url = @"user";
    NSDictionary *params = @{};
    id<NLAutomaticOperation> automaticOp = [self.operationManager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NLAutomaticUser *user = [[NLAutomaticUser alloc] initWithAPIObject:responseObject];
        if (completion) {
            completion(nil, user);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(error, operation.responseObject);
        }
    }];
    
    return automaticOp;
}

#pragma mark - Vehicle data

- (id<NLAutomaticOperation>)getVehicles:(NLAutomaticCompletionBlock)completion
{
    NSString *url = @"vehicles";
    NSDictionary *params = @{};
    id<NLAutomaticOperation> automaticOp = [self.operationManager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *mResults = [NSMutableArray array];
        [responseObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [mResults addObject:[[NLAutomaticVehicle alloc] initWithAPIObject:obj]];
        }];
        if (completion) {
            completion(nil, [mResults copy]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(error, operation.responseObject);
        }
    }];
    
    return automaticOp;
}

- (id<NLAutomaticOperation>)getVehicleForId:(NSString *)identifier completion:(NLAutomaticCompletionBlock)completion
{
    NSString *url = [NSString stringWithFormat:@"%@/%@", @"vehicles", identifier];
    NSDictionary *params = @{};
    id<NLAutomaticOperation> automaticOp = [self.operationManager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NLAutomaticVehicle *vehicle = [[NLAutomaticVehicle alloc] initWithAPIObject:responseObject];
        if (completion) {
            completion(nil, vehicle);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(error, operation.responseObject);
        }
    }];
    
    return automaticOp;
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