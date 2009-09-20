//
//  ConfigTableViewController.m
//  iDzienniczek
//
//  Created by MacBury on 08-09-05.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ConfigTableViewController.h"


@implementation ConfigTableViewController

@synthesize key, values, bind;

- (id)init {
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
		[self.tableView setDelegate:self];
		[self.tableView setDataSource:self];
		self.tableView.sectionFooterHeight = 10;
	}
	return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [values count];
}

- (void)viewWillAppear:(BOOL)animated {
	[self.tableView reloadData];
	[super viewWillAppear:animated];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *MyIdentifier = @"configCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	if ([bind valueForKey:key] == [values objectAtIndex:indexPath.row]){
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}else{
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	cell.text = [[values objectAtIndex:indexPath.row] stringValue];
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[bind setValue:[values objectAtIndex:indexPath.row] forKey:key];
	[self.tableView reloadData];
	[self.navigationController popViewControllerAnimated:YES];
}

/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
	}
	if (editingStyle == UITableViewCellEditingStyleInsert) {
	}
}
*/
/*
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/
/*
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/
/*
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/


- (void)dealloc {
	[super dealloc];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


@end

