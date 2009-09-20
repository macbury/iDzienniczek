//
//  OcenyDetailView.h
//  iDzienniczek
//
//  Created by MacBury on 08-08-05.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Oceny.h"
@class OcenyTableViewController;
@class iDzienniczekAppDelegate;
#define sNew 0
#define sDetail 1
#define sEdit 2
@interface OcenyDetailView : UIViewController <UIActionSheetDelegate> {
	IBOutlet UITableView * tableView;
	
	IBOutlet UITableViewCell * ocenaCell;
	IBOutlet UILabel * ocenaLabel;
	IBOutlet UILabel * ocenaLabelValue;
	
	IBOutlet UITableViewCell * zacoCell;
	IBOutlet UILabel * zacoLabel;
	IBOutlet UILabel * zacoLabelValue;	
	
	IBOutlet UITableViewCell * dodanoCell;
	IBOutlet UILabel * dodanoLabel;
	IBOutlet UILabel * dodanoLabelValue;
	
	Oceny * ocena;
	
	NSInteger status;
	
	NSDateFormatter * dateFormatter;
	
	UIBarButtonItem * saveButton;
	UIBarButtonItem * cancelButton;
	UITextView *notatkaView;
	
	UIActionSheet * menu;
}



@property (nonatomic, retain) Oceny * ocena;
@property (nonatomic, assign) NSInteger status;

- (UITableViewCell *)getNotatkaTableCell;

- (IBAction) edit:(id)sender;
@end
