//
//  dzienTygodniaTableViewController.h
//  iDzienniczek
//
//  Created by MacBury on 08-08-09.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dzienTygodniaViewController.h"
#import "MainTableViewController.h"
#define kMaxDays 5

@interface dniTygodniaTableViewController : MainTableViewController {
	dzienTygodniaViewController * dzienTygodnia;
	NSInteger maxDays;
	NSInteger dzisiaj;
}

- (NSString *) nazwaDzienTygodnia:(NSInteger)dzien;

@end
