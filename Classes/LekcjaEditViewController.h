//
//  LekcjaEditViewController.h
//  iDzienniczek
//
//  Created by MacBury on 08-08-10.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoubleValueCell.h"
#import "Przedmiot.h"
#import "Lekcja.h"
#define sNew 0
#define sDetail 1
#define sEdit 2

@interface LekcjaEditViewController : UIViewController {
	IBOutlet UITableView * tableView;
	IBOutlet UIDatePicker * datePicker;
	IBOutlet UIPickerView * lekcjePicker;
	
	IBOutlet UITableViewCell * salaCell;
	IBOutlet UILabel * salaLabel;
	IBOutlet UITextField * salaTextField;
	
	NSInteger status;
	Lekcja * lekcja;
	
	NSDateFormatter * dateFormatter;
	
	NSMutableArray * przedmioty;
}

@property (nonatomic, assign) NSInteger status;
@property (nonatomic, retain) Lekcja * lekcja;
@property (nonatomic, retain) NSMutableArray * przedmioty;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)timeChange:(id)sender;

@end
