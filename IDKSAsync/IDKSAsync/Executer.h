//
//  Executer.h
//  IDKSAsync
//
//  Created by Ricardo Sousa on 27/02/14.
//  Copyright (c) 2014 ChallengeIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Executer : NSObject

-(id)initWithConcurrency;

-(void)submitWork:(dispatch_block_t)work;

@end
