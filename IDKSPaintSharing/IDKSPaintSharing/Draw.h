//
//  Draw.h
//  IDKSPaintSharing
//
//  Created by Ricardo Sousa on 05/02/14.
//  Copyright (c) 2014 challenge_it. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Path;

@interface Draw : NSManagedObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSSet *paths;
@end

@interface Draw (CoreDataGeneratedAccessors)

- (void)addPathsObject:(Path *)value;
- (void)removePathsObject:(Path *)value;
- (void)addPaths:(NSSet *)values;
- (void)removePaths:(NSSet *)values;

@end
