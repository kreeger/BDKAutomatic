//
//  BDKAutomaticUser.m
//  Pods
//
//  Created by Nelson LeDuc on 4/1/15.
//
//

#import "BDKAutomaticUser.h"

@implementation BDKAutomaticUser

+ (NSDictionary *)attributeMap {
    return @{@"identifier": @"id",
             @"firstName": @"first_name",
             @"lastName": @"last_name",
             @"email": @"email"
             };
}

@end
