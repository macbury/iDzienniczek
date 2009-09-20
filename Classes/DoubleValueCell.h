//
//  DoubleValueCell.h
//  iDzienniczek
//
//  Created by MacBury on 08-08-10.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DoubleValueCell : UITableViewCell {
	UILabel * key;
	UILabel * value;
}

@property (nonatomic, retain) UILabel * key;
@property (nonatomic, retain) UILabel * value;

@end
