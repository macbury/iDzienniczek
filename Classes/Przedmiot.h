//
//  Przedmiot.h
//  iDzienniczek
//
//  Created by MacBury on 08-08-04.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "iDzienniczekAppDelegate.h"


@interface Przedmiot : NSObject {
	NSString * nazwa;
	bool wliczaSieDoSredniej;
	
	NSInteger nauczyciel_id;
	NSInteger rok_id;
	NSInteger _id;
}
@property (nonatomic, retain) NSString * nazwa;
@property (nonatomic, assign) bool wliczaSieDoSredniej;
@property (assign, nonatomic) NSInteger _id;
@property (assign, nonatomic) NSInteger nauczyciel_id;

+ (NSMutableArray *)findAllByRok;
+ (NSMutableArray *)find:(NSInteger)pid;
+ (Przedmiot *) findFirstByRok;
+ (int) countByRok:(int)r;
+ (NSMutableArray *)findBySql:(const char *)sql id:(NSInteger)bind;
+ (void) deleteAllFromDatabaseByRok:(int)rok;
+ (void) deleteAllFromDatabaseWithOcenyByRok:(int)rok;
- (int) countOcenyByPrzedmiot;
- (id) initWithNazwa:(NSString *)n id:(NSInteger)i srednia:(bool)s rok_id:(NSInteger)r_id;
- (id) initBlank;
- (int) lekcjiWTygodniu;
- (void) save;
- (void) deleteFromDatabase;
- (double) srednia:(int)polrocze;
@end
