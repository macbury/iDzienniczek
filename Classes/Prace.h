//
//  Prace.h
//  iDzienniczek
//
//  Created by MacBury on 08-09-03.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"
#import "Rok.h"

@interface Prace : Model {
	NSString * nazwa;
	NSString * opis;
	
	bool wykonany;
	
	NSDate * koniec;
	
	NSInteger piorytet;
	NSInteger rok_id;
}

@property (nonatomic, retain) NSString * nazwa;
@property (nonatomic, retain) NSString * opis;
@property (nonatomic, retain) NSDate * koniec;

@property (nonatomic, assign) bool wykonany;
@property (nonatomic, assign) NSInteger piorytet;
@property (nonatomic, assign) NSInteger rok_id;

+ (int) countZrobione;
+ (NSMutableArray *) findAll;
+ (NSMutableArray *) findByWykonane:(int)wykonane;
+ (void) deleteAllByRok:(int)rok;
- (void)save;
- (void) deleteFromDatabase;
@end
