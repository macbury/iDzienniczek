//
//  Migration.m
//  iDzienniczek
//
//  Created by MacBury on 08-09-24.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Migration.h"


@implementation Migration

- (id) initWithShemaVersion:(int)version {
	self = [super init];
	shemaVersion = version;
	
	return self;
}

- (const char *) prepareMigrateSQL {
	NSString * sql = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"migrate" ofType:@"idm"]];
	
	return [sql UTF8String];
}

- (void)migrate {
	if ([self shouldMigrate]){
		NSLog(@"Aktualizuję bazę");
		
		if ([self prepareDB]){
			//sqlite3_stmt *mig;
			//sqlite3_prepare_v2(database, [self prepareMigrateSQL], -1, &mig, NULL);
			
			sqlite3_exec(database, [self prepareMigrateSQL], NULL, NULL, NULL);
			
			//int success = 0;
			
			//while (sqlite3_step(mig) == SQLITE_BUSY){
				
			//}
			
			//sqlite3_reset(mig);
			//sqlite3_finalize(mig);
			//sqlite3_close(database);
			//database = nil;
			NSLog(@"Nie można wykonać migracji danych: '%s'.", sqlite3_errmsg(database));
			//if (success != SQLITE_DONE) {
			//	NSLog(@"Nie można wykonać migracji danych: '%s'.", sqlite3_errmsg(database));
			//	exit(0);
			//}
		}else{
			exit(0);
		}
	}else{
		NSLog(@"Walę aktualizację");
	}
}

- (bool)shouldMigrate {
	bool migrate = YES;
	
	if ([self prepareDB]){
		sqlite3_stmt *selectStatement;
		
		int returnValue = sqlite3_prepare_v2(database, "SELECT * FROM shema LIMIT 1;", -1, &selectStatement, NULL);
		
		if(returnValue == SQLITE_OK)
		{
			while(sqlite3_step(selectStatement) == SQLITE_ROW)
			{
				int db_version = sqlite3_column_int(selectStatement, 0);
				if (db_version == shemaVersion){
					migrate = NO;
				}
			}
		}
		
		sqlite3_reset(selectStatement);
		sqlite3_finalize(selectStatement);

	}
	
	return migrate;
}

- (void) dealloc {
	[super dealloc];
	sqlite3_close(database);
	database = nil;
}

@end
