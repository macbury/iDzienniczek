//
//  ocenaCell.h
//  iDzienniczek
//
//  Created by MacBury on 08-08-09.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ocenaCell : UITableViewCell {
	UILabel * ocena;
	UILabel * zaco;
}

@property (nonatomic, retain) UILabel * ocena;
@property (nonatomic, retain) UILabel * zaco;
@end
