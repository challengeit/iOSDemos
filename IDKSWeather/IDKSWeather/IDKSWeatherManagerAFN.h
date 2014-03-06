//
//  IDKSWeatherManagerAFN.h
//  IDKSWeather
//
//  Created by Ricardo Sousa on 05/03/14.
//  Copyright (c) 2014 challenge_it. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @discussion Manager for get current wheather information.
 Uses the AFNetworking framework for make the HTTP requests.
 */
@interface IDKSWeatherManagerAFN : NSObject

/*!
 @discussion Get the current weather for the desire city.
 @param city    The city name.
 @param success The success code block to execute in main thread after get the weather, the block receives the weather in ºC.
 @param failure The failure code block. Receives the error description.
 @return The weather in ºC.
 */
- (void)getCurrentWeatherForCity:(NSString *)city withCompletionSuccessHandler:(void (^)(NSString*))success andFailureHandler:(void (^)(NSString*))failure;

@end
