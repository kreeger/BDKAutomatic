//
//  NLAutomaticObject.m
//  Pods
//
//  Created by Ben Kreeger on 2/4/14.
//
//

#import "NLAutomaticObject.h"

#import <objc/runtime.h>

@implementation NLAutomaticObject

#pragma mark - Class methods

+ (NSDictionary *)attributeMap {
    return @{};
}

#pragma mark - Lifecycle

- (instancetype)initWithAPIObject:(NSDictionary *)apiObject {
    self = [super init];
    if (!self) return nil;
    [self updateWithAPIObject:apiObject];
    return self;
}

- (void)updateWithAPIObject:(NSDictionary *)apiObject {
    [[[self class] attributeMap] enumerateKeysAndObjectsUsingBlock:^(NSString *localName, id value, BOOL *stop) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            id remoteValue = [apiObject valueForKey:value[@"key"]];
            if (value[@"type"]) {
                Class remoteClass = NSClassFromString(value[@"type"]);
                if ([remoteClass isSubclassOfClass:[NLAutomaticObject class]]) {
                    id instanceOfRemoteClass = [[remoteClass alloc] initWithAPIObject:remoteValue];
                    [self setValue:instanceOfRemoteClass forKey:localName];
                }
                return;
            } else if (value[@"via"]) {
                if ([value[@"via"] isEqualToString:@"timeInterval"]) {
                    // Move the decimal place three points to the left?
                    NSTimeInterval interval = [remoteValue doubleValue] * 0.001;
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
                    [self setValue:date forKey:localName];
                    return;
                }
            }
        }
        id remoteValue = [apiObject valueForKeyPath:value];
        if (remoteValue && ![remoteValue isEqual:[NSNull null]]) {
            [self setValue:remoteValue forKey:localName];
        }
    }];
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p>", NSStringFromClass([self class]), self];
}

#pragma mark - NSCoder

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
