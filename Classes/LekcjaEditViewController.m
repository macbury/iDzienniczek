//
//  LekcjaEditViewController.m
//  iDzienniczek
//
//  Created by MacBury on 08-08-10.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "LekcjaEditViewController.h"


@implementation LekcjaEditViewController

@synthesize status, lekcja, przedmioty;

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [przedmioty count];	
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	Przedmiot * p = (Przedmiot *)[przedmioty objectAtIndex:row];
	return p.nazwa;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	self.lekcja.przedmiot = [przedmioty objectAtIndex:row];
	[tableView reloadData];
}

- (IBAction)save:(id)sender {
	[salaTextField resignFirstResponder];
	[salaTextField endEditing:YES];
	[self.lekcja save];

	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
	if (self.lekcja != nil){
		self.lekcja.przedmiot = nil;
		[przedmioty removeAllObjects];
		[przedmioty release];
		[self.lekcja release];

		lekcja = nil;
		przedmioty = nil;
	}
}

- (IBAction)cancel:(id)sender {
	[salaTextField resignFirstResponder];
	[salaTextField endEditing:YES];

	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[datePicker setHidden:YES];
	[lekcjePicker setHidden:NO];

	przedmioty = [Przedmiot findAllByRok];
	[lekcjePicker reloadComponent:0];
	if (self.lekcja.przedmiot == nil){
		self.lekcja.przedmiot = [przedmioty objectAtIndex:0];
	}else{
		for (int i = 0; i < [przedmioty count]; i++){
			Przedmiot * p = [przedmioty objectAtIndex:i];
			if (p._id == self.lekcja.przedmiot._id){
				[lekcjePicker selectRow:i inComponent:0 animated:YES];
				break;
			}
		}
	}
	
	//[lekcjePicker selectRow:0 inComponent:0 animated:YES];
	
	[tableView reloadData];
	[tableView selectRowAtIndexPath:0 animated:YES scrollPosition:UITableViewScrollPositionTop];
}

- (void)viewDidLoad {
	tableView.sectionHeaderHeight = 10.0f;
	dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterNoStyle];
	[dateFormatter setTimeStyle:NSDateFormatterLongStyle];

	salaLabel.font = [UIFont boldSystemFontOfSize:17.0f];
	salaTextField.font = [UIFont systemFontOfSize: 17.0f];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)] autorelease];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)] autorelease];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	return 4;
}

- (IBAction)timeChange:(id)sender {
	NSDateComponents * com = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:datePicker.date];
	
	if (datePicker.datePickerMode == UIDatePickerModeTime){
		self.lekcja.start = com;
	}else{
		self.lekcja.czasTrwania = com;
	}
	
	[tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row == 3){
		salaTextField.text = self.lekcja.sala;
		return salaCell;
	}else{
		DoubleValueCell * cell = (DoubleValueCell *)[tableView dequeueReusableCellWithIdentifier:@"lekcjaCell"];
		if (cell == nil){
			cell = [[[DoubleValueCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"lekcjaCell"] autorelease];
		}
		
		cell.accessoryType = UITableViewCellAccessoryNone;
		
		switch (indexPath.row) {
			case 0:
				cell.key.text = @"Przedmiot";
				cell.value.text = self.lekcja.przedmiot.nazwa;
				break;
			case 1:
				cell.key.text = @"Start";
				cell.value.text = [self.lekcja stringStart];
				break;
			case 2:
				cell.key.text = @"Czas trwania";
				cell.value.text = [[[NSCalendar currentCalendar] dateFromComponents:self.lekcja.czasTrwania] descriptionWithCalendarFormat:@"%H:%M" timeZone:nil locale:nil];
				break;
		}
		
		return cell;
	}

}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case 0:
			[lekcjePicker setHidden: NO];
			[datePicker setHidden: YES];
			[salaTextField resignFirstResponder];
		break;
		case 1:
			[lekcjePicker setHidden: YES];
			[datePicker setHidden: NO];
			[salaTextField resignFirstResponder];
			datePicker.datePickerMode = UIDatePickerModeTime;
			
			datePicker.date = [[NSCalendar currentCalendar] dateFromComponents:self.lekcja.start];
		break;
		case 2:
			[lekcjePicker setHidden: YES];
			[datePicker setHidden: NO];
			[salaTextField resignFirstResponder];
			datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
			
			datePicker.date = [[NSCalendar currentCalendar] dateFromComponents:self.lekcja.czasTrwania];
		break;
		case 3:
			[tv deselectRowAtIndexPath:indexPath animated:NO];
			[salaTextField becomeFirstResponder];
		break;
	}
	[tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	[tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO];
	[tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:NO];
	[tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:NO];
	[tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	self.lekcja.sala = textField.text;
	[tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[salaTextField resignFirstResponder];
	return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[self.lekcja release];
	[przedmioty release];
	[dateFormatter release];
	[super dealloc];
}


@end
