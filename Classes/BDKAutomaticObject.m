//
//  BDKAutomaticObject.m
//  Pods
//
//  Created by Ben Kreeger on 2/4/14.
//
//

#import "BDKAutomaticObject.h"

@implementation BDKAutomaticObject

+ (NSDictionary *)attributeMap {
    return @{};
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) return nil;
    [[[[self class] attributeMap] allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
    }];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [[[[self class] attributeMap] allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }];
}

@end
