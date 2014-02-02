//
//  BDKAutomatic.h
//  BDKAutomatic
//
//  Created by Ben Kreeger on 1/20/14.
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

@import Foundation;

#import <AFNetworking/AFHTTPRequestOperationManager.h>

#import "BDKAutomaticScopes.h"
#import "BDKAutomaticToken.h"

typedef void(^BDKAutomaticCompletionBlock)(NSError *error, id responseObject);
typedef void(^BDKAutomaticTokenCompletionBlock)(NSError *error, BDKAutomaticToken *token);

@interface BDKAutomatic : AFHTTPRequestOperationManager

@property (readonly) NSString *clientId;
@property (readonly) NSString *clientSecret;
@property (readonly) NSURL *redirectUrl;
@property (strong, nonatomic) BDKAutomaticToken *token;

#pragma mark - Lifecycle

- (instancetype)initWithClientId:(NSString *)clientId
                    clientSecret:(NSString *)clientSecret
                     redirectUrl:(NSURL *)redirectUrl;
- (instancetype)initWithClientId:(NSString *)clientId
                    clientSecret:(NSString *)clientSecret
                     redirectUrl:(NSURL *)redirectUrl
                           token:(BDKAutomaticToken *)token;

#pragma mark - Authentication and authorization

- (NSURLRequest *)authenticationRequestForAllScopes;
- (NSURLRequest *)authenticationRequestForScopes:(NSArray *)scopes;
- (void)getAccessTokenForCode:(NSString *)code completion:(BDKAutomaticTokenCompletionBlock)completion;

#pragma mark - Trip data

- (void)getTrips:(BDKAutomaticCompletionBlock)completion;

@end


@interface NSString (URLEncoding)

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;

@end