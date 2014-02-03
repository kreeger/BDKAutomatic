//
//  BDKAutomaticToken.h
//  Pods
//
//  Created by Ben Kreeger on 2/2/14.
//
//

#import <Foundation/Foundation.h>

@interface BDKAutomaticToken : NSObject <NSCoding>

@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSDate *expiresAt;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSArray *scopes;
@property (strong, nonatomic) NSString *refreshToken;
@property (strong, nonatomic) NSString *tokenType;

#pragma mark - Lifecycle

+ (instancetype)tokenWithDictionary:(NSDictionary *)dictionary;

@end