//
//  Rok.h
//  iDzienniczek
//
//  Created by MacBury on 08-08-01.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "iDzienniczekAppDelegate.h"
#import "Przedmiot.h"
#import "Lekcja.h"
#import "Prace.h"

@interface Rok : NSObject {
	NSDate * start;
	NSDate * koniec;
	NSDate * polrocze;
	NSInteger ids;
}
- (id)initWithToday;
- (id)initWithStart:(NSDate *)s koniec:(NSDate *)k polrocze:(NSDate *)p id:(NSInteger)i;

- (NSString *) getStartRok;
- (NSString *) getKoniecRok;

- (void) deleteFromDatabase;
- (void) save;

+ (NSMutableArray *) findAll:(NSInteger)rok;

@property (copy, nonatomic) NSDate * start;
@property (copy, nonatomic) NSDate * koniec;
@property (copy, nonatomic) NSDate * polrocze;
@property (assign, nonatomic) NSInteger ids;

@end
