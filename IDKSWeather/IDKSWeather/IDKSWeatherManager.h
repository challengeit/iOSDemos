//
//  IDKSWeatherManager.h
//  IDKSWeather
//
//  Created by Ricardo Sousa on 05/03/14.
//  Copyright (c) 2014 challenge_it. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @discussion Manager for get current wheather information.
 */
@interface IDKSWeatherManager : NSObject

/*!
 @discussion Get the current weather for the desire city.
 @param city    The city name.
 @param handler The code block to execute in main thread after get the weather, the block receives the weather in ºC.
 @return The weather in ºC.
 */
+ (void)getCurrentWeatherForCity:(NSString *)city withCompletionHandler:(void (^)(NSString*))handler;

@end