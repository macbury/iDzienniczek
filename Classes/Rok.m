//
//  Rok.m
//  iDzienniczek
//
//  Created by MacBury on 08-08-01.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Rok.h"


@implementation Rok

@synthesize ids, start, koniec, polrocze;

- (id)initWithToday {
	if ( self = [super init] ) {
		self.start = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
		self.koniec = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
		self.polrocze = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
		self.ids = -1;
	}
	
	return self;
}

- (id)initWithStart:(NSDate *)s koniec:(NSDate *)k polrocze:(NSDate *)p id:(NSInteger)i {
	
	if ( self = [super init] ) {
		self.ids = i;
		self.start = s;
		self.koniec = k;
		self.polrocze = p;
	}
	
	return self;
	
}

- (NSString *) getStartRok{
	return [start descriptionWithCalendarFormat:@"%Y" timeZone:nil locale:nil];
}

- (NSString *) getKoniecRok{
	return [koniec descriptionWithCalendarFormat:@"%Y" timeZone:nil locale:nil];
}

- (void) save {
	iDzienniczekAppDelegate * appDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
	sqlite3 *database;
	
	const char *sql;
	if(ids == -1){
		sql = "INSERT INTO rok_szkolny (start, koniec, polrocze) VALUES (?, ?, ?);";
	}else{
		sql = "UPDATE rok_szkolny SET start=?, koniec=?, polrocze=? WHERE id=?";
	}
	
	if(sqlite3_open([appDelegate.userDataBasePath UTF8String], &database) == SQLITE_OK){
		
		sqlite3_stmt *update_statement;
		
		sqlite3_prepare_v2(database, sql, -1, &update_statement, NULL);
		
		sqlite3_bind_double(update_statement, 1, [self.start timeIntervalSince1970]);
		sqlite3_bind_double(update_statement, 2, [self.koniec timeIntervalSince1970]);
		sqlite3_bind_double(update_statement, 3, [self.polrocze timeIntervalSince1970]);
		if(ids != -1){
			sqlite3_bind_int(update_statement, 4, self.ids);
		}
		
		int success = sqlite3_step(update_statement);
		
		sqlite3_reset(update_statement);
		sqlite3_close(database);
		
		if (success != SQLITE_DONE) {
			NSAssert1(0, @"Nie można dodać danych do bazy danych z powodu: '%s'.", sqlite3_errmsg(database));
		}
		
	}
}

- (void) deleteFromDatabase {
	iDzienniczekAppDelegate * appDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
	sqlite3 *database;

	if(sqlite3_open([appDelegate.userDataBasePath UTF8String], &database) == SQLITE_OK){
		const char *sql = "DELETE FROM rok_szkolny WHERE id = ?;";
		sqlite3_stmt *delete_statement;
		
		sqlite3_prepare_v2(database, sql, -1, &delete_statement, NULL);
		sqlite3_bind_int(delete_statement, 1, self.ids);
		
		int success = sqlite3_step(delete_statement);
		
		sqlite3_reset(delete_statement);
		sqlite3_close(database);
		

		
		if (success != SQLITE_DONE) {
			NSAssert1(0, @"Nie można usunąć danych z bazy danych z powodu: '%s'.", sqlite3_errmsg(database));
		}
		
	}
	[Prace deleteAllByRok:self.ids];
	[Lekcja deleteFromDatabaseByRok:self.ids];
	[Przedmiot deleteAllFromDatabaseWithOcenyByRok:self.ids];
}

+ (NSMutableArray *) findAll:(NSInteger)rok {
	iDzienniczekAppDelegate * appDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
	sqlite3 *database;
	
	NSMutableArray * outputArray = [[NSMutableArray alloc] init];
	const char *sql;
	
	if (rok == -1){
		sql = "SELECT id, start, koniec, polrocze FROM rok_szkolny;";
	}else{
		sql = "SELECT id, start, koniec, polrocze FROM rok_szkolny WHERE id = ?;";
	}
	
	if(sqlite3_open([appDelegate.userDataBasePath UTF8String], &database) == SQLITE_OK){
		
		sqlite3_stmt *selectStatement;
		
		int returnValue = sqlite3_prepare_v2(database, sql, -1, &selectStatement, NULL);
		if (rok != -1){
			sqlite3_bind_int(selectStatement, 1, rok);
		}
		if(returnValue == SQLITE_OK)
		{
			while(sqlite3_step(selectStatement) == SQLITE_ROW)
			{
				
				Rok * r = [[[Rok alloc] initWithStart:[NSDate dateWithTimeIntervalSince1970: sqlite3_column_double(selectStatement,1)]
											   koniec:[NSDate dateWithTimeIntervalSince1970: sqlite3_column_double(selectStatement,2)]
											 polrocze:[NSDate dateWithTimeIntervalSince1970: sqlite3_column_double(selectStatement,3)]
												   id: sqlite3_column_int(selectStatement, 0)] autorelease];
				[outputArray addObject:r];
			}
		}
		//Release the select statement memory
		sqlite3_finalize(selectStatement);
	}
	
	sqlite3_close(database);
	
	return outputArray;
}

- (void)dealloc {
	[self.start release];
	[self.koniec release];
	[self.polrocze release];
	[super dealloc];
}

@end
