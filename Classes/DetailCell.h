//
//  DetailCell.h
//  iDzienniczek
//
//  Created by MacBury on 08-09-19.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailCell : UITableViewCell {
	UILabel * key;
	UILabel * value;
}

@property (nonatomic, retain) UILabel * key;
@property (nonatomic, retain) UILabel * value;

@end
