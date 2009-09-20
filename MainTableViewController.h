//
//  MainTableViewController.h
//  iDzienniczek
//
//  Created by MacBury on 08-09-01.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define sNew 0
#define sDetail 1
#define sEdit 2

@class iDzienniczekAppDelegate;
@interface MainTableViewController : UITableViewController/*UIViewController <UITableViewDelegate, UITableViewDataSource>*/ {
	iDzienniczekAppDelegate * mainDelegate;
	//UITableView * tableView;
	UINavigationController * modalNavController;
}

- (UINavigationController *) getModalNavController:(UIViewController *)root;

//@property (nonatomic, retain) UITableView * tableView;

@end
