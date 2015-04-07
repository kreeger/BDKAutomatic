//
//  NLAutomaticVehicle.m
//  Pods
//
//  Created by Ben Kreeger on 2/4/14.
//
//

#import "NLAutomaticVehicle.h"

@implementation NLAutomaticVehicle

#pragma mark - NLAutomaticObject

+ (NSDictionary *)attributeMap {
    return @{@"displayName": @"display_name",
             @"identifier": @"id",
             @"make": @"make",
             @"model": @"model",
             @"year": @"year",
             @"uri": @"uri",
             @"color": @"color"
             };
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p> { id: %@, year: %@, make: %@, model: %@ }",
            NSStringFromClass([self class]), self, self.identifier, self.year, self.make, self.model];
}

@end
