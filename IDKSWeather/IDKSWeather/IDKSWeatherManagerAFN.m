//
//  IDKSWeatherManagerAFN.m
//  IDKSWeather
//
//  Created by Ricardo Sousa on 05/03/14.
//  Copyright (c) 2014 challenge_it. All rights reserved.
//

#import "IDKSWeatherManagerAFN.h"
#import "AFNetworking.h"

@interface IDKSWeatherManagerAFN ()
@property(nonatomic, strong) AFHTTPRequestOperationManager *manager;
@end

@implementation IDKSWeatherManagerAFN
/*!
 @discussion Override get method for manager property.
 */
- (AFHTTPRequestOperationManager *)manager
{
    if (_manager == nil)
        _manager = [AFHTTPRequestOperationManager manager];
    
    return _manager;
}

- (void)getCurrentWeatherForCity:(NSString *)city withCompletionSuccessHandler:(void (^)(NSString *))success andFailureHandler:(void (^)(NSString *))failure
{
    // Construct the parameters.
    NSDictionary *parameters = @{
                                 @"q": city,
                                 @"mode": @"json",
                                 @"units": @"metric"
    };
    
    [self.manager GET:@"http://api.openweathermap.org/data/2.5/weather" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Get the json response.
        NSDictionary *result = (NSDictionary *)responseObject;
        int weather = [[[result objectForKey:@"main"] objectForKey:@"temp"] intValue];
        // Execute the success block.
        success([NSString stringWithFormat:@"%d", weather]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Execute the failure block.
        failure(error.description);
    }];
}

@end
