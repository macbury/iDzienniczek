//
//  OcenyTableViewController.h
//  iDzienniczek
//
//  Created by MacBury on 08-08-05.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Przedmiot.h"
#import "Oceny.h"
#import "OcenyDetailView.h"
#import "OcenyAddControllerView.h"
#import "ocenaCell.h"
#import "MainTableViewController.h"

@interface OcenyTableViewController : MainTableViewController {
	UIBarButtonItem * addButton;
	
	Przedmiot * przedmiot;
	
	NSMutableArray * pierwszePolrocze;
	NSMutableArray * drugiePolrocze;
	
	OcenyDetailView * ocenyDetailView;
	OcenyAddControllerView * editViewController;
}

@property (nonatomic, retain) Przedmiot * przedmiot;

- (void) beginEditingWithOcena:(Oceny *)ocena isNew:(bool)isNew;

@end
