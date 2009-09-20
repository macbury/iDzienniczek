//
//  RootViewController.m
//  iDzienniczek
//
//  Created by MacBury on 08-08-01.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "RootViewController.h"
#import "iDzienniczekAppDelegate.h"


@implementation RootViewController
- (void) beginEditinhWithRok:(Rok *)rok isEditing:(bool)isEditing {
	if(rokEditTableViewController == nil){
		rokEditTableViewController = [[RokEditTableViewController alloc] initWithNibName:@"RokEditTableViewController" bundle:nil];
		rokNavController = [[UINavigationController alloc] initWithRootViewController:rokEditTableViewController];
	}
	rokEditTableViewController.isEditing = isEditing;
	rokEditTableViewController.rok = rok;

	[rokArray removeAllObjects];
	[rokArray release];
	
	rokArray = nil;
	
	[self.navigationController presentModalViewController:rokNavController animated:YES];
}

- (void)viewDidLoad {
	iDzienniczekAppDelegate * appDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
	self.title = NSLocalizedString(@"Settings", @"Settings");
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.tableView.sectionFooterHeight = 10;
	configController = [[ConfigTableViewController alloc] init];
	configController.bind = appDelegate.config;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0: 
			return [rokArray count]+1;
		break;
			
		case 4: 
			return 2;
		break;
			
		default:
			return 1;
		break;
	}
}

- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section  {
	switch (section) {
		case 0:
			return NSLocalizedString(@"School year", @"");
		break;
		
		case 1:
			return NSLocalizedString(@"Break length", @"");
		break;
		
		case 2:
			return NSLocalizedString(@"Lesson length", @"");
		break;
			
		case 3:
			return NSLocalizedString(@"School days in weekday", @"");
		break;
		
		case 4:
			return NSLocalizedString(@"Backup", @"");
		break;
			
		default:
			return nil;
		break;
	}

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *MyIdentifier = @"MainCell";
	iDzienniczekAppDelegate * appDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	
	switch (indexPath.section) {
		case 0:
			if (indexPath.row == [rokArray count]) {
				cell.text = NSLocalizedString(@"Add new school year", @"");
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}else{
				Rok * r = [rokArray objectAtIndex:indexPath.row];
				
				if (r.ids == appDelegate.selected_rok.ids ){ 
					cell.accessoryType = UITableViewCellAccessoryCheckmark;
				}else{
					cell.accessoryType = UITableViewCellAccessoryNone;
				}
				cell.text = [NSString stringWithFormat: @"%@/%@", [r getStartRok],[r getKoniecRok]];
			}
		break;
			
		case 1: 
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			cell.text = [NSString stringWithFormat:@"%@ minut", [appDelegate.config objectForKey:@"przerwa"]];
		break;
		
		case 3: 
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			cell.text = [[appDelegate.config objectForKey:@"dni"] stringValue];
		break;
			
		case 2: 
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			cell.text = [NSString stringWithFormat:@"%@ minut", [appDelegate.config objectForKey:@"czasTrwaniaLekcji"]];
		break;
		
		case 4: 
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			if (indexPath.row == 0){
				cell.text = NSLocalizedString(@"Create backup", @"");
			}else{
				cell.text = NSLocalizedString(@"Restore backup", @"");
			}
		break;
		
		default:
			cell.text = NSLocalizedString(@"About", @"");
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		break;
	}


	// Set up the cell
	return cell;
}


 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	 NSMutableArray * temp;
	 switch (indexPath.section) {
		 case 0:
			 if (indexPath.row == [rokArray count]) {
				 [self beginEditinhWithRok:[[Rok alloc] initWithToday] isEditing:NO];
			 }else{
				 Rok * r = (Rok *)[rokArray objectAtIndex:indexPath.row];
				 if (self.editing) {
					 [self beginEditinhWithRok:r isEditing:YES];
				 }else{
					 iDzienniczekAppDelegate * appDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
					 appDelegate.selected_rok = r;
					 
					 [appDelegate.config setObject:[[NSNumber alloc] initWithInt:r.ids] forKey:@"selected"];
					 [tableView deselectRowAtIndexPath:indexPath animated:NO];
					 [tableView reloadData];
					 
				 }
			 }
		 break;
		 
		 case 1:
			 configController.title = NSLocalizedString(@"Break length", @"");
			 configController.key = @"przerwa";
			 
			 configController.values = nil;
			 temp = [[NSMutableArray alloc] init];
			 
			 for (int i = 1; i <= 11; i++) {
				 [temp addObject:[NSNumber numberWithInt:i*5]];
			 }
			 configController.values = [NSArray arrayWithArray:temp];
			 [self.navigationController pushViewController:configController animated:YES];
		 break;
		
		 case 2:
			 configController.title = NSLocalizedString(@"Lesson length", @"");
			 configController.key = @"czasTrwaniaLekcji";
			 
			 configController.values = nil;
			 temp = [[NSMutableArray alloc] init];
			 
			 for (int i = 4; i <= 22; i++) {
				 [temp addObject:[NSNumber numberWithInt:i*5]];
			 }
			 configController.values = [NSArray arrayWithArray:temp];
			 [self.navigationController pushViewController:configController animated:YES];
		break;	 
		
		 case 3:
			 configController.title = NSLocalizedString(@"School days in weekday", @"");
			 configController.key = @"dni";
			 
			 configController.values = nil;
			 temp = [[NSMutableArray alloc] init];
			 
			 for (int i = 5; i <= 6; i++) {
				 [temp addObject:[NSNumber numberWithInt:i]];
			 }
			 configController.values = [NSArray arrayWithArray:temp];
			 [self.navigationController pushViewController:configController animated:YES];
		break;
		
		 case 4: 
			 if (backup == nil){
				backup = [[BackupService alloc] init];
				backup.rok = self.tableView;
			 }
			 if(indexPath.row == 0){
				 [backup createBackup];
			 }else{
				 [backup restoreBackup];
			 }
	
		break;
		
		default:
			 if (informacjeController == nil){
				 informacjeController = [[InformacjeViewController alloc] init];
			 }
			 [self.navigationController pushViewController:informacjeController animated:YES];
		 break;
	 }


}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
		
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		iDzienniczekAppDelegate * appDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
		Rok * r = (Rok *)[rokArray objectAtIndex:indexPath.row];
		if (appDelegate.selected_rok.ids == r.ids){
			[appDelegate.config setObject:[[NSNumber alloc] initWithInt:-1] forKey:@"selected"];
			[appDelegate.selected_rok deleteFromDatabase];
			[appDelegate.selected_rok release];
			appDelegate.selected_rok = nil;
		}else{
			[r deleteFromDatabase];
			[rokArray removeObjectAtIndex:indexPath.row];
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		}
		
	}	
}




- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0:
			if (indexPath.row == [rokArray count]) {
				return NO;
			}else{
				return YES;
			}
		break;
		case 1:
			return NO;
		break;
		default:
			return NO;
		break;
	}

	
}



/*
 Override if you support rearranging the list
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
 Override if you support conditional rearranging of the list
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	// Return NO if you do not want the item to be re-orderable.
	return YES;
}
 */ 


- (void)viewWillAppear:(BOOL)animated {
	rokArray = [Rok findAll:-1];
	
	iDzienniczekAppDelegate * appDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (appDelegate.selected_rok == nil && [rokArray count] != 0){
		appDelegate.selected_rok = [rokArray objectAtIndex: 0];
		[appDelegate.config setObject:[[NSNumber alloc] initWithInt:appDelegate.selected_rok.ids] forKey:@"selected"];
	}
	[self.tableView reloadData];
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)viewDidDisappear:(BOOL)animated {
	[rokArray removeAllObjects];
	[rokArray release];
	[rokEditTableViewController release];
	[rokNavController release];
	rokNavController = nil;
	rokEditTableViewController = nil;
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
	[backup release];
	[informacjeController release];
	[rokNavController release];
	[rokEditTableViewController release];
	if (rokArray != nil){
		[rokArray removeAllObjects];
	}
	[configController release];
	[rokArray release];
	[super dealloc];
}


@end

