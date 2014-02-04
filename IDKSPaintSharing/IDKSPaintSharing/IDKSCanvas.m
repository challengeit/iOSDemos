//
//  IDKSCanvas.m
//  IDKSPaintSharing
//
//  Created by Ricardo Sousa on 27/11/13.
//  Copyright (c) 2013 ChallengeIT. All rights reserved.
//

#import "IDKSCanvas.h"

#pragma mark - Pair
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

@implementation Pair

- (id)initWithPath:(UIBezierPath *)path andColor:(UIColor *)color
{
    if (self = [self init])
    {
        self.bezierPath = path;
        self.color = color;
    }
    
    return self;
}

@end

#pragma mark - IDKSCanvas
@interface IDKSCanvas ()

@property(nonatomic, strong) NSMutableArray *paths;

@end

@implementation IDKSCanvas

/*!
 @discussion Getter method for paths array.
 @return the paths array instance.
 */
- (NSMutableArray *)paths
{
    // Lazy instantiation.
    if (!_paths)
        _paths = [NSMutableArray new];
    
    return _paths;
}

/*!
 @discussion drawRect method override for draw the paths in the 
 view.
 */
-(void)drawRect:(CGRect)rect
{
    for (Pair *pair in self.paths)
    {
        [pair.color setStroke];
        [pair.bezierPath stroke];
    }
}

- (UIImage *)getImage
{
    // The last parameter (scale factor) is 0.0 for don't lose quality.
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);

    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - Touch event methods.
/*!
 @discussion Overrides touchesBegan method for get the first point on
 the screen.
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // If the color is white, the line width is superior (eraser).
    CGFloat width = (self.lineColor == [UIColor whiteColor])? 70.0 : 2.0;
    [path setLineWidth:width];
    
    // Set the starting point of the draw line.
    [path moveToPoint:[[touches anyObject] locationInView:self]];
    
    // Add the pair path/color to array.
    [self.paths addObject:[[Pair alloc] initWithPath:path andColor:self.lineColor]];
}

/*!
 @discussion Overrides touchesMoved method for get the current point and
 then draw a line from last point to the current point.
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Draw line.
    [[[self.paths lastObject] bezierPath] addLineToPoint:[[touches anyObject] locationInView:self]];
    // Redraw the view.
    [self setNeedsDisplay];
}

/*!
 @discussion Overrides touchesEnded method for end the draw.
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Do the same thing as touchesMoved.
    [self touchesMoved:touches withEvent:event];
}

/*!
 @discussion Overrides touchesCancelled method for cancel the draw.
 */
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Do the same thing as touchesMoved.
    [self touchesMoved:touches withEvent:event];
}

@end
