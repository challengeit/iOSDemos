//
//  IDKSViewController.m
//  IDKSWeather
//
//  Created by Ricardo Sousa on 05/03/14.
//  Copyright (c) 2014 challenge_it. All rights reserved.
//

#import "IDKSViewController.h"
#import "IDKSWeatherManager.h"
#import "IDKSWeatherManagerAFN.h"

@interface IDKSViewController ()
@property (weak, nonatomic) IBOutlet UITextField *cityNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;

@property (nonatomic, strong) IDKSWeatherManagerAFN *weatherManagerAFN;
@end

@implementation IDKSViewController
/*!
 @discussion Overrides getter method for AFN weather manager property.
 */
- (IDKSWeatherManagerAFN *)weatherManagerAFN
{
    if (_weatherManagerAFN == nil)
        _weatherManagerAFN = [IDKSWeatherManagerAFN new];
    
    return _weatherManagerAFN;
}

/*!
 @discussion Action for get the current wheater from the desire city and 
 set the weather in the weather label.
 */
- (IBAction)getWeather:(id)sender
{
    // Dismiss the text field's keyboard.
    [self.cityNameTextField resignFirstResponder];
    // Get the wheater.
    [IDKSWeatherManager getCurrentWeatherForCity:self.cityNameTextField.text
                           withCompletionHandler:^(NSString * weather) {
        
        self.weatherLabel.text = [NSString stringWithFormat:@"%@ ºC", weather];
    }];
}

/*!
 @discussion Action for get the current wheater from the desire city and
 set the weather in the weather label. Uses the AFNetworking framework.
 */
- (IBAction)getWeatherAFN:(id)sender
{
    // Dismiss the text field's keyboard.
    [self.cityNameTextField resignFirstResponder];
    // Get the wheater using AFNetworking framework.
    [self.weatherManagerAFN getCurrentWeatherForCity:self.cityNameTextField.text
                        withCompletionSuccessHandler:^(NSString *weather) {
       
        self.weatherLabel.text = [NSString stringWithFormat:@"%@ ºC", weather];
                            
    } andFailureHandler:^(NSString * error) {
        
        self.weatherLabel.text = [NSString stringWithFormat:@"%@", error];
    }];
}

@end