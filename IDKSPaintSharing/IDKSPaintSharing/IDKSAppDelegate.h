//
//  IDKSAppDelegate.h
//  IDKSPaintSharing
//
//  Created by Ricardo Sousa on 02/02/14.
//  Copyright (c) 2014 challenge_it. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDKSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
