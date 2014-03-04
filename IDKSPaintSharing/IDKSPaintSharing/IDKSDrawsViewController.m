//
//  IDKSDrawsViewController.m
//  IDKSPaintSharing
//
//  Created by Ricardo Sousa on 05/02/14.
//  Copyright (c) 2014 challenge_it. All rights reserved.
//

#import "IDKSDrawsViewController.h"
#import "IDKSAppDelegate.h"
#import "Draw.h"
#import "Draw+CRUD.h"
#import "IDKSPaintViewController.h"

@interface IDKSDrawsViewController () <NSFetchedResultsControllerDelegate>

@property(nonatomic, strong) NSFetchedResultsController *controller;

@end

@implementation IDKSDrawsViewController

- (NSFetchedResultsController *)controller
{
    if (!_controller)
    {
        // Get UIApplication for get the managed Object Context.
        IDKSAppDelegate *app = [[UIApplication sharedApplication] delegate];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        // with nil in the predicate, this will retrieve all the draws.
        [request setPredicate:nil];
        [request setEntity:[NSEntityDescription entityForName:@"Draw" inManagedObjectContext:app.managedObjectContext]];
        [request setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"name"
                                                                  ascending:YES
                                                                   selector:@selector(localizedStandardCompare:)]]]; // Use standart compare.
        
        _controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                          managedObjectContext:app.managedObjectContext
                                                            sectionNameKeyPath:nil
                                                                     cacheName:nil];
        
        [_controller setDelegate:self];
    }
    
    return _controller;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSError *error;
    BOOL fetch = [self.controller performFetch:&error];
    
    if (error || !fetch)
        NSLog(@"ERROR PERFORMING FETCH IN DRAWS TABLE VIEW: %@", error.localizedDescription);
    
    // Edit table.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the data from DB. It's necessary to remove before delete the row in the table.
        IDKSAppDelegate *app = [[UIApplication sharedApplication] delegate];
        [Draw deleteDraw:[self.controller objectAtIndexPath:indexPath] inManagedObjectContext:app.managedObjectContext];
        
        // Don't need to call the next method because the NSFetchedResultsController deletes the
        // row ;-)
        // Delete the row from the data source
        // [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.controller sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.controller sections] count] > 0)
    {
        id<NSFetchedResultsSectionInfo> sectionInfo = [[self.controller sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"DrawsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Draw *draw = [self.controller objectAtIndexPath:indexPath];
    cell.textLabel.text = draw.name;
    cell.textLabel.textColor = [UIColor redColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IDKSPaintViewController *paintView = [self.storyboard instantiateViewControllerWithIdentifier:@"PaintView"];
    paintView.draw = [self.controller objectAtIndexPath:indexPath];
    
    [self.navigationController pushViewController:paintView animated:YES];
}

#pragma mark - NSFetchedResultsControllerDelegate methods

/*!
 @discussion For more info @see https://developer.apple.com/library/ios/documentation/CoreData/Reference/NSFetchedResultsControllerDelegate_Protocol/Reference/Reference.html#//apple_ref/occ/intf/NSFetchedResultsControllerDelegate
 */
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}

/*!
 @discussion For more info @see https://developer.apple.com/library/ios/documentation/CoreData/Reference/NSFetchedResultsControllerDelegate_Protocol/Reference/Reference.html#//apple_ref/occ/intf/NSFetchedResultsControllerDelegate
 */
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}

/*!
 @discussion For more info @see https://developer.apple.com/library/ios/documentation/CoreData/Reference/NSFetchedResultsControllerDelegate_Protocol/Reference/Reference.html#//apple_ref/occ/intf/NSFetchedResultsControllerDelegate
 */
-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

/*!
 @discussion For more info @see https://developer.apple.com/library/ios/documentation/CoreData/Reference/NSFetchedResultsControllerDelegate_Protocol/Reference/Reference.html#//apple_ref/occ/intf/NSFetchedResultsControllerDelegate
 */
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

@end
