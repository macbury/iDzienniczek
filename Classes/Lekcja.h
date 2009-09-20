//
//  Lekcja.h
//  iDzienniczek
//
//  Created by MacBury on 08-08-10.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Przedmiot.h"
#import "Rok.h"

@interface Lekcja : NSObject {
	Przedmiot * przedmiot;
	NSInteger _id;
	NSInteger _rok_id;
	NSString * sala;
	NSDateComponents * start;
	NSDateComponents * czasTrwania;
	
	NSInteger dzien;
}

@property (nonatomic, retain) Przedmiot * przedmiot;
@property (nonatomic, retain) NSDateComponents * start;
@property (nonatomic, retain) NSDateComponents * czasTrwania;
@property (nonatomic, retain) NSString * sala;

@property (nonatomic, assign) NSInteger _id;
@property (nonatomic, assign) NSInteger _rok_id;

@property (nonatomic, assign) NSInteger dzien;

+ (NSMutableArray *) findAllByRokAndDzien:(NSInteger)dzien;
+ (Przedmiot *) findPrzedmiotByAktualnaLekcja:(NSInteger)dzien;
+ (NSMutableArray *) findBySql:(const char *)sql dzien:(NSInteger)dzien czas:(bool)czas;
+ (void) deleteFromDatabaseByRok:(NSInteger)rok;
+ (void) deleteFromDatabaseByPrzedmiot:(NSInteger)przedmiot;

- (id) initBlank:(NSInteger)dzien;
- (void) save;
- (void) deleteFromDatabase;

+ (int) countByPrzedmiot:(int)p;

- (NSString *)stringStart;
- (NSString *)stringCzasTrwania;
- (NSDateComponents *)czasTrwania:(NSInteger)add;
@end
