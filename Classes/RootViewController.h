//
//  RootViewController.h
//  iDzienniczek
//
//  Created by MacBury on 08-08-01.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "RokEditTableViewController.h"
#import "Rok.h"
#import "InformacjeViewController.h"
#import "ConfigTableViewController.h"
#import "BackupService.h"

@interface RootViewController : UITableViewController {
	NSMutableArray * rokArray;
	RokEditTableViewController * rokEditTableViewController;
	UINavigationController *rokNavController;
	ConfigTableViewController * configController;
	InformacjeViewController * informacjeController;
	BackupService * backup;
}

- (void) beginEditinhWithRok:(Rok *)rok isEditing:(bool)isEditing;

@end
