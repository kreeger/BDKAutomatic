//
//  NLAutomatic.h
//  NLAutomatic
//
//  Created by Ben Kreeger on 1/20/14.
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

@import Foundation;
#import "NLAutomaticScopes.h"

@class NLAutomaticToken;
@protocol NLAutomaticOperation;

typedef void(^NLAutomaticCompletionBlock)(NSError *error, id responseObject);
typedef void(^NLAutomaticTokenCompletionBlock)(NSError *error, NLAutomaticToken *token);

@interface NLAutomatic : NSObject

@property (nonatomic, strong, readonly) NSString *clientId;
@property (nonatomic, strong, readonly) NSString *clientSecret;
@property (nonatomic, strong, readonly) NSURL *redirectUrl;
@property (nonatomic, strong) NLAutomaticToken *token;

#pragma mark - Lifecycle

- (instancetype)initWithClientId:(NSString *)clientId
                    clientSecret:(NSString *)clientSecret
                     redirectUrl:(NSURL *)redirectUrl;
- (instancetype)initWithClientId:(NSString *)clientId
                    clientSecret:(NSString *)clientSecret
                     redirectUrl:(NSURL *)redirectUrl
                           token:(NLAutomaticToken *)token;

#pragma mark - Authentication and authorization

- (NSURLRequest *)authenticationRequestForAllScopes;
- (NSURLRequest *)authenticationRequestForStandardScopes;
- (NSURLRequest *)authenticationRequestForScopes:(NSArray *)scopes;
- (void)getAccessTokenForCode:(NSString *)code completion:(NLAutomaticTokenCompletionBlock)completion;

#pragma mark - Trip data

- (id<NLAutomaticOperation>)getTrips:(NLAutomaticCompletionBlock)completion;
- (id<NLAutomaticOperation>)getTripForId:(NSString *)identifier completion:(NLAutomaticCompletionBlock)completion;

#pragma mark - User data

- (id<NLAutomaticOperation>)getUser:(NLAutomaticCompletionBlock)completion;

#pragma mark - Vehicle data

- (id<NLAutomaticOperation>)getVehicles:(NLAutomaticCompletionBlock)completion;
- (id<NLAutomaticOperation>)getVehicleForId:(NSString *)identifier completion:(NLAutomaticCompletionBlock)completion;

@end


@interface NSString (URLEncoding)

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;

@end