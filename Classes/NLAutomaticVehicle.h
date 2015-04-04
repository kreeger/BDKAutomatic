//
//  NLAutomaticVehicle.h
//  Pods
//
//  Created by Ben Kreeger on 2/4/14.
//
//

#import "NLAutomaticObject.h"

@interface NLAutomaticVehicle : NLAutomaticObject

@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSNumber *identifier;
@property (strong, nonatomic) NSString *make;
@property (strong, nonatomic) NSString *model;
@property (strong, nonatomic) NSNumber *year;
@property (strong, nonatomic) NSURL *uri;
@property (strong, nonatomic) NSString *color;

@end
