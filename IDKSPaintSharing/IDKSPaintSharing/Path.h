//
//  Path.h
//  IDKSPaintSharing
//
//  Created by Ricardo Sousa on 05/02/14.
//  Copyright (c) 2014 challenge_it. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Draw;

@interface Path : NSManagedObject

@property (nonatomic, retain) UIColor *color;
@property (nonatomic, retain) UIBezierPath *bezierPath;
@property (nonatomic, retain) Draw *draw;

@end
