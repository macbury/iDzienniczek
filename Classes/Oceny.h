//
//  Oceny.h
//  iDzienniczek
//
//  Created by MacBury on 08-08-05.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Przedmiot.h"

@interface Oceny : NSObject {
	NSInteger _id;
	NSInteger _przedmiot_id;
	
	NSInteger ocena;
	NSInteger zaco;
	
	NSDate * dodano;
	NSString * notatka;
}

@property (nonatomic, retain) NSString * notatka;
@property (nonatomic, retain) NSDate * dodano;

@property (nonatomic, assign) NSInteger ocena;
@property (nonatomic, assign) NSInteger zaco;

+ (NSMutableArray *) findAllByPrzedmiot:(Przedmiot *)p;
+ (NSMutableArray *)findAllByPrzedmiotAndPolrocze:(Przedmiot *)p polrocze:(int)polrocze;
+ (NSMutableArray *)findBySql:(const char *)sql przedmiot:(Przedmiot *)przedmiot polrocze:(bool)polrocze;
+ (NSArray *) zaCoArray;
+ (void) deleteAllFromDatabaseByPrzedmiot:(int)przedmiot;

- (void) deleteFromDatabase;
- (id) initBlankWithPrzedmiot:(Przedmiot *)p;
- (void) save;

- (NSString *) ocenaSlownie;
- (NSString *) zaCoSlownie;
@end
