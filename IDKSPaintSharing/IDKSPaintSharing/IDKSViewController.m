//
//  IDKSViewController.m
//  IDKSPaintSharing
//
//  Created by Ricardo Sousa on 27/11/13.
//  Copyright (c) 2013 ChallengeIT. All rights reserved.
//

#import "IDKSViewController.h"
#import "IDKSShareViewController.h"
#import "IDKSCanvas.h"

/*!
 @discussion Definition of the class extension for IDKSViewController.
 */
@interface IDKSViewController () <IDKSCanvasDelegate>

@property(weak, nonatomic) IBOutlet IDKSCanvas *canvas;
@property(nonatomic, strong) UIColor *lineColor;
@property(nonatomic, strong) NSMutableArray *paths;

@end

@implementation IDKSViewController

/*!
 @discussion Define getter method for paths property for have
 lazy instantiaton.
 @return The paths property.
 */
- (NSMutableArray *)paths
{
    if (!_paths)
        _paths = [[NSMutableArray alloc] init];
    
    return _paths;
}

/*!
 @discussion Override viewWillAppear method for set some properties in 
 the canvas area.
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.canvas.layer setBorderWidth:5.0];
    [self.canvas.layer setBorderColor:[UIColor grayColor].CGColor];
    
    [self.canvas setDelegate:self];
}

#pragma mark - IBActions.

/*!
 @discussion Action for select the desire color.
 @param sender The button clicked.
 */
- (IBAction)selectColor:(UIButton *)sender
{
    self.lineColor = sender.backgroundColor;
}

/*!
 @discussion Action for open the share options 
 table.
 */
- (IBAction)shareDraw
{
    /*
     Opens the share options table using the UINavigationController programmatically.
     Also instantiates the table view controller with the storyboard.
     */
    IDKSShareViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"ShareOptions"];
    view.draw = [self.canvas getImage];
    
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark - Touches events.
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
    [path moveToPoint:[[touches anyObject] locationInView:self.canvas]];
    
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
    [[[self.paths lastObject] bezierPath] addLineToPoint:[[touches anyObject] locationInView:self.canvas]];
    // Redraw the view.
    [self.canvas setNeedsDisplay];
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

#pragma mark - IDKSCanvasDelegate methods.
- (NSArray *)drawPaths
{
    return self.paths;
}

@end
