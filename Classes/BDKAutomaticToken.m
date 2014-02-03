//
//  BDKAutomaticToken.m
//  Pods
//
//  Created by Ben Kreeger on 2/2/14.
//
//

#import "BDKAutomaticToken.h"

@interface BDKAutomaticToken ()

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

@implementation BDKAutomaticToken

#pragma mark - Lifecycle

+ (instancetype)tokenWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (!self) return nil;
    
    NSLog(@"Creating %@ with dictionary %@.", NSStringFromClass([self class]), dictionary);
    _accessToken = dictionary[@"access_token"];
    _expiresAt = [NSDate dateWithTimeIntervalSinceNow:[dictionary[@"expires_in"] integerValue]];
    _userId = dictionary[@"user"][@"id"];
    _scopes = [dictionary[@"scope"] componentsSeparatedByString:@" "];
    _refreshToken = dictionary[@"refresh_token"];
    _tokenType = dictionary[@"token_type"];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) return nil;
    
    _accessToken = [aDecoder decodeObjectForKey:@"accessToken"];
    _expiresAt = [aDecoder decodeObjectForKey:@"expiresAt"];
    _userId = [aDecoder decodeObjectForKey:@"userId"];
    _scopes = [aDecoder decodeObjectForKey:@"scopes"];
    _refreshToken = [aDecoder decodeObjectForKey:@"refreshToken"];
    _tokenType = [aDecoder decodeObjectForKey:@"tokenType"];
    
    return self;
}

#pragma mark - NSCoder

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.accessToken forKey:@"accessToken"];
    [aCoder encodeObject:self.expiresAt forKey:@"expiresAt"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.scopes forKey:@"scopes"];
    [aCoder encodeObject:self.refreshToken forKey:@"refreshToken"];
    [aCoder encodeObject:self.tokenType forKey:@"tokenType"];
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p> { accessToken: %@, expiresAt: %@, userId: %@, scopes: %@ }",
            NSStringFromClass([self class]), self, self.accessToken, self.expiresAt, self.userId,
            [self.scopes componentsJoinedByString:@", "]];
}

@end