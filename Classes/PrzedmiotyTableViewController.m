//
//  PrzedmiotyTableViewController.m
//  iDzienniczek
//
//  Created by MacBury on 08-08-03.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PrzedmiotyTableViewController.h"


@implementation PrzedmiotyTableViewController

- (void) beginEditingWithPrzedmiot:(Przedmiot *)p isEditing:(bool)isEditing {

	if(editViewController == nil){
		editViewController = [[PrzedmiotyEditViewController alloc] initWithNibName:@"PrzedmiotyEditViewController" bundle:nil];
		modalNavController = [self getModalNavController:editViewController];
	}

	editViewController.przedmiot = p;
	if (isEditing){
		editViewController.navigationItem.title = @"Edycja Przedmiotu";
	}else{
		editViewController.navigationItem.title = @"Nowy Przedmiot";
	}
	[przedmioty removeAllObjects];
	[przedmioty release];
	przedmioty = nil;
	
	[self.navigationController presentModalViewController:modalNavController animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0){
		return ([przedmioty count] == 0) ? 0 : 1;
	}else{
		return [przedmioty count];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"MainCell"] autorelease];
	}

	if (indexPath.section == 1){
		Przedmiot * p = (Przedmiot *)[przedmioty objectAtIndex:indexPath.row];
		cell.text = p.nazwa;
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		//cell.font = [UIFont boldSystemFontOfSize:13.0f];
		//[cell setAccessoryAction:@selector(editSubject:)];
		//[cell setTarget:self];
	}else{
		cell.text = @"Aktualny przedmiot";
		//cell.font = [UIFont boldSystemFontOfSize:15.0f];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	if (detailView == nil){
		detailView = [[PrzedmiotDetailView alloc] initWithStyle:UITableViewStyleGrouped];
	}
	detailView.przedmiot = (Przedmiot *)[przedmioty objectAtIndex:indexPath.row];
	[self.navigationController pushViewController:detailView animated:YES];
}

- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section  {
	return (section == 1) ? @"Przedmioty" : nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	Przedmiot * p;
	
	if (indexPath.section == 1){
		p = (Przedmiot *)[przedmioty objectAtIndex:indexPath.row];
	}else{
		p = [Lekcja findPrzedmiotByAktualnaLekcja:[mainDelegate dzisiejszyDzienTygodnia]];
		if (p == nil){
			UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"Uwaga!" 
					  message:@"Akatualnie nie odbywa się żadna lekcja" 
					 delegate:nil cancelButtonTitle:@"OK."
				otherButtonTitles:nil] autorelease];
			[alert show];
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
			return;
		}

	}
	
	if (self.editing && indexPath.section == 1){
		[self beginEditingWithPrzedmiot:p isEditing:YES];
	}else{
		if(ocenyTableViewController == nil){
			ocenyTableViewController = [[OcenyTableViewController alloc] init];
		}
		ocenyTableViewController.przedmiot = p;
		[self.navigationController pushViewController:ocenyTableViewController animated:YES];
	}
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
	//	[[UIApplication sharedApplication] setStatusBarOrientation:interfaceOrientation];
	//	SredniaViewController * svc = [[SredniaViewController alloc] init];
	//	[mainDelegate flipViews:svc];
		
	}

	return YES;
	
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the row from the data source
		Przedmiot * p = (Przedmiot *)[przedmioty objectAtIndex:indexPath.row];
		[p deleteFromDatabase];
		[przedmioty removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		
	}	

}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return (indexPath.section == 1);
}



- (void)dealloc {
	if (przedmioty != nil){
		[przedmioty removeAllObjects];
	}
	[ocenyTableViewController release];
	[editViewController release];
	[przedmioty release];
	[addButton release];
	[detailView release];
	[super dealloc];
}


- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = NSLocalizedString(@"Subjects", @"Przedmioty");
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
	if(self.editing){
		if(addButton == nil){
			addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPrzedmiot:)];
		}
		[self.navigationItem setLeftBarButtonItem:addButton animated:YES];
	}else{
		[self.navigationItem setLeftBarButtonItem:nil animated:YES];
		[editViewController release];
		[modalNavController release];
		editViewController = nil;
		modalNavController = nil;
	}
}

- (IBAction) addPrzedmiot:(id)sender {
	if (mainDelegate.selected_rok == nil){
		UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"Uwaga" 
														  message:@"Utwórz nowy rok szkolny!"
														 delegate:nil cancelButtonTitle:@"OK."
												otherButtonTitles:nil] autorelease];
		[alert show];
		return;
	}
	Przedmiot * p = [[Przedmiot alloc] initBlank];
	[self beginEditingWithPrzedmiot:p isEditing:NO];
}

- (void)viewWillAppear:(BOOL)animated {
	przedmioty = [Przedmiot findAllByRok];
	[self.tableView reloadData];
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)viewDidDisappear:(BOOL)animated {
	if (przedmioty != nil){
		[przedmioty removeAllObjects];
	}
	[przedmioty release];
	
	przedmioty = nil;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


@end

