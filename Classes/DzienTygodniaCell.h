//
//  DzienTygodniaCell.h
//  iDzienniczek
//
//  Created by MacBury on 08-08-10.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DzienTygodniaCell : UITableViewCell {
	UILabel * numerLekcji;
	UILabel * przedmiot;
	UILabel * czasTrwania;
	UILabel * sala;
}

@property (nonatomic, retain) UILabel * numerLekcji;
@property (nonatomic, retain) UILabel * przedmiot;
@property (nonatomic, retain) UILabel * czasTrwania;
@property (nonatomic, retain) UILabel * sala;

@end
