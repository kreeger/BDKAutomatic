//
//  BDKAutomaticUser.h
//  Pods
//
//  Created by Nelson LeDuc on 4/1/15.
//
//

#import "BDKAutomaticObject.h"

@interface BDKAutomaticUser : BDKAutomaticObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;

@end
