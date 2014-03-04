//
//  IDKSViewController.m
//  IDKSPaintSharing
//
//  Created by Ricardo Sousa on 27/11/13.
//  Copyright (c) 2013 ChallengeIT. All rights reserved.
//

#import "IDKSPaintViewController.h"
#import "IDKSShareViewController.h"
#import "IDKSCanvas.h"
#import "Path+CRUD.h"
#import "Draw+CRUD.h"
#import "IDKSAppDelegate.h"
#import "Draw.h"

/*!
 @discussion Definition of the class extension for IDKSViewController.
 */
@interface IDKSPaintViewController () <IDKSCanvasDelegate, UIActionSheetDelegate, UIAlertViewDelegate>

@property(weak, nonatomic) IBOutlet IDKSCanvas *canvas;
@property(nonatomic, strong) UIColor *lineColor;
@property(nonatomic, strong) NSMutableArray *paths;

@end

@implementation IDKSPaintViewController

/*!
 @discussion Define getter method for paths property for have
 lazy instantiaton.
 @return The paths property.
 */
- (NSMutableArray *)paths
{
    if (!_paths)
    {
        _paths = [[NSMutableArray alloc] init];
        
        if (self.draw)
        {
            // Open an existing draw.
            self.navigationItem.title = self.draw.name;
            for (Path *path in self.draw.paths)
                [_paths addObject:[[Pair alloc] initWithPath:path.bezierPath andColor:path.color]];
            
            // Redraw the canvas with the news bezier paths.
            [self.canvas setNeedsDisplay];
        }
    }
    
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
 @discussion Action for open the draw options.
 @param sender The bar button item clicked.
 */
- (IBAction)openDrawOptions:(id) sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Options"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Save", @"Share Draw", nil];
    
    [actionSheet showFromBarButtonItem:sender animated:YES];
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

#pragma mark - UIActionSheetDelegate methods.
/*!
 @discussion For more info @see https://developer.apple.com/library/ios/documentation/uikit/reference/UIModalViewDelegate_Protocol/UIActionSheetDelegate/UIActionSheetDelegate.html
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:// Save.
            [self saveAction];
            break;
        
        case 1:// Share the draw.
            [self shareAction];
            break;
            
        default:
            break;
    }
}

/*!
 @discussion Helper method for save the draw.
 */
- (void)saveAction
{
    // If the draw have a name, so it's for update.
    if (![self.navigationItem.title isEqualToString:@"Paint"])
    {
        [self saveInDB:self.navigationItem.title];
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"draw name" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

/*!
 @discussion Helper method for open the share options table.
 */
- (void)shareAction
{
    /*
     Opens the share options table using the UINavigationController programmatically.
     Also instantiates the table view controller with the storyboard.
     */
    IDKSShareViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ShareOptions"];
    controller.draw = [self.canvas getImage];
    
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UIAlertViewDelegate methods.
/*!
 @discussion For more info @see https://developer.apple.com/library/ios/documentation/uikit/reference/UIAlertViewDelegate_Protocol/UIAlertViewDelegate/UIAlertViewDelegate.html
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        [self saveAction];
        return;
    }
    
    if (buttonIndex == 0)
        return;
    
    NSString *drawName = [[alertView textFieldAtIndex:0] text];
    
    // First verify if already exists.
    IDKSAppDelegate *app = [[UIApplication sharedApplication] delegate];
    [app.managedObjectContext performBlock:^{
        if ([Draw readByName:drawName inManagedObjectContext:app.managedObjectContext] != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                // Alert the user.
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention" message:[NSString stringWithFormat:@"Already exists one draw with the name: %@", drawName] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                alert.tag = 1;
                
                [alert show];
            });
        }
        else
            // Create in DB.
            [self saveInDB: drawName];
    }];
}

/*!
 @discussion Helper method for save the draw in DB.
 @param drawName The name of the draw.
 */
- (void)saveInDB:(NSString *)drawName
{
    IDKSAppDelegate *app = [[UIApplication sharedApplication] delegate];
    
    [app.managedObjectContext performBlock:^{
        
        for (Pair *pair in self.paths)
            [Path createWithBezierPath:pair.bezierPath color:pair.color andDrawName:drawName inManagedObjectContext:app.managedObjectContext];
            
        NSError *error;
        [app.managedObjectContext save:&error];
        if (error)
            NSLog(@"ERROR DURING SAVING THE DRAW: %@", error.localizedDescription);
    }];
}

@end
