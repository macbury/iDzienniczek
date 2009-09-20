//
//  dzienTygodniaViewController.h
//  iDzienniczek
//
//  Created by MacBury on 08-08-10.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DzienTygodniaCell.h"
#import "LekcjaEditViewController.h"
#import "Lekcja.h"
#import "Przedmiot.h"
#import "Rok.h"
#define sNew 0
#define sDetail 1
#define sEdit 2

@interface dzienTygodniaViewController : UITableViewController {
	UIBarButtonItem * addButton;
	LekcjaEditViewController * editController;
	UINavigationController * navController;
	
	NSMutableArray * lekcjeArray;
	NSInteger dzien;
}

@property (nonatomic, assign) NSInteger dzien;

- (IBAction) add:(id)sender;
- (void) beginEditingWith:(Lekcja *)lekcja isNew:(bool)isNew;



@end
