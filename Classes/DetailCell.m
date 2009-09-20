//
//  DetailCell.m
//  iDzienniczek
//
//  Created by MacBury on 08-09-19.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DetailCell.h"



@implementation DetailCell

@synthesize key, value;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		key = [[UILabel alloc] initWithFrame:CGRectZero];
		key.textAlignment = UITextAlignmentLeft;
		key.font = [UIFont boldSystemFontOfSize:15.0f];
		key.highlightedTextColor = [UIColor whiteColor];
		
		
		value = [[UILabel alloc] initWithFrame:CGRectZero];
		value.textAlignment = UITextAlignmentLeft;
		value.font = [UIFont systemFontOfSize:12.0f];
		value.highlightedTextColor = [UIColor whiteColor];
		value.textColor = [UIColor grayColor];
		
		[self.contentView addSubview:key];
		[self.contentView addSubview:value];
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	//if (self.editing){
		//key.frame = CGRectMake(11, 3, 274, 13);
		//value.frame = CGRectMake(145, 11, 132, 21);
	//}else{
		key.frame = CGRectMake(35, 4, 244, 16);
		value.frame = CGRectMake(35, 24, 274, 13);
	//}
	
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
