//
//  ConfigTableViewController.h
//  iDzienniczek
//
//  Created by MacBury on 08-09-05.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ConfigTableViewController : UITableViewController {
	NSString * key;
	NSUserDefaults * bind;
	NSArray * values;
}

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSUserDefaults * bind;
@property (nonatomic, retain) NSArray * values;
@end
