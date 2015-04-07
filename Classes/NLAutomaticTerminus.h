//
//  NLAutomaticTerminus.h
//  Pods
//
//  Created by Ben Kreeger on 2/4/14.
//
//

#import "NLAutomaticObject.h"

@interface NLAutomaticTerminus : NLAutomaticObject

@property (strong, nonatomic) NSNumber *accuracyInMeters;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSString *name;

@end
