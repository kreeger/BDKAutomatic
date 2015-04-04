//
//  NLAutomaticTerminus.m
//  Pods
//
//  Created by Ben Kreeger on 2/4/14.
//
//

#import "NLAutomaticTerminus.h"

@implementation NLAutomaticTerminus

#pragma mark - NLAutomaticObject

+ (NSDictionary *)attributeMap {
    return @{@"accuracyInMeters": @"accuracy_m",
             @"latitude": @"lat",
             @"longitude": @"lon",
             @"name": @"name",
             };
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p> { name: %@, latitude: %@, longitude: %@ }",
            NSStringFromClass([self class]), self, self.name, self.latitude, self.longitude];
}

@end
