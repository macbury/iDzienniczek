//
//  PrzedmiotyEditViewController.m
//  iDzienniczek
//
//  Created by MacBury on 08-08-04.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PrzedmiotyEditViewController.h"


@implementation PrzedmiotyEditViewController

@synthesize przedmiot;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		
		UIBarButtonItem * addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)] autorelease];
		self.navigationItem.rightBarButtonItem = addButton;
		
		UIBarButtonItem * cancelButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)] autorelease];
		self.navigationItem.leftBarButtonItem = cancelButton;
		
	}

    return self;
}

- (IBAction) onSredniaSwitch:(id)sender {
	przedmiot.wliczaSieDoSredniej = sredniaSwitch.on;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	przedmiot.nazwa = nazwaEdit.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[nazwaEdit resignFirstResponder];
	return YES;
}

- (IBAction) cancel:(id)sender{	
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (IBAction) save:(id)sender{
	[nazwaEdit resignFirstResponder];
	if (przedmiot.nazwa == nil || przedmiot.nazwa == @""){
		return;
	}
	[przedmiot save];
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return (section == 0) ? 2 : 1;
}

- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section  {
	return (section == 1) ? @"Nauczyciel" : nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1){
		//if (nauczycielePicker == nil){
		//	nauczycielePicker = [[KontaktyPicker alloc] init];
		//}
		//nauczycielePicker.przedmiot = self.przedmiot;
		//[self.navigationController presentModalViewController:nauczycielePicker animated:YES];
	}else{
		[tableView deselectRowAtIndexPath:indexPath animated:NO];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == 1){
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nauczyciel"];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"nauczyciel"] autorelease];
		}
		cell.text = @"( Brak )";
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		return cell;
	}else{
		switch (indexPath.row) {
			case 0:
				nazwaEdit.text = przedmiot.nazwa;
				return nazwaCell;
				break;
			case 1:
				[sredniaSwitch setOn: przedmiot.wliczaSieDoSredniej];
				return sredniaCell;
				break;
		}
	}
	return nil;
}


- (void)dealloc {
	[super dealloc];
}


- (void)viewDidLoad {
	[super viewDidLoad];
	[sredniaLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
	[nazwaEdit setFont:[UIFont systemFontOfSize:17.0f]];
	self.tableView.sectionHeaderHeight = 10;
	self.tableView.sectionFooterHeight = 10;
}


- (void)viewWillAppear:(BOOL)animated {
	nazwaEdit.text = przedmiot.nazwa;
	[nazwaEdit becomeFirstResponder];
	[sredniaSwitch setOn: przedmiot.wliczaSieDoSredniej];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)viewDidDisappear:(BOOL)animated {
	[przedmiot release];
//	[nauczycielePicker release];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


@end

