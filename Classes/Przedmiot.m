//
//  Przedmiot.m
//  iDzienniczek
//
//  Created by MacBury on 08-08-04.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Przedmiot.h"
#import "Oceny.h"
#import "Rok.h"
@implementation Przedmiot

@synthesize nazwa, wliczaSieDoSredniej, _id,nauczyciel_id;

- (id) initBlank {
	if (self == [super init]){
		iDzienniczekAppDelegate * appDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];

		rok_id = appDelegate.selected_rok.ids;
		_id = -1;
		nauczyciel_id = -1;
		self.wliczaSieDoSredniej = YES;
	}
	
	return self;
}

- (id) initWithNazwa:(NSString *)n id:(NSInteger)i srednia:(bool)s rok_id:(NSInteger)r_id {
	if (self == [super init]){
		self.nazwa = n;
		self.wliczaSieDoSredniej = s;
		rok_id = r_id;
		_id = i;
	}
	
	return self;
}

- (int) lekcjiWTygodniu {
	return [Lekcja countByPrzedmiot: self._id];
}

+ (int) countByRok:(int)r {
	iDzienniczekAppDelegate * appDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
	sqlite3 *database;
	int count;
	
	if(sqlite3_open([appDelegate.userDataBasePath UTF8String], &database) == SQLITE_OK){
		sqlite3_stmt *selectStatement;
		
		int returnValue = sqlite3_prepare_v2(database, "SELECT count(id) AS count FROM przedmioty WHERE rok_id = ?;", -1, &selectStatement, NULL);
		
		
		sqlite3_bind_int(selectStatement, 1, r);
		
		if(returnValue == SQLITE_OK)
		{
			while(sqlite3_step(selectStatement) == SQLITE_ROW)
			{
				count = sqlite3_column_int(selectStatement, 0);
			}
		}
		
		sqlite3_finalize(selectStatement);
	}
	
	sqlite3_close(database);
	
	return count;
	
}

+ (NSMutableArray *)findBySql:(const char *)sql id:(NSInteger)bind{
	iDzienniczekAppDelegate * appDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
	sqlite3 *database;
	
	NSMutableArray * outputArray = [[NSMutableArray alloc] init];
	
	if(sqlite3_open([appDelegate.userDataBasePath UTF8String], &database) == SQLITE_OK){
		sqlite3_stmt *selectStatement;
		
		int returnValue = sqlite3_prepare_v2(database, sql, -1, &selectStatement, NULL);
		
		if (bind != -1){
			sqlite3_bind_int(selectStatement, 1, bind);
		}
		if(returnValue == SQLITE_OK)
		{
			while(sqlite3_step(selectStatement) == SQLITE_ROW)
			{
				Przedmiot * p = [[[Przedmiot alloc] initWithNazwa:[NSString stringWithUTF8String: (char *)sqlite3_column_text(selectStatement, 2)]
															  id:sqlite3_column_int(selectStatement, 0)
														 srednia:sqlite3_column_int(selectStatement, 3) 
														  rok_id:sqlite3_column_int(selectStatement, 1)] autorelease];
				p.nauczyciel_id = sqlite3_column_int(selectStatement, 4);
				[outputArray addObject:p];
				
				
			}
		}
		
		sqlite3_finalize(selectStatement);
	}
	
	sqlite3_close(database);
	
	return outputArray;
}

+ (NSMutableArray *) findAllByRok {
	iDzienniczekAppDelegate * appDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
	return [Przedmiot findBySql:"SELECT id, rok_id, nazwa, wliczaSieDoSredniej,kontakt_id FROM przedmioty WHERE rok_id = ?;" id:appDelegate.selected_rok.ids];
}

+ (Przedmiot *) findFirstByRok {
	iDzienniczekAppDelegate * appDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSMutableArray * p = [[Przedmiot findBySql:"SELECT id, rok_id, nazwa, wliczaSieDoSredniej,kontakt_id FROM przedmioty LIMIT 0, 1;" id:appDelegate.selected_rok.ids] autorelease];
	
	return [p objectAtIndex:0];
}

+ (NSMutableArray *)find:(NSInteger)pid {
	return [Przedmiot findBySql:"SELECT id, rok_id, nazwa, wliczaSieDoSredniej,kontakt_id FROM przedmioty WHERE id = ? LIMIT 0,1;" id:pid];
}

+ (void) deleteAllFromDatabaseWithOcenyByRok:(int)rok {

	NSMutableArray * przedmioty = [Przedmiot findBySql:"SELECT id, rok_id, nazwa, wliczaSieDoSredniej,kontakt_id FROM przedmioty WHERE rok_id = ? LIMIT 0, 1;" id:rok];
	for (Przedmiot * przedmiot in przedmioty){
		[Oceny deleteAllFromDatabaseByPrzedmiot:przedmiot._id];
	}

	[przedmioty removeAllObjects];
	[przedmioty release];
	[Przedmiot deleteAllFromDatabaseByRok:rok];
} 

- (int) countOcenyByPrzedmiot {
	iDzienniczekAppDelegate * appDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
	sqlite3 *database;
	int count;
	
	if(sqlite3_open([appDelegate.userDataBasePath UTF8String], &database) == SQLITE_OK){
		sqlite3_stmt *selectStatement;
		
		int returnValue = sqlite3_prepare_v2(database, "SELECT count(id) AS count FROM oceny WHERE przedmiot_id = ?;", -1, &selectStatement, NULL);
		
		
		sqlite3_bind_int(selectStatement, 1, self._id);
		
		if(returnValue == SQLITE_OK)
		{
			while(sqlite3_step(selectStatement) == SQLITE_ROW)
			{
				count = sqlite3_column_int(selectStatement, 0);
			}
		}
		
		sqlite3_finalize(selectStatement);
	}
	
	sqlite3_close(database);
	
	return count;
	
}

- (double) srednia:(int)polrocze {
	iDzienniczekAppDelegate * appDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
	sqlite3 *database;
	double count;
	
	NSString *sql = @"SELECT AVG(ocena) AS srednia FROM oceny WHERE przedmiot_id = ? AND dodano";
	if (polrocze == 0){
		sql = [sql stringByAppendingString:@" < ?;"];
	}else{
		sql = [sql stringByAppendingString:@" > ?;"];
	}
	
	if(sqlite3_open([appDelegate.userDataBasePath UTF8String], &database) == SQLITE_OK){
		sqlite3_stmt *selectStatement;
		
		int returnValue = sqlite3_prepare_v2(database, [sql UTF8String], -1, &selectStatement, NULL);
		
		
		sqlite3_bind_int(selectStatement, 1, self._id);
		sqlite3_bind_double(selectStatement, 2, [appDelegate.selected_rok.polrocze timeIntervalSince1970]);
		
		if(returnValue == SQLITE_OK)
		{
			while(sqlite3_step(selectStatement) == SQLITE_ROW)
			{
				count = sqlite3_column_double(selectStatement, 0);
			}
		}
		
		sqlite3_finalize(selectStatement);
	}
	
	sqlite3_close(database);
	
	return count;
	
}

- (void) save {
	iDzienniczekAppDelegate * appDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
	sqlite3 *database;
	
	const char *sql;
	if(_id == -1){
		sql = "INSERT INTO przedmioty (nazwa, wliczaSieDoSredniej, rok_id,kontakt_id) VALUES (?, ?, ?, ?);";
	}else{
		sql = "UPDATE przedmioty SET nazwa=?, wliczaSieDoSredniej=?, rok_id=?, kontakt_id = ? WHERE id=?";
	}
	
	if(sqlite3_open([appDelegate.userDataBasePath UTF8String], &database) == SQLITE_OK){
		
		sqlite3_stmt *update_statement;
		
		sqlite3_prepare_v2(database, sql, -1, &update_statement, NULL);
		
		sqlite3_bind_text(update_statement, 1, [self.nazwa UTF8String],-1, SQLITE_TRANSIENT);
		sqlite3_bind_int(update_statement, 2, self.wliczaSieDoSredniej);
		sqlite3_bind_int(update_statement, 3, rok_id);
		sqlite3_bind_int(update_statement, 4, nauczyciel_id);
		if(_id != -1){
			sqlite3_bind_int(update_statement, 5, _id);
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
		const char *sql = "DELETE FROM przedmioty WHERE id = ?;";
		sqlite3_stmt *delete_statement;
		
		sqlite3_prepare_v2(database, sql, -1, &delete_statement, NULL);
		sqlite3_bind_int(delete_statement, 1, _id);
		
		int success = sqlite3_step(delete_statement);
		
		sqlite3_reset(delete_statement);
		sqlite3_close(database);
		
		if (success != SQLITE_DONE) {
			NSAssert1(0, @"Nie można usunąć danych z bazy danych z powodu: '%s'.", sqlite3_errmsg(database));
		}
	}
	
	[Lekcja deleteFromDatabaseByPrzedmiot:self._id];
	[Oceny deleteAllFromDatabaseByPrzedmiot:self._id];
}

+ (void) deleteAllFromDatabaseByRok:(int)rok {
	iDzienniczekAppDelegate * appDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
	sqlite3 *database;

	if(sqlite3_open([appDelegate.userDataBasePath UTF8String], &database) == SQLITE_OK){
		const char *sql = "DELETE FROM przedmioty WHERE rok_id = ?;";
		sqlite3_stmt *delete_statement;
		
		sqlite3_prepare_v2(database, sql, -1, &delete_statement, NULL);
		sqlite3_bind_int(delete_statement, 1, rok);
		
		int success = sqlite3_step(delete_statement);
		
		sqlite3_reset(delete_statement);
		sqlite3_close(database);
		
		if (success != SQLITE_DONE) {
			NSAssert1(0, @"Nie można usunąć danych z bazy danych z powodu: '%s'.", sqlite3_errmsg(database));
		}
		
	}
}

- (void) dealloc {

	[nazwa release];
	[super dealloc];
}

@end
