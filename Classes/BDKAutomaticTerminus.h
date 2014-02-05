//
//  BDKAutomaticTerminus.h
//  Pods
//
//  Created by Ben Kreeger on 2/4/14.
//
//

#import "BDKAutomaticObject.h"

@interface BDKAutomaticTerminus : BDKAutomaticObject

@property (strong, nonatomic) NSNumber *accuracyInMeters;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSString *name;

@end
