//
//  PrzedmiotyTableViewController.h
//  iDzienniczek
//
//  Created by MacBury on 08-08-03.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Przedmiot.h"
#import "PrzedmiotyEditViewController.h"
#import "PrzedmiotDetailView.h"
#import "OcenyTableViewController.h"
#import "Lekcja.h"
#import "MainTableViewController.h"
#import "SredniaViewController.h"

@interface PrzedmiotyTableViewController : MainTableViewController {
	UIBarButtonItem * addButton;
	
	NSMutableArray * przedmioty;
	
	OcenyTableViewController * ocenyTableViewController;
	PrzedmiotDetailView * detailView;
	PrzedmiotyEditViewController * editViewController;
}

- (IBAction) addPrzedmiot:(id)sender;
- (void) beginEditingWithPrzedmiot:(Przedmiot *)p isEditing:(bool)isEditing;
@end
