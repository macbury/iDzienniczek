//
//  RokEditTableViewController.h
//  iDzienniczek
//
//  Created by MacBury on 08-08-02.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Rok.h"


@interface RokEditTableViewController : UIViewController {
	bool isEditing;

	Rok * rok;
	int selected;
	
	NSDateFormatter * dateFormatter;
	
	IBOutlet UIDatePicker * datePicker;
	IBOutlet UITableView * table;
	
	IBOutlet UITableViewCell * poczatekDataCell;
	IBOutlet UILabel * poczatekLabelName;
	IBOutlet UILabel * poczatekLabelValue;
	
	IBOutlet UITableViewCell * polroczeDataCell;
	IBOutlet UILabel * polroczeLabelName;
	IBOutlet UILabel * polroczeLabelValue;
	
	IBOutlet UITableViewCell * koniecDataCell;
	IBOutlet UILabel * koniecLabelName;
	IBOutlet UILabel * koniecLabelValue;
}

- (IBAction) dateChange:(id)sender;
- (IBAction) cancel:(id)sender;
- (IBAction) save:(id)sender;

@property(assign, nonatomic) bool isEditing;
@property(retain, nonatomic) Rok * rok;

@end
