//
//  Draw+CRUD.m
//  IDKSPaintSharing
//
//  Created by Ricardo Sousa on 05/02/14.
//  Copyright (c) 2014 challenge_it. All rights reserved.
//

#import "Draw+CRUD.h"

@implementation Draw (CRUD)

+ (Draw *)createWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
    Draw *draw = [NSEntityDescription insertNewObjectForEntityForName:@"Draw"
                                               inManagedObjectContext:context];
    
    draw.name = name;
    
    return draw;
}

+ (Draw *)readByName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Draw"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // [matches count] > 1 because the name is unique.
    if (!matches || error || [matches count] > 1)
    {
        NSLog(@"ERROR READING DRAW: %@", error.localizedDescription);
        return nil;
    }
    
    return ([matches count])? [matches firstObject] : nil;
}

+ (void)deleteDraw:(Draw *)draw inManagedObjectContext:(NSManagedObjectContext *)context
{
    [context deleteObject:draw];
    NSError *error;
    [context save:&error];
    if (error)
        NSLog(@"ERROR DELETE DRAW: %@", error.localizedDescription);
}

@end