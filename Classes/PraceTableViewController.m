//
//  PraceTableViewController.m
//  iDzienniczek
//
//  Created by MacBury on 08-09-01.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PraceTableViewController.h"


@implementation PraceTableViewController

@synthesize sortedPrace, dzisiaj;

- (NSMutableDictionary *) prepareList:(NSMutableArray *)praceArray {

	NSMutableDictionary * indexedPrace = [[NSMutableDictionary alloc] init];
	
	for (Prace * praca in praceArray){
		NSDateComponents * dateFilter = [[NSCalendar currentCalendar] components:(NSMonthCalendarUnit | NSYearCalendarUnit | NSDayCalendarUnit) 
																		fromDate:praca.koniec];
		NSDate * data = [[NSCalendar currentCalendar] dateFromComponents:dateFilter];
		NSMutableArray *indexArray = [indexedPrace objectForKey:data];
		if (indexArray == nil){
			indexArray = [[NSMutableArray alloc] init];
			[indexedPrace setObject:indexArray forKey:data];
		}
		[indexArray addObject:praca];
	} 
	
	if ([praceArray count] == 0){
		self.sortedPrace = nil;
		return nil;
	}else{
		self.sortedPrace = [[indexedPrace allKeys] sortedArrayUsingSelector:@selector(compare:)];
		return indexedPrace;
	}
}

- (void) beginEditing:(id)obj status:(int)status {
	if (editViewController == nil) {
		editViewController = [[PraceEditTableViewController alloc] init];
	}
	if (status == sNew){
		editViewController.title = NSLocalizedString(@"NewTask", @"NewTask");
	}else{
		editViewController.title = NSLocalizedString(@"EditTask", @"EditTask");
	}
	editViewController.praca = obj;
	
	[self.navigationController presentModalViewController:[self getModalNavController:editViewController] animated:YES];
}

- (IBAction) zmienSegment:(id)sender {
	[praceList removeAllObjects];
	[praceList release];
	praceList = nil;
	
	praceList = [self prepareList:[Prace findByWykonane:segemnty.selectedSegmentIndex]];
	[self.tableView reloadData];
	[self.tableView scrollToRowAtIndexPath:0 atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (praceList == nil){
		return 1;
	}else{
		return [self.sortedPrace count];
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (praceList == nil){
		return 0;
	}
	//NSMutableArray * prace = [[praceList allValues] objectAtIndex:section];
	
	NSMutableArray * prace = [praceList objectForKey:[self.sortedPrace objectAtIndex:section]];
	
	return [prace count];
}

- (NSString *)dzienTygodnia:(int)dzien {
	switch (dzien) {
		case 7:
			return NSLocalizedString(@"Saturday", @"Saturday");
		break;
		case 6:
			return NSLocalizedString(@"Friday", @"Friday");
		break;
		case 5:
			return NSLocalizedString(@"Thursday", @"Thursday");
		break;
		case 4:
			return NSLocalizedString(@"Wednesday", @"Wednesday");
		break;
		case 3:
			return NSLocalizedString(@"Tuesday", @"Tuesday");
		break;
		case 2:
			return NSLocalizedString(@"Monday", @"Monday");
		break;
		default:
			return NSLocalizedString(@"Sunday", @"Sunday");
		break;
	}
}

- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section  {
	if (praceList == nil){
		return nil;
	}
	
	NSDate * data = [self.sortedPrace objectAtIndex:section];
	
	//NSDate * data = [[praceList allKeys] objectAtIndex:section];
	
	if (self.dzisiaj == nil){
		NSDateComponents * dateFilter = [[NSCalendar currentCalendar] components:(NSMonthCalendarUnit | NSYearCalendarUnit | NSDayCalendarUnit) 
																		fromDate:[NSDate date]];
		self.dzisiaj = [[NSCalendar currentCalendar] dateFromComponents:dateFilter];
	}
	
	if ([data isEqualToDate:self.dzisiaj]){
		NSMutableString * title = [NSMutableString stringWithString:NSLocalizedString(@"Today", @"Today")];
		
		[title appendString:@", "];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[title appendString:[dateFormatter stringFromDate:data]];
		[dateFormatter setDateStyle:NSDateFormatterFullStyle];
		
		return title;
	}else{
		return [dateFormatter stringFromDate:data];
	}
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSMutableArray * prace = [praceList objectForKey:[self.sortedPrace objectAtIndex:indexPath.section]];
	
	Prace * praca = (Prace *)[prace objectAtIndex:indexPath.row];
	
	NSString *MyIdentifier =@"praceCell";
	
	DetailCell *cell = (DetailCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[DetailCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	
	//NSMutableArray * prace = [[praceList allValues] objectAtIndex:indexPath.section];
	
	
	cell.key.text = praca.nazwa;
	if (praca.opis == @"" || praca.opis == nil || [praca.opis length] == 0){
		cell.value.text = NSLocalizedString(@"BlankNote", @"BlankNote");
	}else{
		cell.value.text = praca.opis;
	}
	cell.image = (UIImage *)[piorytetImage objectAtIndex:praca.piorytet];

	
	return cell;
}

- (IBAction) add:(id)sender {
	if (mainDelegate.selected_rok == nil){
		UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"Info")
														  message:NSLocalizedString(@"NewYearNeedMsg", @"NewYearNeedMsg")
														 delegate:nil cancelButtonTitle:@"OK"
												otherButtonTitles:nil] autorelease];
		[alert show];
		return;
	}
	[self beginEditing:[[Prace alloc] init] status:sNew];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//NSMutableArray * prace = [[praceList allValues] objectAtIndex:indexPath.section];
	
	NSMutableArray * prace = [praceList objectForKey:[self.sortedPrace objectAtIndex:indexPath.section]];
	
	Prace * praca = (Prace *)[prace objectAtIndex:indexPath.row];
	if (tableView.editing){
		[self beginEditing:praca status:sEdit];
	}else{
		if (praceDetailView == nil){
			praceDetailView = [[PraceDetailView alloc] initWithStyle:UITableViewStyleGrouped];
		}
		praceDetailView.praca = praca;
		[self.navigationController pushViewController:praceDetailView animated:YES];
	}
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSMutableArray * prace = [praceList objectForKey:[self.sortedPrace objectAtIndex:indexPath.section]];
		//NSMutableArray * prace = [[praceList allValues] objectAtIndex:indexPath.section];
		
		Prace * praca = (Prace *)[prace objectAtIndex:indexPath.row];
		[praca deleteFromDatabase];
		[prace removeObjectAtIndex:indexPath.row];
		[tv deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		[mainDelegate refreshBadge];
	}
	
}


/*
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/
/*
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/


- (void)dealloc {
	[dateFormatter release];
	[editViewController release];
	[praceDetailView release];
	[piorytetImage removeAllObjects];
	[piorytetImage release];
	[super dealloc];
}


- (void)viewDidLoad {
	[super viewDidLoad];
	
	piorytetImage = [[NSMutableArray alloc] initWithCapacity:3];
	
	[piorytetImage addObject:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"p_normal" ofType:@"png"]]];
	[piorytetImage addObject:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"p_high" ofType:@"png"]]];
	[piorytetImage addObject:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"p_veryhigh" ofType:@"png"]]];
	
	dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterFullStyle];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)] autorelease];
	self.title = NSLocalizedString(@"Tasks", @"Tasks");
	
	[mainDelegate refreshBadge];
	
}

- (void)viewWillAppear:(BOOL)animated {
	praceList = [self prepareList:[Prace findByWykonane:segemnty.selectedSegmentIndex]];
	[mainDelegate refreshBadge];
	[super viewWillAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
	[praceList removeAllObjects];
	[praceList release];
	praceList = nil;
}

@end

