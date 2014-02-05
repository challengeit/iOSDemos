//
//  IDKSCanvas.h
//  IDKSPaintSharing
//
//  Created by Ricardo Sousa on 27/11/13.
//  Copyright (c) 2013 ChallengeIT. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @discussion Pair object to hold one bezier path and the respective color.
 */
@interface Pair : NSObject

@property(nonatomic, strong) UIBezierPath *bezierPath;
@property(nonatomic, strong) UIColor *color;

/*!
 @discussion init method overload for receive the path and the color to
 add to pair.
 @param path  The UIBezierPath.
 @param color The UIColor.
 */
- (id)initWithPath:(UIBezierPath *)path andColor:(UIColor *)color;

@end

/*!
 @discussion Protocol for delegation.
 */
@protocol IDKSCanvasDelegate <NSObject>

@required
- (NSArray *) drawPaths;

@end

/*!
 @discussion View for make the draws.
 */
@interface IDKSCanvas : UIView

@property(nonatomic, weak) id<IDKSCanvasDelegate> delegate;

/*!
 @discussion Returns the generated image of the draw. 
 For more info @see https://developer.apple.com/library/ios/documentation/uikit/reference/UIKitFunctionReference/Reference/reference.html#//apple_ref/c/func/UIGraphicsBeginImageContextWithOptions
 
 @return An UIImage object with the draw.
 */
- (UIImage *)getImage;

@end