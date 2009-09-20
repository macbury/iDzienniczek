//
//  Prace.m
//  iDzienniczek
//
//  Created by MacBury on 08-09-03.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Prace.h"


@implementation Prace

@synthesize nazwa, opis, wykonany, piorytet, koniec, rok_id;

- (id) init {
	if(self == [super init]) {
		iDzienniczekAppDelegate * app = [Model getAppDelegate];
		self.opis = @"";
		self.wykonany = false;
		self.piorytet = 0;
		self.rok_id = app.selected_rok.ids;
		self.koniec = [NSDate date];
	}
	
	return self;
}

+ (NSMutableArray *) findAll {
	iDzienniczekAppDelegate * app = [Model getAppDelegate];
	
	Prace * p = [[[Prace alloc] init] autorelease];
	return [p findBySql:"SELECT id, nazwa, opis, wykonany, piorytet, koniec, rok_id FROM prace WHERE rok_id = ?;" id:[NSArray arrayWithObjects:[[NSNumber alloc] initWithInt:app.selected_rok.ids], nil]];
}

+ (NSMutableArray *) findByWykonane:(int)wykonane {
	iDzienniczekAppDelegate * app = [Model getAppDelegate];
	
	Prace * p = [[[Prace alloc] init] autorelease];
	return [p findBySql:"SELECT id, nazwa, opis, wykonany, piorytet, koniec, rok_id FROM prace WHERE rok_id = ? AND wykonany = ? ORDER BY koniec DESC;" id:[NSArray arrayWithObjects:[[NSNumber alloc] initWithInt:app.selected_rok.ids], [[NSNumber alloc] initWithInt:wykonane], nil]];
}

- (void) createStatementFromObject:(sqlite3_stmt *)update_statement {
	sqlite3_bind_text(update_statement, 1, [self.nazwa UTF8String],-1, SQLITE_TRANSIENT);
	sqlite3_bind_int(update_statement, 2, self.wykonany);
	sqlite3_bind_text(update_statement, 3, [self.opis UTF8String],-1, SQLITE_TRANSIENT);
	sqlite3_bind_int(update_statement, 4, self.piorytet);
	sqlite3_bind_double(update_statement, 5, [self.koniec timeIntervalSince1970]);
	sqlite3_bind_int(update_statement, 6, self.rok_id);
	
	if(self._id != -1){
		sqlite3_bind_int(update_statement, 7, self._id);
	}
}

- (void)save {
	[self save:"INSERT INTO prace (nazwa, wykonany, opis, piorytet, koniec, rok_id) VALUES (?, ?, ?,?,?,?);"
		update:"UPDATE prace SET nazwa=?, wykonany=?, opis=?, piorytet=?, koniec=?, rok_id=? WHERE id=?;"];
}

+ (int) countZrobione {
	Prace * p = [[Prace alloc] init];
	iDzienniczekAppDelegate * app = [self getAppDelegate];

	int count = [p count:"SELECT count(id) AS count FROM prace WHERE rok_id = ? AND wykonany = ?;" 
					bind:[NSArray arrayWithObjects:[[NSNumber alloc] initWithInt:app.selected_rok.ids],[[NSNumber alloc] initWithInt:0],nil]];
	[p release];
	return count;
}

- (id) createObjectFromStatement:(sqlite3_stmt *)selectStatement {
	Prace * praca = [[[Prace alloc] init] autorelease];
	
	praca._id = sqlite3_column_int(selectStatement, 0);
	praca.nazwa = [NSString stringWithUTF8String: (char *)sqlite3_column_text(selectStatement, 1)];
	praca.opis = [NSString stringWithUTF8String: (char *)sqlite3_column_text(selectStatement, 2)];
	praca.wykonany = sqlite3_column_int(selectStatement, 3);
	praca.piorytet = sqlite3_column_int(selectStatement, 4);
	praca.koniec = [NSDate dateWithTimeIntervalSince1970: sqlite3_column_double(selectStatement,5)];
	praca.rok_id = sqlite3_column_int(selectStatement, 6);
	
	return praca;
}

- (void) deleteFromDatabase {
	[self deleteFromDatabase:"DELETE FROM prace WHERE id = ?;"
						bind:[NSArray arrayWithObjects:[[NSNumber alloc] initWithInt:self._id],nil]];
}

+ (void) deleteAllByRok:(int)rok {
	Prace * p = [[Prace alloc] init];
	[p deleteFromDatabase:"DELETE FROM prace WHERE rok_id = ?;"
						bind:[NSArray arrayWithObjects:[[NSNumber alloc] initWithInt:rok],nil]];
	[p release];
}

- (void) dealloc {
	//[nazwa release];
	//[opis release];
	//[koniec release];
	[super dealloc];
}

@end