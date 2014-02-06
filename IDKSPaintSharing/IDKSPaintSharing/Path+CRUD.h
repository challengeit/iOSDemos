//
//  Path+CRUD.h
//  IDKSPaintSharing
//
//  Created by Ricardo Sousa on 05/02/14.
//  Copyright (c) 2014 challenge_it. All rights reserved.
//

#import "Path.h"

/*!
 @discussion Category for Path managed object.
 Contains the operations for perform the CRUD operations.
 */
@interface Path (CRUD)

/*!
 @discussion Create operation.
 @param path     The bezier path for the path.
 @param color    The color for the path.
 @param drawName The Draw's name where the path exists.
 @param context  The managed object context (DB).
 */
+ (void)createWithBezierPath:(UIBezierPath *)path color:(UIColor *)color andDrawName:(NSString *)drawName inManagedObjectContext:(NSManagedObjectContext *)context;

// TODO: implement the other operations.

@end