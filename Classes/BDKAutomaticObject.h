//
//  BDKAutomaticObject.h
//  Pods
//
//  Created by Ben Kreeger on 2/4/14.
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.b
//

@import Foundation;

@interface BDKAutomaticObject : NSObject <NSCoding>

+ (NSDictionary *)attributeMap;

- (instancetype)initWithAPIObject:(NSDictionary *)apiObject;
- (void)updateWithAPIObject:(NSDictionary *)apiObject;

@end
