//
//  BDKAutomaticVehicle.h
//  Pods
//
//  Created by Ben Kreeger on 2/4/14.
//
//

#import "BDKAutomaticObject.h"

@interface BDKAutomaticVehicle : BDKAutomaticObject

@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSNumber *identifier;
@property (strong, nonatomic) NSString *make;
@property (strong, nonatomic) NSString *model;
@property (strong, nonatomic) NSNumber *year;

@end
