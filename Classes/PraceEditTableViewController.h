//
//  ParceEditTableViewController.h
//  iDzienniczek
//
//  Created by MacBury on 08-09-06.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Rok.h"
#import "Prace.h"
#import "DoubleValueCell.h"

@interface PraceEditTableViewController : UIViewController <UITextViewDelegate,  UIActionSheetDelegate> {
	IBOutlet UITableViewCell * nazwaCell;
	IBOutlet UITextField * nazwa;

	
	IBOutlet UISegmentedControl * piorytet;
	
	IBOutlet UITableView * tableView;
	
	IBOutlet UIViewController * dataViewController;
	IBOutlet UIDatePicker * dataPicker;
	IBOutlet UITextField * dateTextView;
	
	IBOutlet UIViewController * notatkaViewController;
	IBOutlet UITextView * notatkaView;
	IBOutlet UIBarButtonItem * notatkaClear;
	
	DoubleValueCell * dateCell;
	Prace * praca;
	
	NSDateFormatter * dateFormatter;
}

@property (nonatomic, retain) Prace * praca;

- (IBAction) actionDate:(id)sender;

- (IBAction) notatkaClear:(id)sender;

- (IBAction) piorytetChange:(id)sender;
- (IBAction) dataChange:(id)sender;
@end
