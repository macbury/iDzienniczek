//
//  KontaktyPicker.h
//  iDzienniczek
//
//  Created by MacBury on 08-09-25.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import "Przedmiot.h"
@interface KontaktyPicker : UIViewController{//ABPeoplePickerNavigationController<ABPeoplePickerNavigationControllerDelegate>{
	Przedmiot * przedmiot;
}
@property (nonatomic, retain)Przedmiot * przedmiot;
@end
