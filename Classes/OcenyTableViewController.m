//
//  OcenyTableViewController.m
//  iDzienniczek
//
//  Created by MacBury on 08-08-05.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "OcenyTableViewController.h"


@implementation OcenyTableViewController

@synthesize przedmiot;

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
	if(self.editing){
		if(addButton == nil){
			addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
		}
		[self.navigationItem setLeftBarButtonItem:addButton animated:YES];
	}else{
		[self.navigationItem setLeftBarButtonItem:nil animated:YES];
		
	}
	
}

- (void) beginEditingWithOcena:(Oceny *)ocena isNew:(bool)isNew {

	if (editViewController == nil) {
		editViewController = [[OcenyAddControllerView alloc] init];
	}
	if (isNew){
		editViewController.navigationItem.title = @"Nowa Ocena";
		editViewController.status = sNew;
	}else{
		editViewController.navigationItem.title = @"Edycja Oceny";
		editViewController.status = sEdit;
	}
	editViewController.ocena = ocena;
	
	[self.navigationController presentModalViewController:[self getModalNavController:editViewController] animated:YES];
}


- (IBAction) add:(id)sender {
	[self beginEditingWithOcena:[[Oceny alloc] initBlankWithPrzedmiot:self.przedmiot] isNew:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section  {
	if (section == 1){
		return ([pierwszePolrocze count] == 0) ? nil : @"Pierwsze półrocze";
	}else{
		return ([drugiePolrocze count] == 0) ? nil : @"Drugie półrocze" ;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 1){
		return [pierwszePolrocze count];
	}else{
		return [drugiePolrocze count];
	}
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *MyIdentifier = @"ocenaCell";
	
	Oceny * ocena;
	ocenaCell * cell = (ocenaCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[ocenaCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	
	if (indexPath.section == 1){
		ocena = (Oceny *)[pierwszePolrocze objectAtIndex:indexPath.row];
	}else{
		ocena = (Oceny *)[drugiePolrocze objectAtIndex:indexPath.row];
	}
	
	cell.ocena.text = [mainDelegate ocenaSlownie:ocena.ocena];
	cell.zaco.text = [mainDelegate zaCoSlownie:ocena.zaco];
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	Oceny * ocena;
	
	if (indexPath.section == 1){
		ocena = (Oceny *)[pierwszePolrocze objectAtIndex:indexPath.row];
	}else{
		ocena = (Oceny *)[drugiePolrocze objectAtIndex:indexPath.row];
	}
	
	if (self.editing){
		[self beginEditingWithOcena:ocena isNew:NO];
	}else{
		if(ocenyDetailView == nil){
			ocenyDetailView = [[OcenyDetailView alloc] initWithNibName:@"OcenyDetailView" bundle:nil];
		}
		
		ocenyDetailView.ocena = ocena;
		ocenyDetailView.title = @"Ocena";
		ocenyDetailView.status = sDetail;
		
		[self.navigationController pushViewController:ocenyDetailView animated:YES];
	}
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		Oceny * ocena;
		if (indexPath.section == 1){
			ocena = (Oceny *)[pierwszePolrocze objectAtIndex:indexPath.row];
			[ocena deleteFromDatabase];
			[pierwszePolrocze removeObjectAtIndex:indexPath.row];
		}else{
			ocena = (Oceny *)[drugiePolrocze objectAtIndex:indexPath.row];
			[ocena deleteFromDatabase];
			[drugiePolrocze removeObjectAtIndex:indexPath.row];
		}
		
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
	}

}
- (void)dealloc {
	if (pierwszePolrocze != nil) {
		[pierwszePolrocze removeAllObjects];
	}
	if (drugiePolrocze != nil) {
		[drugiePolrocze removeAllObjects];
	}
	[pierwszePolrocze release];
	[drugiePolrocze release];
	[editViewController release];
	[addButton release];
	[przedmiot release];
	[ocenyDetailView release];
	[super dealloc];
}


- (void)viewDidLoad {
	[super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
	self.title = self.przedmiot.nazwa;
	pierwszePolrocze = [Oceny findAllByPrzedmiotAndPolrocze:self.przedmiot polrocze:0];
	drugiePolrocze = [Oceny findAllByPrzedmiotAndPolrocze:self.przedmiot polrocze:1];
	[self.tableView reloadData];
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)viewDidDisappear:(BOOL)animated {
	if (pierwszePolrocze != nil) {
		[pierwszePolrocze removeAllObjects];
	}
	if (drugiePolrocze != nil) {
		[drugiePolrocze removeAllObjects];
	}
	[pierwszePolrocze release];
	[drugiePolrocze release];
	pierwszePolrocze = nil;
	drugiePolrocze = nil;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


@end

