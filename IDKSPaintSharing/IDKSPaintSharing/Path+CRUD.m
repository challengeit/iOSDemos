//
//  Path+CRUD.m
//  IDKSPaintSharing
//
//  Created by Ricardo Sousa on 05/02/14.
//  Copyright (c) 2014 challenge_it. All rights reserved.
//

#import "Path+CRUD.h"
#import "Draw+CRUD.h"

@implementation Path (CRUD)

+ (void)createWithBezierPath:(UIBezierPath *)path color:(UIColor *)color andDrawName:(NSString *)drawName inManagedObjectContext:(NSManagedObjectContext *)context
{
    Path *newPath = [NSEntityDescription insertNewObjectForEntityForName:@"Path"
                                                  inManagedObjectContext:context];
    
    newPath.bezierPath = path;
    newPath.color = color;
    Draw *draw = [Draw readByName:drawName inManagedObjectContext:context];
    newPath.draw = (draw)? draw : [Draw createWithName:drawName inManagedObjectContext:context];
}

@end