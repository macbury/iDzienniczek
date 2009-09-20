//
//  PraceDetailView.h
//  iDzienniczek
//
//  Created by MacBury on 08-09-07.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Prace.h"
#import "MainTableViewController.h"
#import "PraceEditTableViewController.h"

@interface PraceDetailView : MainTableViewController <UIActionSheetDelegate> {
	Prace * praca;
	UITextView *notatkaView;
	NSDateFormatter * dateFormatter;
	UIBarButtonItem * editButton;
	PraceEditTableViewController * editViewController;
	UIActionSheet * actionSheet;
}
- (IBAction) edit:(id)sender;
@property (nonatomic, retain) Prace * praca;

@end
