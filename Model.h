//
//  Model.h
//  iDzienniczek
//
//  Created by MacBury on 08-09-03.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "iDzienniczekAppDelegate.h"

@interface Model : NSObject {
	NSInteger _id;
	
	sqlite3 *database;
}

@property (assign, nonatomic) NSInteger _id;

- (NSMutableArray *)findBySql:(const char *)sql id:(NSArray *)binds;

- (void) save:(const char *)sql update:(const char *)sql;
- (void) deleteFromDatabase:(const char *)deleteSQL bind:(NSArray *)bind;

- (bool) prepareDB;
- (void) bindDBValue:(NSArray *)binds statement:(sqlite3_stmt *)statement;

+ (iDzienniczekAppDelegate *) getAppDelegate;
- (int) count:(const char *)sql bind:(NSArray *)bind;

@end
