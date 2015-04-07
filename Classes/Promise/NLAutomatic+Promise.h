//
//  NLAutomatic+Promise.h
//  Pods
//
//  Created by Nelson LeDuc on 4/1/15.
//
//

#import "NLAutomatic.h"

@class PMKPromise;

@interface NLAutomatic (Promise)

#pragma mark - Trip data

- (PMKPromise *)getTrips;
- (PMKPromise *)getTripForId:(NSString *)identifier;

#pragma mark - User data

- (PMKPromise *)getUser;

#pragma mark - Vehicle data

- (PMKPromise *)getVehicles;
- (PMKPromise *)getVehicleForId:(NSString *)identifier;

@end
