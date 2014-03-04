//
//  main.m
//  IDKSAsync
//
//  Created by Ricardo Sousa on 27/02/14.
//  Copyright (c) 2014 ChallengeIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Executer.h"

NSString* getCurrentDate()
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.YY HH:mm:ss"];
    return [dateFormatter stringFromDate:currentDate];
}

int main(int argc, const char * argv[])
{

    @autoreleasepool
    {
        /*
        Executer *executer = [[Executer alloc] initWithConcurrency];
        
        NSLog(@"before submit work: %@ in thread: %d", getCurrentDate(), [NSThread isMainThread]);
        
        [executer submitWork:^{
            NSLog(@"during work: %@ in thread: %d", getCurrentDate(), [NSThread isMainThread]);
            [NSThread sleepForTimeInterval:5];
            NSLog(@"work done!");
        }];
        
        NSLog(@"after submit work: %@", getCurrentDate());
        */
        
        NSMutableArray *numbers = [NSMutableArray new];
        
        int size = 1<<16;
        NSLog(@"size: %d", size);
        for (int i = 0; i < size; i++)
        {
            numbers[i] = @2;
        }
        
        __block int total = 0;
        
        //NSOperation *firstHalf = [[NSInvocationOperation alloc] initWithTarget:nil selector:@selector(selector) object:numbers];
        NSBlockOperation *adder = [NSBlockOperation new];
        [adder addExecutionBlock:^{
            int firstHalf = 0;
            for (int i = 0; i < size/2; i++)
            {
                firstHalf += [numbers[i] integerValue];
            }
            NSLog(@"first: %d", firstHalf);
            total += firstHalf;
        }];
        [adder addExecutionBlock:^{
            int secondHalf = 0;
            for (int i = size/2; i < size; i++)
            {
                secondHalf += [numbers[i] integerValue];
            }
            NSLog(@"second: %d", secondHalf);
            total += secondHalf;
        }];
        
        [adder start];
        
        [adder waitUntilFinished];
        
        NSLog(@"%d", total);
    }
    
    return 0;
}