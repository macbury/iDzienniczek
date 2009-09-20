//
//  RokEditTableViewController.m
//  iDzienniczek
//
//  Created by MacBury on 08-08-02.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "RokEditTableViewController.h"


@implementation RokEditTableViewController

@synthesize isEditing, rok;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[datePicker setDate:[NSDate date]];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
		
		UIBarButtonItem * addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)] autorelease];
		self.navigationItem.rightBarButtonItem = addButton;
		
		UIBarButtonItem * cancelButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)] autorelease];
		self.navigationItem.leftBarButtonItem = cancelButton;
		
		
	}

    return self;
}

- (IBAction) dateChange:(id)sender{

	switch (selected) {
        case 0: rok.start = datePicker.date; break;
        case 1: rok.polrocze = datePicker.date; break;
        case 2: rok.koniec = datePicker.date;
    }
	[table reloadData];

}

- (IBAction) cancel:(id)sender{
	[rok release];
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (IBAction) save:(id)sender {
	[rok save];
	[rok release];
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	switch (indexPath.row) {
        case 0:
			poczatekLabelValue.text = [dateFormatter stringFromDate: rok.start];
			return poczatekDataCell;
		break;
        case 1:
			polroczeLabelValue.text = [dateFormatter stringFromDate: rok.polrocze];
			return polroczeDataCell;
		break;
        case 2: 
			koniecLabelValue.text = [dateFormatter stringFromDate: rok.koniec];
			return koniecDataCell;
		break;
    }
	
	return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	selected = indexPath.row;
	switch (indexPath.row) {
        case 0: datePicker.date = rok.start ; break;
        case 1: datePicker.date = rok.polrocze; break;
        case 2: datePicker.date = rok.koniec;
    }
}

- (void)dealloc {
	[dateFormatter release];
	[super dealloc];
}


- (void)viewDidLoad {
	[poczatekLabelName setFont:[UIFont boldSystemFontOfSize:17.0f]];
	[polroczeLabelName setFont:[UIFont boldSystemFontOfSize:17.0f]];
	[koniecLabelName setFont:[UIFont boldSystemFontOfSize:17.0f]];

	table.sectionHeaderHeight = 10;
	[super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
	[datePicker setDate:rok.start animated:NO];
	[table reloadData];
	selected = -1;
	[table selectRowAtIndexPath:0 animated:YES scrollPosition:UITableViewScrollPositionTop];
	selected = 0;
	if(isEditing){
		self.navigationItem.title = @"Edycja roku szkolnego";
	}else{
		self.navigationItem.title = @"Nowy rok szkolny";
	}

	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)viewDidDisappear:(BOOL)animated {

}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


@end

