//
//  dzienTygodniaViewController.m
//  iDzienniczek
//
//  Created by MacBury on 08-08-10.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "dzienTygodniaViewController.h"


@implementation dzienTygodniaViewController

@synthesize dzien;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
	if(self.editing){
		if(addButton == nil){
			addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
		}
		[self.navigationItem setLeftBarButtonItem:addButton animated:YES];
	}else{
//		[navController release];
//		[editController release];
//		navController = nil;
//		editController = nil;
		[self.navigationItem setLeftBarButtonItem:nil animated:YES];
	}
	
}

- (void) beginEditingWith:(Lekcja *)lekcja isNew:(bool)isNew {
	if(editController == nil){
		editController = [[LekcjaEditViewController alloc] initWithNibName:@"LekcjaEditViewController" bundle:nil];
	}
	if(navController == nil){
		navController = [[UINavigationController alloc] initWithRootViewController:editController];
	}
	
	if (isNew){
		editController.navigationItem.title = @"Nowa lekcja";
		editController.status = sNew;
	}else{
		editController.navigationItem.title = @"Edycja lekcji";
		editController.status = sEdit;
	}

	editController.lekcja = lekcja;

	[self.navigationController presentModalViewController:navController animated:YES];
}

- (IBAction) add:(id)sender{
	iDzienniczekAppDelegate * appDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if ([Przedmiot countByRok:appDelegate.selected_rok.ids] == 0){
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Brak przedmiotów!"
														 message:@"Przejdź do zakładki przedmioty aby dodać nowe przedmioty!"
														delegate:nil
											   cancelButtonTitle:@"OK"
											   otherButtonTitles:nil];
		[alert autorelease];
		[alert show];
		return;
	}
	
	Lekcja * l = [[Lekcja alloc] initBlank:self.dzien];
	NSDateComponents* czasTrwaniaLekcji = [[NSDateComponents alloc] init];
	[czasTrwaniaLekcji setHour:0];
	[czasTrwaniaLekcji setMinute:[appDelegate.config integerForKey:@"czasTrwaniaLekcji"]];
	
	l.czasTrwania = czasTrwaniaLekcji;
	if ([lekcjeArray count] > 0){
		l.start = [[lekcjeArray objectAtIndex:[lekcjeArray count] - 1] czasTrwania:[[appDelegate.config objectForKey:@"przerwa"] intValue]];
	}
	[self beginEditingWith:l isNew:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [lekcjeArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *MyIdentifier = @"MyIdentifier";
	
	DzienTygodniaCell *cell = (DzienTygodniaCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[DzienTygodniaCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	
	Lekcja * l = (Lekcja *)[lekcjeArray objectAtIndex:indexPath.row];
	
	cell.numerLekcji.text = [NSString stringWithFormat:@"%d.", indexPath.row+1];
	cell.przedmiot.text = l.przedmiot.nazwa;
	cell.sala.text = [NSString stringWithFormat:@"sala %@", l.sala];
	cell.czasTrwania.text = [NSString stringWithFormat:@"%@ - %@", [l stringStart], [l stringCzasTrwania]];
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.editing){
		Lekcja * l = (Lekcja *)[lekcjeArray objectAtIndex:indexPath.row];
		[self beginEditingWith:l isNew:NO];
	}
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		Lekcja * l = (Lekcja *)[lekcjeArray objectAtIndex:indexPath.row];
		[l deleteFromDatabase];
		[lekcjeArray removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
	}
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (void)dealloc {
	[navController release];
	[editController release];
	[addButton release];
	[lekcjeArray release];
	[super dealloc];
}


- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	lekcjeArray = [Lekcja findAllByRokAndDzien:dzien];
	[self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)viewDidDisappear:(BOOL)animated {
	[lekcjeArray removeAllObjects];
	[lekcjeArray release];
	lekcjeArray = nil;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


@end

