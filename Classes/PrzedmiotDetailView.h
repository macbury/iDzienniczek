//
//  PrzedmiotDetailView.h
//  iDzienniczek
//
//  Created by MacBury on 08-09-04.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTableViewController.h"
#import "Przedmiot.h"
#import "DoubleValueCell.h"

@interface PrzedmiotDetailView : MainTableViewController {
	Przedmiot * przedmiot;
}

@property (nonatomic, retain) Przedmiot * przedmiot;

@end
