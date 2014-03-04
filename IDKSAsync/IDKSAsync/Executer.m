//
//  Executer.m
//  IDKSAsync
//
//  Created by Ricardo Sousa on 27/02/14.
//  Copyright (c) 2014 ChallengeIT. All rights reserved.
//

#import "Executer.h"

@interface Executer()

@property(nonatomic, strong) dispatch_queue_t queue;

@end

@implementation Executer

- (id)initWithConcurrency
{
    if (self = [super init])
    {
        self.queue = dispatch_queue_create("Executer", DISPATCH_QUEUE_CONCURRENT);
    }
    
    return self;
}

- (void)submitWork:(dispatch_block_t)work
{
    dispatch_async(self.queue, work);
}

@end
