//
//  BDKAutomaticTrip.m
//  Pods
//
//  Created by Ben Kreeger on 2/4/14.
//
//

#import "BDKAutomaticTrip.h"

@implementation BDKAutomaticTrip

#pragma mark - BDKAutomaticObject

+ (NSDictionary *)attributeMap {
    return @{@"averageMpg": @"average_mpg",
             @"distanceInMeters": @"distance_m",
             @"durationOver70MPH": @"duration_over_70_s",
             @"durationOver75MPH": @"duration_over_75_s",
             @"durationOver80MPH": @"duration_over_80_s",
             @"endLocation": @{@"type": @"BDKAutomaticTerminus",
                               @"key": @"end_location",},
             @"endTime": @{@"via": @"timeInterval",
                           @"key": @"end_time",},
             @"endTimeZone": @"end_time_zone",
             @"fuelCostInUSD": @"fuel_cost_usd",
             @"fuelVolumeInGallons": @"fuel_volume_gal",
             @"hardAccelerations": @"hard_accels",
             @"hardBrakes": @"hard_brakes",
             @"identifier": @"id",
             @"path": @"path",
             @"startLocation": @{@"type": @"BDKAutomaticTerminus",
                                 @"key": @"start_location",},
             @"startTime": @{@"via": @"timeInterval",
                             @"key": @"start_time",},
             @"startTimeZone": @"start_time_zone",
             @"uri": @"uri",
             @"userId": @"user.id",
             @"vehicle": @{@"type": @"BDKAutomaticVehicle",
                           @"key": @"vehicle",},
             };
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p> { id: %@, startTime: %@ }",
            NSStringFromClass([self class]), self, self.identifier, self.startTime];
}

@end
