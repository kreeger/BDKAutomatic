//
//  AFHTTPRequestOperation+NLAutomaticOperation.m
//  Pods
//
//  Created by Nelson LeDuc on 4/6/15.
//
//

#import "AFHTTPRequestOperation+NLAutomaticOperation.h"

@implementation AFHTTPRequestOperation (NLAutomaticOperation)

- (void)cancelAutomaticOperation
{
    [self cancel];
}

- (void)pauseAutomaticOperation
{
    [self pause];
}

- (void)resumeAutomaticOperation
{
    [self resume];
}

@end
