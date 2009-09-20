//
//  Migration.h
//  iDzienniczek
//
//  Created by MacBury on 08-09-24.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface Migration : Model {
	int shemaVersion;
}
- (id) initWithShemaVersion:(int)version;
- (void)migrate;
- (bool)shouldMigrate;
- (const char *) prepareMigrateSQL;
@end
