//
//  BDKAutomaticTerminus.m
//  Pods
//
//  Created by Ben Kreeger on 2/4/14.
//
//

#import "BDKAutomaticTerminus.h"

@implementation BDKAutomaticTerminus

#pragma mark - BDKAutomaticObject

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
