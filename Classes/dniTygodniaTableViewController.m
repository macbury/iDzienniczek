//
//  dzienTygodniaTableViewController.m
//  iDzienniczek
//
//  Created by MacBury on 08-08-09.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "dniTygodniaTableViewController.h"


@implementation dniTygodniaTableViewController

- (id)init{
	return [super initWithStyle:UITableViewStyleGrouped];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return (section == 0) ? 2 : maxDays;
}

- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section  {
	return (section == 1) ? NSLocalizedString(@"Days of week", @"Dni tygodnia") : nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *MyIdentifier = @"dzienTygodniaCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	
	if (indexPath.section == 0){
		if (indexPath.row == 0){
			cell.text = NSLocalizedString(@"Today", @"Dzisiaj");
		}else{
			cell.text = NSLocalizedString(@"Tomorrow", @"Jutro");
		}
	}else{
		cell.text = [self nazwaDzienTygodnia:indexPath.row];
	}
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;
}

- (NSString *) nazwaDzienTygodnia:(NSInteger)dzien {
	switch (dzien) {
		case 0:
			return NSLocalizedString(@"Monday", @"Poniedziałek");
		break;
		case 1:
			return NSLocalizedString(@"Tuesday", @"Wtorek");
		break;
		case 2:
			return NSLocalizedString(@"Wednesday", @"Środa");
		break;
		case 3:
			return NSLocalizedString(@"Thursday", @"Czwartek");
		break;
		case 4:
			return NSLocalizedString(@"Friday", @"Piątek");
		break;
		case 5:
			return NSLocalizedString(@"Saturday", @"Sobota");
		break;
		
		default:
			return NSLocalizedString(@"Sunday", @"Niedziela");
		break;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (dzienTygodnia == nil){
		dzienTygodnia = [[dzienTygodniaViewController alloc] initWithNibName:@"dzienTygodniaTableViewController" bundle:nil];
	}
	if (indexPath.section == 1){
		dzienTygodnia.title = [self nazwaDzienTygodnia:indexPath.row];
		dzienTygodnia.dzien = indexPath.row + 1;
		[self.navigationController pushViewController:dzienTygodnia animated:YES];
	}else{
		NSInteger dzien = dzisiaj;
		if (indexPath.row == 1){
			if (dzien == 7){
				dzien = 1;
			}else{
				dzien++;
			}
		}
		
		if (dzien > maxDays || dzien == 0){
			UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"Info")
															 message:NSLocalizedString(@"DayOfMsg", @"DayOfMsg")  
															delegate:nil cancelButtonTitle:@"OK"
												   otherButtonTitles:nil] autorelease];
			[alert show];
		}else{
			dzienTygodnia.title = [self nazwaDzienTygodnia:dzien-1];
			dzienTygodnia.dzien = dzien;
			[self.navigationController pushViewController:dzienTygodnia animated:YES];
		}
	}
}


- (void)dealloc {
	[dzienTygodnia release];
	[super dealloc];
}

- (void)viewDidLoad {
	self.title = NSLocalizedString(@"Lesson Plan", @"Lesson Plan");
	//self.tableView.sectionHeaderHeight = 10;
	//self.tableView.sectionFooterHeight = 3;
	[super viewDidLoad];
	self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	dzisiaj = [mainDelegate dzisiejszyDzienTygodnia];
	maxDays = [[mainDelegate.config objectForKey:@"dni"] intValue];
	[self.tableView reloadData];
	[super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


@end

