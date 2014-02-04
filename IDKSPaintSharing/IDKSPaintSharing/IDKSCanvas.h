//
//  IDKSCanvas.h
//  IDKSPaintSharing
//
//  Created by Ricardo Sousa on 27/11/13.
//  Copyright (c) 2013 ChallengeIT. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @discussion View for make the draws.
 */
@interface IDKSCanvas : UIView

@property(nonatomic, strong) UIColor *lineColor;

/*!
 @discussion Returns the generated image of the draw. 
 For more info @see https://developer.apple.com/library/ios/documentation/uikit/reference/UIKitFunctionReference/Reference/reference.html#//apple_ref/c/func/UIGraphicsBeginImageContextWithOptions
 
 @return An UIImage object with the draw.
 */
- (UIImage *)getImage;

@end
