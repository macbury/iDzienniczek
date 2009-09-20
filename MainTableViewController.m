//
//  MainTableViewController.m
//  iDzienniczek
//
//  Created by MacBury on 08-09-01.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MainTableViewController.h"


@implementation MainTableViewController

//@synthesize tableView;

- (void)dealloc {
	[modalNavController release];
	[super dealloc];
}

- (void)viewDidLoad {
	mainDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
	//self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	//[self.view addSubview:tableView];
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
	self.tableView.allowsSelectionDuringEditing = YES;
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	[super viewDidLoad];
}

- (UINavigationController *) getModalNavController:(UIViewController *)root {
	
	if (modalNavController == nil){
		modalNavController = [[UINavigationController alloc] initWithRootViewController:root];
	}
	
	return modalNavController;
}

- (void)viewWillAppear:(BOOL)animated {
	[self.tableView reloadData];
	[super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}
@end

