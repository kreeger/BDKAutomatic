//
//  NLAutomaticUser.h
//  Pods
//
//  Created by Nelson LeDuc on 4/1/15.
//
//

#import "NLAutomaticObject.h"

@interface NLAutomaticUser : NLAutomaticObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;

@end
