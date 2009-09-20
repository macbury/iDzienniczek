//
//  Model.m
//  iDzienniczek
//
//  Created by MacBury on 08-09-03.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Model.h"



@implementation Model

@synthesize _id;

- (id) init {
	if (self == [super init]){
		database = nil;
		self._id = -1;
	}
	
	return self;
}

+ (iDzienniczekAppDelegate *) getAppDelegate {
	return (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (bool) prepareDB {
	iDzienniczekAppDelegate * appDelegate = [Model getAppDelegate];
	
	if(sqlite3_open([appDelegate.userDataBasePath UTF8String], &database) == SQLITE_OK){
		return YES;
	}else{
		NSLog(@"Nie można otworzyć bazy danych z powodu: '%s'.", sqlite3_errmsg(database));
		return NO;
	}
}

- (id) createObjectFromStatement:(sqlite3_stmt *)selectStatement {
	return nil;
}

- (void) createStatementFromObject:(sqlite3_stmt *)update_statement {
	return;
}

- (NSMutableArray *)findBySql:(const char *)sql id:(NSArray *)binds {
	NSMutableArray * outputArray = [[NSMutableArray alloc] init];
	
	if ([self prepareDB]){
		sqlite3_stmt *selectStatement;
		
		
		int returnValue = sqlite3_prepare_v2(database, sql, -1, &selectStatement, NULL);
		
		[self bindDBValue:binds statement:selectStatement];
		
		if(returnValue == SQLITE_OK)
		{
			while(sqlite3_step(selectStatement) == SQLITE_ROW)
			{
				[outputArray addObject: [self createObjectFromStatement:selectStatement]];
			}
		}else{
			NSLog(@"Nie można przetworzyć danych bazy z powodu: '%s'.", sqlite3_errmsg(database));
		}
		
		sqlite3_reset(selectStatement);
		sqlite3_finalize(selectStatement);
		sqlite3_close(database);
		database = nil;
	}
	
	//[binds release];
	//binds = nil;
	
	return outputArray;
}

- (void) bindDBValue:(NSArray *)binds statement:(sqlite3_stmt *)statement  {
	if (binds != nil){
		for (int i = 0; i < [binds count]; i++) {
			sqlite3_bind_int(statement, i+1, [[binds objectAtIndex: i] intValue]);
		}
	}
}

- (int) count:(const char *)sql bind:(NSArray *)bind {
	int count = 0;
	
	if ([self prepareDB]){
		sqlite3_stmt *count_statement;
		
		int returnValue = sqlite3_prepare_v2(database, sql, -1, &count_statement, NULL);
		
		[self bindDBValue:bind statement:count_statement];
		
		if(returnValue == SQLITE_OK)
		{
			while(sqlite3_step(count_statement) == SQLITE_ROW)
			{
				count = sqlite3_column_int(count_statement, 0);
			}
		}
		
		sqlite3_reset(count_statement);
		sqlite3_finalize(count_statement);
		sqlite3_close(database);
		database = nil;
	}
	
	return count;
	
}

- (void) save:(const char *)insert update:(const char *)update{

	if ([self prepareDB]){
		sqlite3_stmt *update_statement;
		

		if (self._id == -1){
			sqlite3_prepare_v2(database, insert, -1, &update_statement, NULL);
		}else{
			sqlite3_prepare_v2(database, update, -1, &update_statement, NULL);
		}
		
		[self createStatementFromObject:update_statement];
		
		int success = sqlite3_step(update_statement);
		
		sqlite3_reset(update_statement);
		sqlite3_finalize(update_statement);

		if (success != SQLITE_DONE) {
			NSLog(@"Nie można dodać danych do bazy danych z powodu: '%s'.", sqlite3_errmsg(database));
		}
		
		sqlite3_close(database);
		database = nil;
	}
}

- (void) deleteFromDatabase:(const char *)deleteSQL bind:(NSArray *)bind{
	
	if ([self prepareDB]){
		sqlite3_stmt *delete_statement;
		sqlite3_prepare_v2(database, deleteSQL, -1, &delete_statement, NULL);
		
		[self bindDBValue:bind statement:delete_statement];
		
		int success = sqlite3_step(delete_statement);
		
		sqlite3_reset(delete_statement);
		sqlite3_finalize(delete_statement);
		sqlite3_close(database);
		database = nil;
		
		if (success != SQLITE_DONE) {
			NSLog(@"Nie można usunąć danych z bazy danych z powodu: '%s'.", sqlite3_errmsg(database));
		}
	}
}

- (void) dealloc {
	database = nil;
	[super dealloc];
}

@end
