//
//  OcenyAddControllerView.h
//  iDzienniczek
//
//  Created by MacBury on 08-08-06.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OcenyDetailView.h"
#import "Rok.h"
@class iDzienniczekAppDelegate;
@interface OcenyAddControllerView : OcenyDetailView <UITextViewDelegate> {
	IBOutlet UIDatePicker * datePicker;
	IBOutlet UIPickerView * pickerView;
	
	NSArray * ocenyArray;
	NSArray * zaCoArray;
	
	NSInteger customDataSource;
}

- (IBAction) dateChange:(id)sender;
- (IBAction) save:(id)sender;

@end
