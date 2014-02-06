//
//  IDKSViewController.h
//  IDKSPaintSharing
//
//  Created by Ricardo Sousa on 27/11/13.
//  Copyright (c) 2013 ChallengeIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Draw;

/*!
 @discussion Controller that holds the canvas view for drawing.
 */
@interface IDKSPaintViewController : UIViewController

/*!
 @discussion property for the case we open an existing draw.
 */
@property(nonatomic, strong) Draw *draw;

@end