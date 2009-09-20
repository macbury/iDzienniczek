//
//  ParceEditTableViewController.m
//  iDzienniczek
//
//  Created by MacBury on 08-09-06.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PraceEditTableViewController.h"


@implementation PraceEditTableViewController

@synthesize praca;

- (id)init {
	if (self = [super initWithNibName:@"PraceEditView" bundle:nil]) {
	}
	return self;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0){
		notatkaView.text = @"";
		praca.opis = @"";
	}
	//[notatkaView becomeFirstResponder];
}

- (IBAction) actionDate:(id)sender {
	NSDateComponents * dateFilter = [[NSCalendar currentCalendar] components:(NSMonthCalendarUnit | NSYearCalendarUnit | NSDayCalendarUnit) 
																	fromDate:self.praca.koniec];
	switch ([sender tag]) {
		case 0:
			[dataPicker setDate:[NSDate date]];
			self.praca.koniec = [NSDate date];
			[self dataChange:self];
			return;
		break;
		case 1:
			[dateFilter setDay:[dateFilter day] + 1];
		break;
		case 2:
			[dateFilter setDay:[dateFilter day] + 7];
		break;
		case 3:
			[dateFilter setDay:[dateFilter day] + 14];
		break;
	}
	NSDate * data = [[NSCalendar currentCalendar] dateFromComponents:dateFilter];
	[dataPicker setDate: data];
	[self dataChange:self];
}

- (IBAction) notatkaClear:(id)sender {
	UIActionSheet * notatkaClearSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"ClearNote", @"Usuwanie notatki")
																	delegate:self 
														   cancelButtonTitle:NSLocalizedString(@"Cancel", @"Anuluj") 
													  destructiveButtonTitle:NSLocalizedString(@"Delete", @"Usuń")
														   otherButtonTitles:nil];
	//[notatkaView resignFirstResponder];
	[notatkaClearSheet showInView:notatkaViewController.view];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	praca.nazwa = nazwa.text;
	//praca.opis = notatkaView.text;
}

- (void)textViewDidChange:(UITextView *)textView {
	self.praca.opis = textView.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}


- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section  {
	switch (section) {
		case 1:
			return NSLocalizedString(@"Priority", @"Priority");
			break;
			
		case 2:
			return NSLocalizedString(@"Note", @"Note");
			break;
			
		default:
			return nil;
		break;
	}
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 2;
		break;
			
		default:
			return 1;
		break;
	}
}

- (IBAction) piorytetChange:(id)sender {
	praca.piorytet = piorytet.selectedSegmentIndex;
}



- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	switch (indexPath.section) {
		case 0:
			switch (indexPath.row) {
				case 0:
					nazwa.text = praca.nazwa;
					return nazwaCell;
				break;
				case 1:{
					dateCell = (DoubleValueCell *)[tv dequeueReusableCellWithIdentifier:@"dataCell"];
					if (dateCell == nil){
						
						dateCell = [[[DoubleValueCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"dataCell"] autorelease];
						dateCell.key.text = NSLocalizedString(@"DueDate", @"DueDate");
					}
					dateCell.accessoryType = UITableViewCellAccessoryNone;
					[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
					dateCell.value.text = [dateFormatter stringFromDate:praca.koniec];
					[dateFormatter setDateStyle:NSDateFormatterFullStyle];
					return dateCell;
				}
				break;
			}
		break;
			
		case 1:{
			UITableViewCell * piorytetCell= [tv dequeueReusableCellWithIdentifier:@"piorytetCell"];
			if (piorytetCell == nil){
				
				piorytetCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"piorytetCell"] autorelease];
				piorytet.frame = CGRectMake(9, 0, 301, 45);
				[piorytetCell addSubview:piorytet];
			}
			
			[piorytet setSelectedSegmentIndex:praca.piorytet];
			return piorytetCell;
		}

		break;
		
		case 2:
		{
			UITableViewCell * notatkaCell= [tv dequeueReusableCellWithIdentifier:@"notatkaCell"];
			if (notatkaCell == nil){
				
				notatkaCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"notatkaCell"] autorelease];
			}
			notatkaCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			if (self.praca.opis == @"" || self.praca.opis == nil){
				notatkaCell.text = NSLocalizedString(@"BlankNote", @"BlankNote");
			}else{
				notatkaCell.text = self.praca.opis;
			}
			
			return notatkaCell;
		}

		break;
	}
	
	return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0 && indexPath.row == 1){
		dataViewController.title = NSLocalizedString(@"DueDate", @"DueDate");
		[dataPicker setDate: self.praca.koniec animated:NO];
		dateTextView.text = [dateFormatter stringFromDate:praca.koniec];
		[self.navigationController pushViewController:dataViewController animated:YES];
	}else if (indexPath.section == 2){
		notatkaViewController.title = NSLocalizedString(@"Note", @"Note");
		notatkaView.text = self.praca.opis;
		notatkaViewController.navigationItem.rightBarButtonItem = notatkaClear;

		[notatkaView resignFirstResponder];
		[notatkaView endEditing:YES];
		[self.navigationController pushViewController:notatkaViewController animated:YES];
	}
}


- (void)dealloc {
	[dateFormatter release];
	[super dealloc];
}

- (IBAction) dataChange:(id)sender {
	praca.koniec = dataPicker.date;
	dateTextView.text = [dateFormatter stringFromDate:praca.koniec];
}

- (void)viewDidLoad {
	[notatkaView setDelegate:self];
	[nazwa setFont: [UIFont systemFontOfSize:17.0f]];
	tableView.sectionHeaderHeight = 10;
	tableView.sectionFooterHeight = 10;
	dateFormatter = [[NSDateFormatter alloc] init];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)] autorelease];
	[super viewDidLoad];
}

- (IBAction) cancel:(id)sender{
	[praca release];
	praca = nil;
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (IBAction) save:(id)sender{
	[nazwa endEditing:true];
	if (nazwa.text == @"" || nazwa.text == nil){
		return;
	}
	[praca save];
	[praca release];
	praca = nil;
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
	iDzienniczekAppDelegate * appDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
	[dataPicker setMinimumDate: appDelegate.selected_rok.start];
	[dataPicker setMaximumDate: appDelegate.selected_rok.koniec];
	
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	
	[tableView scrollToRowAtIndexPath:0 atScrollPosition:UITableViewScrollPositionNone animated:YES];
	[tableView reloadData];
	if (self.praca.nazwa == @"" || self.praca.nazwa == nil){
		[nazwa becomeFirstResponder];
	}

	[super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


@end

