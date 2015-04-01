//
//  BDKAutomatic.h
//  BDKAutomatic
//
//  Created by Ben Kreeger on 1/20/14.
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

@import Foundation;

#import "BDKAutomaticScopes.h"
#import "BDKAutomaticToken.h"

typedef void(^BDKAutomaticCompletionBlock)(NSError *error, id responseObject);
typedef void(^BDKAutomaticTokenCompletionBlock)(NSError *error, BDKAutomaticToken *token);

@interface BDKAutomatic : NSObject

@property (nonatomic, strong, readonly) NSString *clientId;
@property (nonatomic, strong, readonly) NSString *clientSecret;
@property (nonatomic, strong, readonly) NSURL *redirectUrl;
@property (nonatomic, strong) BDKAutomaticToken *token;

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
- (NSURLRequest *)authenticationRequestForStandardScopes;
- (NSURLRequest *)authenticationRequestForScopes:(NSArray *)scopes;
- (void)getAccessTokenForCode:(NSString *)code completion:(BDKAutomaticTokenCompletionBlock)completion;

#pragma mark - Trip data

- (void)getTrips:(BDKAutomaticCompletionBlock)completion;
- (void)getTripForId:(NSString *)identifier completion:(BDKAutomaticCompletionBlock)completion;

#pragma mark - User data

- (void)getUser:(BDKAutomaticCompletionBlock)completion;

#pragma mark - Vehicle data

- (void)getVehicles:(BDKAutomaticCompletionBlock)completion;
- (void)getVehicleForId:(NSString *)identifier completion:(BDKAutomaticCompletionBlock)completion;

@end


@interface NSString (URLEncoding)

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;

@end