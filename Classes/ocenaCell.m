//
//  ocenaCell.m
//  iDzienniczek
//
//  Created by MacBury on 08-08-09.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ocenaCell.h"


@implementation ocenaCell

@synthesize ocena, zaco;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		ocena = [[UILabel alloc] initWithFrame:CGRectMake(11, 11, 145, 21)];
		ocena.textAlignment = UITextAlignmentLeft;
		ocena.font = [UIFont boldSystemFontOfSize:17.0f];
		ocena.highlightedTextColor = [UIColor whiteColor];
		
		zaco = [[UILabel alloc] initWithFrame:CGRectMake(165, 11, 132, 21)];
		zaco.textAlignment = UITextAlignmentRight;
		zaco.font = [UIFont systemFontOfSize:15.0f];
		zaco.highlightedTextColor = [UIColor whiteColor];
		zaco.textColor = [UIColor grayColor];
		[self.contentView addSubview:ocena];
		[self.contentView addSubview:zaco];
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}

	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	if (self.editing){
		ocena.frame = CGRectMake(11, 11, 145, 21);
		zaco.frame = CGRectMake(145, 11, 132, 21);
	}else{
		ocena.frame = CGRectMake(11, 11, 145, 21);
		zaco.frame = CGRectMake(165, 11, 132, 21);
	}
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

	[super setSelected:selected animated:animated];

	// Configure the view for the selected state
}


- (void)dealloc {
	[zaco release];
	[ocena release];
	[super dealloc];
}


@end
