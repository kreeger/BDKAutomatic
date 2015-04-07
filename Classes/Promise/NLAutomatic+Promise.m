//
//  NLAutomatic+Promise.m
//  Pods
//
//  Created by Nelson LeDuc on 4/1/15.
//
//

#import "NLAutomatic+Promise.h"

#import <Promise.h>

@implementation NLAutomatic (Promise)

#pragma mark - Trip data

- (PMKPromise *)getTrips
{
    return [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
        [self getTrips:^(NSError *error, id responseObject) {
            resolve(responseObject ?: error);
        }];
    }];
}

- (PMKPromise *)getTripForId:(NSString *)identifier
{
    return [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
        [self getTripForId:identifier completion:^(NSError *error, id responseObject) {
            resolve(responseObject ?: error);
        }];
    }];
}

#pragma mark - User data

- (PMKPromise *)getUser
{
    return [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
        [self getUser:^(NSError *error, id responseObject) {
            resolve(responseObject ?: error);
        }];
    }];
}

#pragma mark - Vehicle data

- (PMKPromise *)getVehicles
{
    return [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
        [self getVehicles:^(NSError *error, id responseObject) {
            resolve(responseObject ?: error);
        }];
    }];
}

- (PMKPromise *)getVehicleForId:(NSString *)identifier
{
    return [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
        [self getVehicleForId:identifier completion:^(NSError *error, id responseObject) {
            resolve(responseObject ?: error);
        }];
    }];
}

@end
