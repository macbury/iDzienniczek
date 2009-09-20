//
//  Lekcja.m
//  iDzienniczek
//
//  Created by MacBury on 08-08-10.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//


// 

#import "Lekcja.h"

@implementation Lekcja

@synthesize start, czasTrwania, przedmiot, _id, _rok_id, sala, dzien;

- (id) initBlank:(NSInteger)d {
	if (self == [super init]){
		iDzienniczekAppDelegate * appDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
		start = [[NSDateComponents alloc] init];
		[start setHour:8];
		
		czasTrwania = [[NSDateComponents alloc] init];
		[czasTrwania setHour:0];
		[czasTrwania setMinute:45];
		
		przedmiot = nil;
		_id = -1;
		_rok_id = appDelegate.selected_rok.ids;
		sala = @"1";

		dzien = d;
	}
	
	return self;
}

- (void) save {
	iDzienniczekAppDelegate * appDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
	sqlite3 *database;
	
	const char *sql;
	if(_id == -1){
		sql = "INSERT INTO plan_lekcji (przedmiot_id, start, czas_trwania, rok_id, sala, dzien) VALUES (?, ?, ?, ?, ?,?);";
	}else{
		sql = "UPDATE plan_lekcji SET przedmiot_id=?, start=?, czas_trwania=?, rok_id=?, sala=?, dzien=? WHERE id=?";
	}
	
	if(sqlite3_open([appDelegate.userDataBasePath UTF8String], &database) == SQLITE_OK){
		
		sqlite3_stmt *update_statement;
		
		sqlite3_prepare_v2(database, sql, -1, &update_statement, NULL);
		
		sqlite3_bind_int(update_statement, 1, self.przedmiot._id);
		sqlite3_bind_double(update_statement, 2, [[[NSCalendar currentCalendar] dateFromComponents:self.start] timeIntervalSince1970]);
		sqlite3_bind_double(update_statement, 3, [[[NSCalendar currentCalendar] dateFromComponents:self.czasTrwania] timeIntervalSince1970]);
		sqlite3_bind_int(update_statement, 4, self._rok_id);
		sqlite3_bind_text(update_statement, 5, [self.sala UTF8String],-1, SQLITE_TRANSIENT);
		sqlite3_bind_int(update_statement, 6, self.dzien);

		if(_id != -1){
			sqlite3_bind_int(update_statement, 7, self._id);
		}
		
		int success = sqlite3_step(update_statement);
		
		sqlite3_reset(update_statement);
		sqlite3_close(database);
		
		if (success != SQLITE_DONE) {
			NSAssert1(0, @"Nie można dodać danych do bazy danych z powodu: '%s'.", sqlite3_errmsg(database));
		}
		
	}
}

+ (int) countByPrzedmiot:(int)p {
	iDzienniczekAppDelegate * appDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
	sqlite3 *database;
	int count;
	
	if(sqlite3_open([appDelegate.userDataBasePath UTF8String], &database) == SQLITE_OK){
		sqlite3_stmt *selectStatement;
		
		int returnValue = sqlite3_prepare_v2(database, "SELECT count(id) AS count FROM plan_lekcji WHERE przedmiot_id = ?;", -1, &selectStatement, NULL);
		
		
		sqlite3_bind_int(selectStatement, 1, p);
		
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

+ (NSMutableArray *) findBySql:(const char *)sql dzien:(NSInteger)dzien czas:(bool)czas {
	
	iDzienniczekAppDelegate * appDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
	sqlite3 *database;
	
	NSMutableArray * outputArray = [[NSMutableArray alloc] init];
	
	if(sqlite3_open([appDelegate.userDataBasePath UTF8String], &database) == SQLITE_OK){
		sqlite3_stmt *selectStatement;
		
		int returnValue = sqlite3_prepare_v2(database, sql, -1, &selectStatement, NULL);
		
		
		sqlite3_bind_int(selectStatement, 1, appDelegate.selected_rok.ids);
		sqlite3_bind_int(selectStatement, 2, dzien);
		
		if (czas){
			NSDateComponents * dateComponent = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit) 
																			   fromDate:[NSDate date]];
			double teraz = [[[NSCalendar currentCalendar] dateFromComponents:dateComponent] timeIntervalSince1970];
			sqlite3_bind_double(selectStatement, 3, teraz);
		}
		
		if(returnValue == SQLITE_OK)
		{
			while(sqlite3_step(selectStatement) == SQLITE_ROW)
			{
				Lekcja * l = [[[Lekcja alloc] init] autorelease];
				l._id = sqlite3_column_int(selectStatement, 0);
				l._rok_id = sqlite3_column_int(selectStatement, 1);
				l.start = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit) 
														  fromDate:[NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(selectStatement, 2)]];

				l.czasTrwania = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit) 
																fromDate:[NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(selectStatement, 3)]];
				l.przedmiot = [[Przedmiot find:sqlite3_column_int(selectStatement, 4)] objectAtIndex:0];
				l.sala = [NSString stringWithUTF8String: (char *)sqlite3_column_text(selectStatement, 5)];
				l.dzien = sqlite3_column_int(selectStatement, 6);

				[outputArray addObject:l];
				
				
			}
		}
		
		sqlite3_finalize(selectStatement);
	}
	
	sqlite3_close(database);
	
	return outputArray;
}

- (NSString *)stringStart{
	return [[[NSCalendar currentCalendar] dateFromComponents:self.start] descriptionWithCalendarFormat:@"%H:%M" timeZone:nil locale:nil];
}

- (NSDateComponents *)czasTrwania:(NSInteger)add {
	NSDateComponents * czas = [[[NSDateComponents alloc] init] autorelease];
	[czas setHour:[self.start hour] + [self.czasTrwania hour]];
	[czas setMinute:[self.start minute] + [self.czasTrwania minute] + add];
	
	return czas;
}

- (NSString *)stringCzasTrwania{
	return [[[NSCalendar currentCalendar] dateFromComponents:[self czasTrwania:0]] descriptionWithCalendarFormat:@"%H:%M" timeZone:nil locale:nil];
}

+ (void) deleteFromDatabaseByPrzedmiot:(NSInteger)przedmiot {
	iDzienniczekAppDelegate * appDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
	sqlite3 *database;
	
	if(sqlite3_open([appDelegate.userDataBasePath UTF8String], &database) == SQLITE_OK){
		const char *sql = "DELETE FROM plan_lekcji WHERE przedmiot_id = ?;";
		sqlite3_stmt *delete_statement;
		
		sqlite3_prepare_v2(database, sql, -1, &delete_statement, NULL);
		sqlite3_bind_int(delete_statement, 1, przedmiot);
		
		int success = sqlite3_step(delete_statement);
		
		sqlite3_reset(delete_statement);
		sqlite3_close(database);
		
		if (success != SQLITE_DONE) {
			NSAssert1(0, @"Nie można usunąć danych z bazy danych z powodu: '%s'.", sqlite3_errmsg(database));
		}
		
	}
}

- (void) deleteFromDatabase {
	iDzienniczekAppDelegate * appDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
	sqlite3 *database;
	
	if(sqlite3_open([appDelegate.userDataBasePath UTF8String], &database) == SQLITE_OK){
		const char *sql = "DELETE FROM plan_lekcji WHERE id = ?;";
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
}

+ (void) deleteFromDatabaseByRok:(NSInteger)rok {
	iDzienniczekAppDelegate * appDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
	sqlite3 *database;
	
	if(sqlite3_open([appDelegate.userDataBasePath UTF8String], &database) == SQLITE_OK){
		const char *sql = "DELETE FROM plan_lekcji WHERE rok_id = ?;";
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



+ (Przedmiot *) findPrzedmiotByAktualnaLekcja:(NSInteger)dzien {
	NSMutableArray * a = [[Lekcja findBySql:"SELECT id, rok_id, start, czas_trwania, przedmiot_id, sala, dzien FROM plan_lekcji WHERE rok_id = ? AND dzien = ? AND start <= ? ORDER BY start DESC LIMIT 1;" dzien:dzien czas:YES] autorelease];
	if ([a count] == 0){
		return nil;
	}else{
		Lekcja * lekcja = [a objectAtIndex:0];
		return lekcja.przedmiot;
	}	
}

+ (NSMutableArray *) findAllByRokAndDzien:(NSInteger)dzien {
	return [Lekcja findBySql:"SELECT id, rok_id, start, czas_trwania, przedmiot_id, sala, dzien FROM plan_lekcji WHERE rok_id = ? AND dzien = ? ORDER BY start;" dzien:dzien czas:NO];
}

- (void) dealloc {
	[start release];
	[czasTrwania release];
	
	if (przedmiot != nil){
		[przedmiot release];
	}
	
	[super dealloc];
}

@end
