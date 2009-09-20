//
//  Oceny.m
//  iDzienniczek
//
//  Created by MacBury on 08-08-05.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Oceny.h"
#import "Rok.h"

@implementation Oceny

@synthesize ocena, zaco, notatka, dodano;

- (id) initBlankWithPrzedmiot:(Przedmiot *)p {
	if (self == [super init]){
		_przedmiot_id = p._id;
		_id = -1;
		self.zaco = 0;
		self.ocena = 5;
		self.dodano = [NSDate date];
	}
	
	return self;
}

- (id) initWithId:(NSInteger)i przedmiot:(NSInteger)pi ocena:(NSInteger)o zaco:(NSInteger)z dodano:(NSDate *)d notatka:(NSString *)n{
	if (self == [super init]){
		_przedmiot_id = pi;
		_id = i;
		self.zaco = z;
		self.ocena = o;
		self.dodano = d;
		self.notatka = n;
	}
	
	return self;
}

+ (NSMutableArray *)findBySql:(const char *)sql przedmiot:(Przedmiot *)przedmiot polrocze:(bool)polrocze{
	iDzienniczekAppDelegate * appDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
	sqlite3 *database;
	
	NSMutableArray * outputArray = [[NSMutableArray alloc] init];
	
	if(sqlite3_open([appDelegate.userDataBasePath UTF8String], &database) == SQLITE_OK){
		sqlite3_stmt *selectStatement;
		
		int returnValue = sqlite3_prepare_v2(database, sql, -1, &selectStatement, NULL);
		
		if (przedmiot != nil){
			sqlite3_bind_int(selectStatement, 1, przedmiot._id);
		}
		
		if (polrocze){
			sqlite3_bind_double(selectStatement, 2, [appDelegate.selected_rok.polrocze timeIntervalSince1970]);
		}
		
		
		if(returnValue == SQLITE_OK)
		{
			while(sqlite3_step(selectStatement) == SQLITE_ROW)
			{
				Oceny * o = [[Oceny alloc] initWithId:sqlite3_column_int(selectStatement, 0)
											 przedmiot:sqlite3_column_int(selectStatement, 1)
												 ocena:sqlite3_column_int(selectStatement, 2)
												  zaco:sqlite3_column_int(selectStatement, 4)
												dodano:[NSDate dateWithTimeIntervalSince1970: sqlite3_column_double(selectStatement,3)]
											   notatka:[NSString stringWithUTF8String: (char *)sqlite3_column_text(selectStatement, 5)]];
				[o autorelease];
				[outputArray addObject:o];
			}
		}
		
		sqlite3_finalize(selectStatement);
	}
	
	sqlite3_close(database);
	
	return outputArray;
}

- (void) deleteFromDatabase {
	iDzienniczekAppDelegate * appDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
	sqlite3 *database;
	
	if(sqlite3_open([appDelegate.userDataBasePath UTF8String], &database) == SQLITE_OK){
		const char *sql = "DELETE FROM oceny WHERE id = ?;";
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

+ (void) deleteAllFromDatabaseByPrzedmiot:(int)przedmiot {
	iDzienniczekAppDelegate * appDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
	sqlite3 *database;
	
	if(sqlite3_open([appDelegate.userDataBasePath UTF8String], &database) == SQLITE_OK){
		const char *sql = "DELETE FROM oceny WHERE przedmiot_id = ?;";
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

+ (NSMutableArray *)findAllByPrzedmiotAndPolrocze:(Przedmiot *)p polrocze:(int)polrocze {
	NSString *sql = @"SELECT id, przedmiot_id, ocena, dodano, zaco, notatka FROM oceny WHERE przedmiot_id = ? AND dodano";
	if (polrocze == 0){
		sql = [sql stringByAppendingString:@" < ? "];
	}else{
		sql = [sql stringByAppendingString:@" > ? "];
	}

	sql = [sql stringByAppendingString:@"ORDER BY dodano;"];
	return [Oceny findBySql: [sql UTF8String] przedmiot:p polrocze:YES];
}

+ (NSMutableArray *) findAllByPrzedmiot:(Przedmiot *)p {
	return [Oceny findBySql:"SELECT id, przedmiot_id, ocena, dodano, zaco, notatka FROM oceny WHERE przedmiot_id = ? ORDER BY dodano;" przedmiot:p polrocze:NO];
}

- (NSString *)ocenaSlownie {
	switch (self.ocena) {
		case 1:
			return @"Niedostateczny";
		break;
		case 2:
			return @"Dopuszcający";
		break;
		case 3:
			return @"Dostateczny";
		break;
		case 4:
			return @"Dobry";
		break;
		case 5:
			return @"Bardzo Dobry";
		break;
		case 6:
			return @"Celujący";
		break;
		default:
			return @"Nieznana";
		break;
	}
	
	return @"Nieznana";
}

- (NSString *)zaCoSlownie {
	switch (self.zaco) {
		case 0:
			return @"Sprawdzian";
			break;
		case 1:
			return @"Test";
			break;
		case 2:
			return @"Kartkówka";
			break;
		case 3:
			return @"Odpowiedź";
			break;
		case 4:
			return @"Praca domowa";
			break;
		case 5:
			return @"Praca dodatkowa";
		break;
		case 6:
			return @"Praca na lekcji";
		break;
		case 7:
			return @"Wypracowanie";
		break;
		case 8:
			return @"Projekt";
		break;
		case 9:
			return @"Łapówka";
		break;
	}
	
	return @"Nieznana";
}

+ (NSArray *) zaCoArray {
	return [[NSArray alloc] initWithObjects:@"Sprawdzian", @"Test", @"Kartkówka", @"Odpowiedź", @"Praca domowa", @"Praca dodatkowa",@"Praca na lekcji",@"Wypracowanie", @"Projekt",@"Łapówka", nil];
}

- (void) save {
	iDzienniczekAppDelegate * appDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
	sqlite3 *database;
	
	const char *sql;
	if(_id == -1){
		sql = "INSERT INTO oceny (przedmiot_id, ocena, dodano, zaco, notatka) VALUES (?, ?, ?, ?, ?);";
	}else{
		sql = "UPDATE oceny SET przedmiot_id=?, ocena=?, dodano=?, zaco=?, notatka=? WHERE id=?";
	}
	
	if(sqlite3_open([appDelegate.userDataBasePath UTF8String], &database) == SQLITE_OK){
		
		sqlite3_stmt *update_statement;
		
		sqlite3_prepare_v2(database, sql, -1, &update_statement, NULL);
		
		sqlite3_bind_int(update_statement, 1, _przedmiot_id);
		sqlite3_bind_int(update_statement, 2, self.ocena);
		sqlite3_bind_double(update_statement, 3, [self.dodano timeIntervalSince1970]);
		sqlite3_bind_int(update_statement, 4, self.zaco);
		
		if(self.notatka == nil){
			self.notatka = @"";
		}
		
		sqlite3_bind_text(update_statement, 5, [self.notatka UTF8String],-1, SQLITE_TRANSIENT);
		
		if(_id != -1){
			sqlite3_bind_int(update_statement, 6, _id);
		}
		
		int success = sqlite3_step(update_statement);
		
		sqlite3_reset(update_statement);
		sqlite3_close(database);
		
		if (success != SQLITE_DONE) {
			NSAssert1(0, @"Nie można dodać danych do bazy danych z powodu: '%s'.", sqlite3_errmsg(database));
		}
		
	}
}

- (void) dealloc {
	[super dealloc];
}

@end
