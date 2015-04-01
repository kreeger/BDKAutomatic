//
//  BDKAutomaticTrip.h
//  Pods
//
//  Created by Ben Kreeger on 2/4/14.
//
//

#import "BDKAutomaticObject.h"

@class BDKAutomaticTerminus, BDKAutomaticVehicle;

@interface BDKAutomaticTrip : BDKAutomaticObject

@property (strong, nonatomic) NSNumber *averageMpg;
@property (strong, nonatomic) NSNumber *distanceInMeters;
@property (strong, nonatomic) NSNumber *durationOver70MPH;
@property (strong, nonatomic) NSNumber *durationOver75MPH;
@property (strong, nonatomic) NSNumber *durationOver80MPH;
@property (strong, nonatomic) BDKAutomaticTerminus *endLocation;
@property (strong, nonatomic) NSDate *endTime;
@property (strong, nonatomic) NSString *endTimeZone;
@property (strong, nonatomic) NSNumber *fuelCostInUSD;
@property (strong, nonatomic) NSNumber *fuelVolumeInGallons;
@property (strong, nonatomic) NSNumber *hardAccelerations;
@property (strong, nonatomic) NSNumber *hardBrakes;
@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) BDKAutomaticTerminus *startLocation;
@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSString *startTimeZone;
@property (strong, nonatomic) NSURL *uri;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) BDKAutomaticVehicle *vehicle;

@end
