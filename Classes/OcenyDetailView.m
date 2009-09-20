//
//  OcenyDetailView.m
//  iDzienniczek
//
//  Created by MacBury on 08-08-05.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "OcenyDetailView.h"


@implementation OcenyDetailView

@synthesize ocena, status;


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return (ocena.notatka == @"" && self.status == sDetail) ? 3 : 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.row == 3){
		return 180.0f;
	}else{
		return 44.0f;
	}
}

- (UITableViewCell *)getNotatkaTableCell {
	static NSString *BodyIdentifier = @"notatkaCellView";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BodyIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 180) reuseIdentifier:BodyIdentifier] autorelease];
		notatkaView = [[UITextView alloc] initWithFrame:CGRectInset(cell.contentView.bounds, 6, 6)];
		notatkaView.font = [UIFont systemFontOfSize:15.0f];
		
		notatkaView.editable = NO;

		[notatkaView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
		[cell.contentView addSubview:notatkaView];
		
	}
	notatkaView.text = ocena.notatka;
	
	return cell;
	
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	iDzienniczekAppDelegate * mainDelegate = (iDzienniczekAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	switch (indexPath.row) {
		case 0:
			ocenaLabelValue.text = [mainDelegate ocenaSlownie:self.ocena.ocena];
			return ocenaCell;
		break;
		case 1:
			zacoLabelValue.text = [mainDelegate zaCoSlownie:self.ocena.zaco];
			return zacoCell;
		break;
		case 2:
			dodanoLabelValue.text = [dateFormatter stringFromDate:ocena.dodano];
			return dodanoCell;
		break;
		case 3:{			
			return [self getNotatkaTableCell];
		} 

		break;
	}
	return nil;
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellAccessoryNone;
}


- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tv deselectRowAtIndexPath:indexPath animated:NO];
}



- (void)dealloc {
	[notatkaView release];
	[menu release];
	[dateFormatter release];
	[saveButton release];
	[cancelButton release];
	[super dealloc];
}


- (void)viewDidLoad {
	
	tableView.sectionHeaderHeight = 10;
	tableView.scrollEnabled = NO;
	tableView.userInteractionEnabled = NO;
	[ocenaLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
	[dodanoLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
	[zacoLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
	
	if (dateFormatter == nil){
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	}
	
	if (self.status == sDetail){
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
																							   target:self
																							   action:@selector(edit:)];
	}
	
	[super viewDidLoad];
}

- (IBAction) edit:(id)sender {
	iDzienniczekAppDelegate * mainDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (menu == nil){
		menu = [[UIActionSheet alloc] initWithTitle:nil
										   delegate:self
								  cancelButtonTitle:NSLocalizedString(@"Cancel",@"")
							 destructiveButtonTitle:NSLocalizedString(@"Delete",@"")
								  otherButtonTitles:NSLocalizedString(@"Edit",@""),nil];
	}
	
	[menu showInView:mainDelegate.window];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
	switch (buttonIndex) {
		case 1:{
			OcenyTableViewController * table = (OcenyTableViewController *)[[self.navigationController viewControllers] objectAtIndex:1];
			[table beginEditingWithOcena:self.ocena isNew:NO];
		}

		break;
		case 0:
			[self.ocena deleteFromDatabase];
			[self.navigationController popViewControllerAnimated:YES];
		break;
	}
}

- (void)viewWillAppear:(BOOL)animated {
	
	if (saveButton == nil && self.status != sDetail){
		saveButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)] autorelease];
		self.navigationItem.rightBarButtonItem = saveButton;
				
		cancelButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)] autorelease];
		self.navigationItem.leftBarButtonItem = cancelButton;
	}

	[tableView reloadData];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


@end

