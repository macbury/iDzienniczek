//
//  PrzedmiotDetailView.m
//  iDzienniczek
//
//  Created by MacBury on 08-09-04.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PrzedmiotDetailView.h"


@implementation PrzedmiotDetailView

@synthesize przedmiot;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return (section == 1) ? 3 : 1;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

- (UITableViewCell *) normalCell:(UITableView *)tableView {
	static NSString *MyIdentifier = @"przedmiotDetailCell";
	
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	cell.accessoryType = UITableViewCellAccessoryNone;
	return cell;
}

- (DoubleValueCell *) doubleValueCell:(UITableView *)tableView {
	static NSString *MyIdentifier = @"przedmiotDetailCell";
	
	DoubleValueCell *cell = (DoubleValueCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[DoubleValueCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	cell.accessoryType = UITableViewCellAccessoryNone;
	return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell;
	DoubleValueCell *doubleValueCell;
	
	switch (indexPath.section) {
		case 0:
			cell = [self normalCell:tableView];
			cell.text = przedmiot.nazwa;
			return cell;
		break;
		case 1:
			doubleValueCell = [self doubleValueCell:tableView];
			switch (indexPath.row) {
				case 0:
					doubleValueCell.key.text = @"Pierw. półrocze:";
					doubleValueCell.value.text = [NSString stringWithFormat:@"%.2f", [przedmiot srednia:0]];
				break;
				case 1:
					doubleValueCell.key.text = @"Drugie półrocze:";
					doubleValueCell.value.text = [NSString stringWithFormat:@"%.2f", [przedmiot srednia:1]];
				break;
				case 2:
					doubleValueCell.key.text = @"Wlicza się:";
					doubleValueCell.value.text = przedmiot.wliczaSieDoSredniej ? @"Tak" : @"Nie";
				break;
			}
			return doubleValueCell;
		break;
		case 2:
			cell = [self normalCell:tableView];
			cell.text = [NSString stringWithFormat:@"%i", [przedmiot lekcjiWTygodniu]];
			return cell;
		break;
		case 3:
			cell = [self normalCell:tableView];
			cell.text = [NSString stringWithFormat:@"%i", [przedmiot countOcenyByPrzedmiot]];
			return cell;
		break;
	}
	
	return nil;
}

- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section  {
	switch (section) {
		case 0:
			return @"Nazwa przedmiotu:";
		break;
		case 1:
			return @"Średnia:";
		break;
		case 2:
			return @"Lekcji w tygodniu:";
		break;
		case 3:
			return @"Ocen z przedmiotu:";
		break;
	}
	
	return @"";
}


- (void)dealloc {
	[super dealloc];
}


- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.rightBarButtonItem = nil;
	self.title = @"Szczegóły";
	self.tableView.sectionFooterHeight = 10;
}

- (void)viewDidDisappear:(BOOL)animated {
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


@end

