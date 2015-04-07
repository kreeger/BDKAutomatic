//
//  NLAutomaticOperation.h
//  Pods
//
//  Created by Nelson LeDuc on 4/6/15.
//
//

#import <Foundation/Foundation.h>

@protocol NLAutomaticOperation <NSObject>

- (void)cancelAutomaticOperation;
- (void)pauseAutomaticOperation;
- (void)resumeAutomaticOperation;

@end
