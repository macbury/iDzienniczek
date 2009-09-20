//
//  DzienTygodniaCell.m
//  iDzienniczek
//
//  Created by MacBury on 08-08-10.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DzienTygodniaCell.h"


@implementation DzienTygodniaCell

@synthesize przedmiot, sala, numerLekcji, czasTrwania;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		przedmiot = [[UILabel alloc] initWithFrame:CGRectMake(35, 11, 210, 21)];
		przedmiot.textAlignment = UITextAlignmentLeft;
		przedmiot.font = [UIFont boldSystemFontOfSize:17.0f];
		przedmiot.highlightedTextColor = [UIColor whiteColor];
		[self.contentView addSubview:przedmiot];
		
		numerLekcji = [[UILabel alloc] initWithFrame:CGRectMake(4, 11, 29, 21)];
		numerLekcji.textAlignment = UITextAlignmentRight;
		numerLekcji.font = [UIFont boldSystemFontOfSize:17.0f];
		numerLekcji.highlightedTextColor = [UIColor whiteColor];
		[self.contentView addSubview:numerLekcji];
		
		czasTrwania = [[UILabel alloc] initWithFrame:CGRectMake(211, 3, 100, 21)];
		czasTrwania.textAlignment = UITextAlignmentRight;
		czasTrwania.font = [UIFont systemFontOfSize:13.0f];
		czasTrwania.textColor = [UIColor grayColor];
		czasTrwania.highlightedTextColor = [UIColor whiteColor];
		[self.contentView addSubview:czasTrwania];
		
		sala = [[UILabel alloc] initWithFrame:CGRectMake(211, 20, 100, 21)];
		sala.textAlignment = UITextAlignmentRight;
		sala.font = [UIFont systemFontOfSize:13.0f];
		sala.textColor = [UIColor colorWithRed:0.3f green:0.5f blue:0.8f alpha:1.0f];
		sala.highlightedTextColor = [UIColor whiteColor];
		[self.contentView addSubview:sala];
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	if (self.editing){
		przedmiot.frame = CGRectMake(11, 11, 210, 21);
		czasTrwania.frame = CGRectMake(181, 3, 100, 21);
		sala.frame = CGRectMake(181, 20, 100, 21);
		[numerLekcji setHidden: YES];

	}else{
		przedmiot.frame = CGRectMake(35, 11, 210, 21);
		czasTrwania.frame = CGRectMake(211, 3, 100, 21);
		sala.frame = CGRectMake(211, 20, 100, 21);
		[numerLekcji setHidden: NO];

	}
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

	[super setSelected:selected animated:animated];

	// Configure the view for the selected state
}


- (void)dealloc {
	[przedmiot release];
	[sala release];
	[numerLekcji release];
	[czasTrwania release];
	[super dealloc];
}


@end
