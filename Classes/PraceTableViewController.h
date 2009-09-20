//
//  PraceTableViewController.h
//  iDzienniczek
//
//  Created by MacBury on 08-09-01.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTableViewController.h"
#import "Prace.h"
#import "PraceEditTableViewController.h"
#import "PraceDetailView.h"
#import "DetailCell.h"

@interface PraceTableViewController : MainTableViewController {	
	NSMutableDictionary * praceList;
	NSArray * sortedPrace;
	NSDateFormatter * dateFormatter;
	PraceEditTableViewController * editViewController;
	PraceDetailView * praceDetailView;
	IBOutlet UISegmentedControl * segemnty;
	NSDate * dzisiaj;
	NSMutableArray * piorytetImage;
}

- (IBAction) zmienSegment:(id)sender;

@property (nonatomic, retain) NSArray * sortedPrace;
@property (nonatomic, retain) NSDate * dzisiaj;

@end
