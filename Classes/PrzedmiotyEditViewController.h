//
//  PrzedmiotyEditViewController.h
//  iDzienniczek
//
//  Created by MacBury on 08-08-04.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Przedmiot.h"
//import "KontaktyPicker.h"

@interface PrzedmiotyEditViewController : UITableViewController {
	IBOutlet UITableViewCell * nazwaCell;
	IBOutlet UITextField * nazwaEdit;
	
	IBOutlet UITableViewCell * sredniaCell;
	IBOutlet UILabel * sredniaLabel;
	IBOutlet UISwitch * sredniaSwitch;
	
	Przedmiot * przedmiot;
	
	//KontaktyPicker * nauczycielePicker;
}

@property (nonatomic, retain)Przedmiot * przedmiot;

- (IBAction) onSredniaSwitch:(id)sender;

- (IBAction) cancel:(id)sender;
- (IBAction) save:(id)sender;
@end
