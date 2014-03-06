//
//  IDKSWeatherManager.m
//  IDKSWeather
//
//  Created by Ricardo Sousa on 05/03/14.
//  Copyright (c) 2014 challenge_it. All rights reserved.
//

#import "IDKSWeatherManager.h"

static char* URL = "http://api.openweathermap.org/data/2.5/weather?q=city&mode=json&units=metric";

@implementation IDKSWeatherManager

+ (void)getCurrentWeatherForCity:(NSString *)city withCompletionHandler:(void (^)(NSString *))handler
{
    // Construct the url object.
    NSURL *url = [NSURL URLWithString: [[NSString stringWithUTF8String:URL] stringByReplacingOccurrencesOfString:@"city" withString:city]];
    // Construct the url request object.
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // Performs the request asynchronously.
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue] // Get the main queue for execute the handler in main queue!
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               
                               if (connectionError)
                               {
                                   handler([NSString stringWithFormat:@"error ocurred: %@", connectionError.description]);
                                   return;
                               }
                               
                               // The response is in json, we need to parse it.
                               NSError* error;
                               NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                               if (error)
                               {
                                   handler([NSString stringWithFormat:@"error ocurred: %@", error.description]);
                                   return;
                               }
                               
                               int weather = [[[result objectForKey:@"main"] objectForKey:@"temp"] intValue];
                               handler([NSString stringWithFormat:@"%d", weather]); // Execute the block in main thread :-)
    }];
}

@end