//
//  PraceDetailView.m
//  iDzienniczek
//
//  Created by MacBury on 08-09-07.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PraceDetailView.h"


@implementation PraceDetailView
@synthesize praca;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.section == 4){
		return 180.0f;
	}else{
		return 44.0f;
	}
}

- (UITableViewCell *)getNotatkaTableCell {
	static NSString *BodyIdentifier = @"notatkaCellView";
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:BodyIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 180) reuseIdentifier:BodyIdentifier] autorelease];
		notatkaView = [[UITextView alloc] initWithFrame:CGRectInset(cell.contentView.bounds, 6, 6)];
		notatkaView.font = [UIFont systemFontOfSize:15.0f];
		
		notatkaView.editable = NO;
		
		[notatkaView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
		[cell.contentView addSubview:notatkaView];
		
	}
	notatkaView.text = self.praca.opis;
	
	return cell;
	
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 5;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return (section == 1) ? 2 : 1;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return (indexPath.section == 1) ? indexPath : nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	praca.wykonany = (indexPath.row == 0);
	[praca save];
	[mainDelegate refreshBadge];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *MyIdentifier = @"pracaDetailCell";
	
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	cell.accessoryType = UITableViewCellAccessoryNone;
	switch (indexPath.section) {
		case 0:
			cell.text = praca.nazwa;
			break;
		case 1:
			if (indexPath.row == 0){
				cell.text = NSLocalizedString(@"Yes",@"");
				if (praca.wykonany){
					cell.accessoryType = UITableViewCellAccessoryCheckmark;
				}else{
					cell.accessoryType = UITableViewCellAccessoryNone;
				}
			}else{
				cell.text = NSLocalizedString(@"No",@"");
				if (praca.wykonany){
					cell.accessoryType = UITableViewCellAccessoryNone;
				}else{
					cell.accessoryType = UITableViewCellAccessoryCheckmark;
				}
			}

		break;
		case 2:
			switch (praca.piorytet) {
				case 0:
					cell.text = NSLocalizedString(@"Normal",@"");
				break;
				case 1:
					cell.text = NSLocalizedString(@"High",@"");
					break;
				case 2:
					cell.text = NSLocalizedString(@"Very High",@"");
				break;
			}
		break;
		case 3:
			cell.text = [dateFormatter stringFromDate:praca.koniec];
		break;
			
		case 4:{
			
			if (self.praca.opis == @""){
				return nil;
			}else{
				return [self getNotatkaTableCell];
			}
			
		} 
			
		break;
	}
	
	return cell;
}

- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section  {
	switch (section) {
		case 0:
			return NSLocalizedString(@"Task",@"");
			break;
		case 1:
			return NSLocalizedString(@"Done",@"");
			break;
		case 2:
			return NSLocalizedString(@"Priority",@"");
			break;
		case 3:
			return NSLocalizedString(@"DueDate",@"");
			break;
		case 4:
			return NSLocalizedString(@"Note",@"");
			break;
	}
	
	return @"";
}


- (void)dealloc {
	[super dealloc];
}

- (IBAction) edit:(id)sender {
	if (actionSheet == nil){
		actionSheet = [[UIActionSheet alloc] initWithTitle:nil
										   delegate:self
								  cancelButtonTitle:NSLocalizedString(@"Cancel",@"")
							 destructiveButtonTitle:NSLocalizedString(@"Delete",@"")
								  otherButtonTitles:NSLocalizedString(@"Edit",@""),NSLocalizedString(@"E-Mail this",@""),nil];
	}
	
	[actionSheet showInView:mainDelegate.window];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
	switch (buttonIndex) {
		case 1:{
			if (editViewController == nil) {
				editViewController = [[PraceEditTableViewController alloc] init];
			}
			editViewController.title = NSLocalizedString(@"EditTask",@"");
			
			editViewController.praca = self.praca;
			
			[self.navigationController presentModalViewController:[self getModalNavController:editViewController] animated:YES];
		}
			
		break;
		case 2:{
			NSMutableString * mail = [[NSMutableString alloc] init];
			[mail appendFormat:@"mailto:jakis@adres.pl?subject=%@", self.praca.nazwa];
			[mail appendString:@"&body="];
			[mail appendString: self.praca.opis];
			[mail appendString:@"\nZadanie trzeba wykonać do: "];
			[mail appendString:[dateFormatter stringFromDate:self.praca.koniec]];
			[mail appendString:@"\nWiadomość wygenerowana w programie iDzienniczek"];
			
			NSURL * url = [NSURL URLWithString:[mail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

			[[UIApplication sharedApplication] openURL: url];
		}

		break;
		case 0:
			[self.praca deleteFromDatabase];
			[self.navigationController popViewControllerAnimated:YES];
		break;
	}
}
	 
- (void)viewDidLoad {
	[super viewDidLoad];
	editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
															   target:self
															   action:@selector(edit:)];
	self.navigationItem.rightBarButtonItem = editButton;
	self.title =  NSLocalizedString(@"Details",@"");
	self.tableView.sectionFooterHeight = 10;
	dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterFullStyle];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
}

- (void)viewDidDisappear:(BOOL)animated {
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


@end

