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
@interface IDKSViewController ()

@property (weak, nonatomic) IBOutlet IDKSCanvas *canvas;

@end

@implementation IDKSViewController

/*!
 @discussion Override viewWillAppear method for set some properties in 
 the canvas area.
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.canvas.layer setBorderWidth:5.0];
    [self.canvas.layer setBorderColor:[UIColor grayColor].CGColor];
}

#pragma mark - IBActions.

/*!
 @discussion Action for select the desire color.
 @param sender The button clicked.
 */
- (IBAction)selectColor:(UIButton *)sender
{
    UIColor *selectedColor = sender.backgroundColor;
    self.canvas.lineColor = selectedColor;
    NSLog(@"DEBUG: color selected: %@", [selectedColor description]);
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

@end
