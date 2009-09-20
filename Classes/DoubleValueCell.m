//
//  DoubleValueCell.m
//  iDzienniczek
//
//  Created by MacBury on 08-08-10.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DoubleValueCell.h"


@implementation DoubleValueCell

@synthesize key, value;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		key = [[UILabel alloc] initWithFrame:CGRectMake(11, 11, 145, 21)];
		key.textAlignment = UITextAlignmentLeft;
		key.font = [UIFont boldSystemFontOfSize:17.0f];
		key.highlightedTextColor = [UIColor whiteColor];
		
		value = [[UILabel alloc] initWithFrame:CGRectMake(169, 11, 132, 21)];
		value.textAlignment = UITextAlignmentRight;
		value.font = [UIFont systemFontOfSize:17.0f];
		value.highlightedTextColor = [UIColor whiteColor];
		value.textColor = [UIColor colorWithRed:0.3f green:0.5f blue:0.7f alpha:1.0f];
		[self.contentView addSubview:key];
		[self.contentView addSubview:value];
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	if (self.editing){
		key.frame = CGRectMake(11, 11, 145, 21);
		value.frame = CGRectMake(145, 11, 132, 21);
	}else{
		key.frame = CGRectMake(11, 11, 145, 21);
		value.frame = CGRectMake(158, 11, 132, 21);
	}
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
	[super setSelected:selected animated:animated];
	
	// Configure the view for the selected state
}


- (void)dealloc {
	[value release];
	[key release];
	[super dealloc];
}


@end
