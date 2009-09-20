//
//  KontaktyPicker.m
//  iDzienniczek
//
//  Created by MacBury on 08-09-25.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "KontaktyPicker.h"


@implementation KontaktyPicker
@synthesize przedmiot;

- (void)viewDidLoad {
	[super viewDidLoad];
	[self setPeoplePickerDelegate:self];
}

/*
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
	[peoplePicker.navigationController dismissModalViewControllerAnimated:YES];
	
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
	
	//self.przedmiot.nauczyciel_id = ABRecordGetRecordID(person);  
	
	[peoplePicker.navigationController dismissModalViewControllerAnimated:YES]; 
	// Code to deal with the selected person.
	
	return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker 
      shouldContinueAfterSelectingPerson:(ABRecordRef)person 
                                property:(ABPropertyID)property 
                              identifier:(ABMultiValueIdentifier)identifier {
	
	return NO;
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
